-- items/media.lua — Felix's now-playing widget, driven by media-control
-- (SketchyBar's built-in media_change event and nowplaying-cli stopped
-- working in macOS 15.4, when Apple locked down the MediaRemote framework.)

local icons = require("icons")
local colors = require("colors")

-- Bundle IDs of players to show. Leave the table empty to show any app
-- (browsers, podcasts, YouTube, ...).
local whitelist = {
  ["com.spotify.client"] = true,
  ["com.apple.Music"] = true,
}

-- true: keep showing the widget while paused
local show_when_paused = false

local ARTWORK_SCALE = 0.5   -- helper makes 52px covers -> 26pt
local APP_ICON_SCALE = 0.85

local function allowed(app)
  return next(whitelist) == nil or whitelist[app] == true
end

-- Start the background provider that fires `media_update`
sbar.add("event", "media_update")
-- (the script stops any previous instance itself)
sbar.exec("$CONFIG_DIR/helpers/media_stream.sh >/dev/null 2>&1 &")

local media_cover = sbar.add("item", {
  position = "right",
  background = {
    image = { scale = ARTWORK_SCALE },
    color = colors.transparent,
  },
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  updates = true,
  popup = {
    align = "center",
    horizontal = true,
  }
})

local media_artist = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,  -- artist sits on top of the title (title sets the width)
  icon = { drawing = false },
  label = {
    font = { size = 9 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 18,
    y_offset = 6,
  },
})

local media_title = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = 11 },
    max_chars = 16,
    y_offset = -5,
  },
})

sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.back },
  label = { drawing = false },
  click_script = "media-control previous-track",
})
sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  click_script = "media-control toggle-play-pause",
})
sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  click_script = "media-control next-track",
})

media_cover:subscribe("media_update", function(env)
  local playing = env.STATE == "playing"
  local drawing = allowed(env.APP)
    and (playing or (show_when_paused and env.STATE == "paused"))

  media_artist:set({ drawing = drawing, label = env.ARTIST or "" })
  media_title:set({ drawing = drawing, label = env.TITLE or "" })

  -- Cover art, or the player's app icon until the artwork arrives
  local cover = { drawing = drawing }
  if env.ARTWORK and env.ARTWORK ~= "" then
    cover.background = { image = { string = env.ARTWORK, scale = ARTWORK_SCALE } }
  elseif env.APP and env.APP ~= "" then
    cover.background = { image = { string = "app." .. env.APP, scale = APP_ICON_SCALE } }
  end
  media_cover:set(cover)

  if not drawing then
    media_cover:set({ popup = { drawing = false } })
  end
end)

media_cover:subscribe("mouse.clicked", function(env)
  media_cover:set({ popup = { drawing = "toggle" }})
end)

media_title:subscribe("mouse.exited.global", function(env)
  media_cover:set({ popup = { drawing = false }})
end)
