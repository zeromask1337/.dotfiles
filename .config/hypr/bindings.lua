-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- Window management is mouse-only by choice. The only window bindings left are
--   SUPER + grave         toggle the Quake console
--   SUPER + SHIFT + grave move the active window to the Quake console
--   SUPER + drag          move a window
--   SUPER + right drag    resize a window
-- Everything else window-related is unbound below, including the Alt layer
-- ported from aerospace and the earlier tab/workspace cycling swaps.

-- Focus and swap (Super + arrows, Super + Shift + arrows).
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")

-- Workspaces (Super + digits, Super + Shift + digits).
for code = 10, 19 do
  hl.unbind("SUPER + code:" .. code)
  hl.unbind("SUPER + SHIFT + code:" .. code)
end

-- Window and workspace cycling.
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
hl.unbind("SUPER + CTRL + TAB")
hl.unbind("SUPER + ALT + TAB")
hl.unbind("SUPER + ALT + SHIFT + TAB")
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")
hl.unbind("SUPER + mouse_down")
hl.unbind("SUPER + mouse_up")

-- Layout, floating, fullscreen, grouping, scratchpad.
hl.unbind("SUPER + J")
hl.unbind("SUPER + P")
hl.unbind("SUPER + T")
hl.unbind("SUPER + F")
hl.unbind("SUPER + CTRL + F")
hl.unbind("SUPER + ALT + F")
hl.unbind("SUPER + O")
hl.unbind("SUPER + G")
hl.unbind("SUPER + ALT + G")
hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
hl.unbind("SUPER + M")
hl.unbind("SUPER + Home")
hl.unbind("SUPER + ALT + Home")
hl.unbind("SUPER + L")
hl.unbind("SUPER + ALT + L")

-- Move window into a group (Super + Alt + arrows, Super + Alt + mouse wheel).
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
hl.unbind("SUPER + ALT + mouse_down")
hl.unbind("SUPER + ALT + mouse_up")

-- Move window (Super + Shift + Ctrl + arrows) and workspace
-- (Super + Shift + Alt + arrows) between monitors.
hl.unbind("SUPER + SHIFT + CTRL + LEFT")
hl.unbind("SUPER + SHIFT + CTRL + RIGHT")
hl.unbind("SUPER + SHIFT + CTRL + UP")
hl.unbind("SUPER + SHIFT + CTRL + DOWN")
hl.unbind("SUPER + SHIFT + ALT + LEFT")
hl.unbind("SUPER + SHIFT + ALT + RIGHT")
hl.unbind("SUPER + SHIFT + ALT + UP")
hl.unbind("SUPER + SHIFT + ALT + DOWN")

-- Move window silently to a workspace, and jump to a grouped window.
for code = 10, 19 do
  hl.unbind("SUPER + SHIFT + ALT + code:" .. code)
end
for index = 10, 14 do
  hl.unbind("SUPER + ALT + code:" .. index)
end

-- Resize (Super + minus/equal and every modifier variant).
hl.unbind("SUPER + code:20")
hl.unbind("SUPER + code:21")
for _, modifiers in ipairs({
  "SUPER + SHIFT",
  "SUPER + ALT",
  "SUPER + SHIFT + ALT",
  "SUPER + CTRL",
  "SUPER + SHIFT + CTRL",
  "SUPER + CTRL + SHIFT",
}) do
  hl.unbind(modifiers .. " + code:20")
  hl.unbind(modifiers .. " + code:21")
end

-- macOS-style capture keys.
-- SUPER + SHIFT + 3: full desktop (focused monitor), saved and copied.
-- SUPER + SHIFT + 4: region with the pointer, saved and copied.
-- SUPER + SHIFT + 5: start/stop a screen recording (region picker on start).
o.bind("SUPER + SHIFT + 3", "Screenshot (full screen)", "omarchy capture screenshot fullscreen")
o.bind("SUPER + SHIFT + 4", "Screenshot (region)", "omarchy capture screenshot region")
o.bind("SUPER + SHIFT + 5", "Screen recording", "omarchy capture screenrecording --stop-recording || omarchy capture screenrecording")

-- Alt + number switches workspaces. Bound here because the window-management
-- cleanup left Alt + 1..9 free for apps, and Zen claims them for its own tabs.
for slot = 1, 9 do
  o.bind("ALT + " .. slot, "Switch to workspace " .. slot, o.workspaces.focus(slot))
end
o.bind("ALT + 0", "Switch to workspace 10", o.workspaces.focus(10))

-- macOS-style editing and tab shortcuts (Cmd -> Super).
-- SUPER + W was Omarchy's "Close window"; Ctrl + W is forwarded instead.
hl.unbind("SUPER + W")

-- Undo.
o.bind("SUPER + z", "Undo", hl.dsp.send_shortcut({ mods = "CTRL", key = "z" }))

-- Tabs.
o.bind("SUPER + t", "New tab", hl.dsp.send_shortcut({ mods = "CTRL", key = "t" }))
o.bind("SUPER + w", "Close tab", hl.dsp.send_shortcut({ mods = "CTRL", key = "w" }))

-- Cursor navigation in text fields: line start/end on Left/Right,
-- document start/end on Up/Down.
o.bind("SUPER + LEFT", "Line start", hl.dsp.send_shortcut({ mods = "", key = "Home" }))
o.bind("SUPER + RIGHT", "Line end", hl.dsp.send_shortcut({ mods = "", key = "End" }))
o.bind("SUPER + UP", "Document start", hl.dsp.send_shortcut({ mods = "CTRL", key = "Home" }))
o.bind("SUPER + DOWN", "Document end", hl.dsp.send_shortcut({ mods = "CTRL", key = "End" }))

-- Word navigation in text fields (macOS Option + arrow): forward Ctrl + arrow.
o.bind("ALT + LEFT", "Word left", hl.dsp.send_shortcut({ mods = "CTRL", key = "Left" }))
o.bind("ALT + RIGHT", "Word right", hl.dsp.send_shortcut({ mods = "CTRL", key = "Right" }))

-- Word deletion (macOS Option + Backspace/Delete): forward Ctrl + Backspace/Delete.
o.bind("ALT + BACKSPACE", "Delete word left", hl.dsp.send_shortcut({ mods = "CTRL", key = "BackSpace" }))
o.bind("ALT + Delete", "Delete word right", hl.dsp.send_shortcut({ mods = "CTRL", key = "Delete" }))

-- Delete to line start/end (macOS Cmd + Backspace/Delete): select to the edge,
-- then delete. SUPER + BACKSPACE was Omarchy's "Toggle transparency on a window".
hl.unbind("SUPER + BACKSPACE")
o.bind("SUPER + BACKSPACE", "Delete to line start", function()
  hl.dispatch(hl.dsp.send_shortcut({ mods = "SHIFT", key = "Home" }))
  hl.dispatch(hl.dsp.send_shortcut({ mods = "", key = "BackSpace" }))
end)
o.bind("SUPER + Delete", "Delete to line end", function()
  hl.dispatch(hl.dsp.send_shortcut({ mods = "SHIFT", key = "End" }))
  hl.dispatch(hl.dsp.send_shortcut({ mods = "", key = "Delete" }))
end)

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end
