-- Game mode for Omarchy 4.x / Hyprland 0.56 (Lua config).
--
-- While a game window is fullscreen, Hyprland enters the "game" submap:
-- every normal keybind (workspaces, focus, tabs, capture...) is off, and
-- only the keys bound inside the submap work. Leaving fullscreen, or
-- closing the game, restores the normal binds automatically.
--
-- Drop this file at ~/.dotfiles/.config/hypr/game-mode.lua (or
-- ~/.config/hypr/game-mode.lua) and add this line to ~/.config/hypr/hyprland.lua
-- after the Omarchy requires:
--
--   require("hypr.game-mode")
--
-- Escape hatch: SUPER + SHIFT + S, bound by XKB keycode 39 so it still works
-- on the Russian layout, plus SUPER + SHIFT + F12.
-- If you ever get stuck: hyprctl dispatch 'hl.dsp.submap("reset")'

local SUBMAP = "game"

-- Window classes that count as games. Hyprland matches class names with
-- full-match regexes, so these are prefixes/handful of exact names.
local game_classes = {
  "^steam_app_",  -- Steam and Proton games (XWayland)
  "^gamescope",   -- games launched through gamescope
  "^com%.libretro%.RetroArch$",
}

-- A game is in game mode when one of its windows is really fullscreen
-- (fullscreen state 2) or maximized-and-fullscreen (3). State 1 is maximize only.
local function is_game(window)
  if not window or not window.class then
    return false
  end

  for _, pattern in ipairs(game_classes) do
    if window.class:match(pattern) then
      return true
    end
  end

  return false
end

local function game_fullscreen()
  for _, window in ipairs(hl.get_windows()) do
    if is_game(window) and (window.fullscreen or 0) >= 2 then
      return true
    end
  end

  return false
end

-- Manual game mode (for borderless games that never set the fullscreen bit),
-- and a guard so leaving game mode by hand does not bounce straight back.
local forced = false
local suppressed = false

local function enter()
  if hl.get_current_submap() == SUBMAP then
    return
  end

  hl.dispatch(hl.dsp.submap(SUBMAP))
  hl.exec_cmd("notify-send -a 'Game mode' 'Game mode on' 'Window keybinds are off. SUPER + SHIFT + S to leave.'")
end

local function leave()
  if hl.get_current_submap() ~= SUBMAP then
    return
  end

  hl.dispatch(hl.dsp.submap("reset"))
  hl.exec_cmd("notify-send -a 'Game mode' 'Game mode off' 'Window keybinds are back.'")
end

local function sync()
  if not game_fullscreen() then
    suppressed = false
  end

  if (forced or game_fullscreen()) and not suppressed then
    enter()
  elseif not forced and not game_fullscreen() then
    leave()
  end
end

local function exit_game_mode()
  forced, suppressed = false, true
  leave()
end

hl.define_submap(SUBMAP, function()
  -- The only ways out while the submap is active. Google Maps owns
  -- SUPER + SHIFT + S globally, but globals are off inside the submap.
  -- code:39 is the XKB keycode for S, so the layout does not matter.
  hl.bind("SUPER + SHIFT + code:39", exit_game_mode)
  hl.bind("SUPER + SHIFT + F12", exit_game_mode)

  -- Keep the hardware keys alive: they are ordinary binds too, so the submap
  -- would otherwise swallow volume and brightness during play.
  o.bind("XF86AudioRaiseVolume", nil, { audio = "raise" }, { locked = true, repeating = true })
  o.bind("XF86AudioLowerVolume", nil, { audio = "lower" }, { locked = true, repeating = true })
  o.bind("XF86AudioMute", nil, { audio = "mute-toggle" }, { locked = true })
  o.bind("XF86MonBrightnessUp", nil, { brightness = "raise" }, { locked = true, repeating = true })
  o.bind("XF86MonBrightnessDown", nil, { brightness = "lower" }, { locked = true, repeating = true })
end)

-- Manual toggle, for games that run borderless and never become fullscreen.
hl.bind("SUPER + SHIFT + F12", function()
  if hl.get_current_submap() == SUBMAP then
    forced, suppressed = false, true
    leave()
  else
    forced, suppressed = true, false
    enter()
  end
end)

hl.on("window.fullscreen", sync)
hl.on("window.open", sync)
hl.on("window.close", sync)
hl.on("config.reloaded", sync)
hl.on("hyprland.start", sync)

-- Screensaver fix for games, including borderless ones. Omarchy's stock rule
-- only matches the Steam client (class "steam"), not steam_app_* or gamescope.
-- Every Steam/Proton game also opens on workspace 3 and brings you there.
o.window("steam_app_.*", { workspace = "3", idle_inhibit = "focus" })
o.window("gamescope", { workspace = "3", idle_inhibit = "focus" })

-- Optional: let the compositor hand fullscreen games straight to the display.
-- Upstream Omarchy has this in review; disable it if a game shows glitches.
hl.config({ render = { direct_scanout = 2 } })
