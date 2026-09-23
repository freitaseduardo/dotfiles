-- items/spaces.lua — AeroSpace version of FelixKratz's spaces item
-- Replaces native macOS space items + yabai calls with AeroSpace workspaces.

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Keep in sync with `persistent-workspaces` in ~/.config/aerospace/aerospace.toml.
-- Hard-coded (instead of asking `aerospace list-workspaces`) so the bar builds
-- correctly even if SketchyBar starts before AeroSpace at login.
local workspaces = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

sbar.add("event", "aerospace_workspace_change") -- fired by exec-on-workspace-change
sbar.add("event", "aerospace_windows_change")   -- fired by move-node-to-workspace binds

local spaces = {}
local brackets = {}
local paddings = {}

local focused_ws = nil
local occupied = {}        -- occupied[ws] = true when the workspace has windows
local menus_shown = false  -- Felix's menus/spaces swap: hide all spaces while menus show

-- Show a workspace only if it has windows or is the focused one
local function apply_visibility()
  for ws, space in pairs(spaces) do
    local visible = (not menus_shown) and (occupied[ws] or ws == focused_ws) or false
    space:set({ drawing = visible })
    brackets[ws]:set({ drawing = visible })
    paddings[ws]:set({ drawing = visible })
  end
end

local function highlight(focused)
  focused_ws = focused
  for ws, space in pairs(spaces) do
    local selected = ws == focused
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { border_color = selected and colors.black or colors.bg2 },
    })
    brackets[ws]:set({
      background = { border_color = selected and colors.grey or colors.bg2 },
    })
  end
  apply_visibility()
end

-- One CLI call updates every workspace's app icons
local function refresh_windows()
  sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(out)
    local apps = {}
    if type(out) == "string" then
      for line in out:gmatch("[^\r\n]+") do
        local ws, app = line:match("^(.-)|(.*)$")
        if ws and spaces[ws] then
          apps[ws] = apps[ws] or {}
          apps[ws][app] = true
        end
      end
    end

    occupied = {}
    for ws in pairs(apps) do occupied[ws] = true end

    sbar.animate("tanh", 10, function()
      apply_visibility()
      for ws, space in pairs(spaces) do
        local icon_line = ""
        for app in pairs(apps[ws] or {}) do
          icon_line = icon_line .. (app_icons[app] or app_icons["Default"])
        end
        space:set({ label = (icon_line == "") and " —" or icon_line })
      end
    end)
  end)
end

for _, ws in ipairs(workspaces) do
  local space = sbar.add("item", "space." .. ws, {
    icon = {
      font = { family = settings.font.numbers },
      string = ws,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
  })
  spaces[ws] = space

  -- Single item bracket for the double border on highlight
  brackets[ws] = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    },
  })

  -- Padding (named space.* so the menus/spaces swap hides it too)
  paddings[ws] = sbar.add("item", "space.padding." .. ws, {
    width = settings.group_paddings,
  })

  -- Left click: go to workspace. Right click: send focused window there.
  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" then
      sbar.exec("aerospace move-node-to-workspace " .. ws, refresh_windows)
    else
      sbar.exec("aerospace workspace " .. ws)
    end
  end)
end

local observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

observer:subscribe({
  "aerospace_workspace_change",
  "aerospace_windows_change",
  "space_windows_change", -- still fires when windows open/close
  "front_app_switched",
  "system_woke",
  "swap_menus_and_spaces",
}, function(env)
  if env.SENDER == "swap_menus_and_spaces" then
    -- menus.lua redraws every space.* item when switching back;
    -- refresh_windows() below re-hides the empty ones afterwards.
    menus_shown = not menus_shown
  end
  if env.SENDER == "aerospace_workspace_change" and env.FOCUSED_WORKSPACE then
    highlight(env.FOCUSED_WORKSPACE)
  end
  refresh_windows()
end)

-- Initial state
sbar.exec("aerospace list-workspaces --focused", function(out)
  if type(out) == "string" then
    local ws = out:match("%S+")
    if ws then highlight(ws) end
  end
end)
refresh_windows()

-- Spaces/menus switch indicator (unchanged from Felix's config)
local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
