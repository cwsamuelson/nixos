local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

-- Use config builder for clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

------------------
-- Visual Settings
------------------

-- Minimal UI like Kitty
config.enable_tab_bar = true
config.use_fancy_tab_bar = false  -- Simpler tab bar
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true

-- No window decorations chrome
-- Uncomment for more minimal:
-- config.window_decorations = "RESIZE"

-- GPU acceleration
config.front_end = "OpenGL"

-- Color scheme - pick one you like or leave default
-- config.color_scheme = 'Tomorrow Night'

-------------
-- Scrollback
-------------

config.scrollback_lines = 100000

--------------
-- Keybindings
--------------

config.keys = {
  -- Tab management
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'q',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentTab { confirm = true },
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivateTabRelative(-1),
  },

  -- Window management
  {
    key = 'Enter',
    mods = 'CTRL|SHIFT',
    action = act.SpawnWindow,
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentPane { confirm = true },
  },

  -- Scrollback viewing
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = act.ActivateCopyMode,
  },
  -- For "last command output" we'd need shell integration
  {
    key = 'g',
    mods = 'CTRL|SHIFT',
    action = act.ActivateCopyMode, -- For now, same as H
  },

  -- Search in scrollback
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = act.Search 'CurrentSelectionOrEmptyString',
  },

  -- Copy/Paste (standard)
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = act.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = act.PasteFrom 'Clipboard',
  },

  -- Scrolling with Shift+PageUp/PageDown
  {
    key = 'PageUp',
    mods = 'SHIFT',
    action = act.ScrollByPage(-1),
  },
  {
    key = 'PageDown',
    mods = 'SHIFT',
    action = act.ScrollByPage(1),
  },
}

------------------------
-- Copy Mode Keybindings
------------------------

-- The defaults are vim-like
-- https://wezfurlong.org/wezterm/copymode.html

------------------------------
-- Optional: Shell Integration
------------------------------

-- WezTerm supports shell integration
-- Enables semantic prompts and command tracking
-- https://wezfurlong.org/wezterm/shell-integration.html

--------------------------------
-- Cross-platform considerations
--------------------------------

-- Detect platform and adjust if needed
local function is_windows()
  return wezterm.target_triple:find("windows") ~= nil
end

if is_windows() then
  -- config.default_prog = { 'pwsh' }
  -- config.default_prog = { 'wsl', '-d', 'Debian' }
  -- config.default_prog = { 'wsl', '-d', 'NixOS' }
  config.default_prog = { 'bash', '-l' }
end

---------------------------
-- Additional nice-to-haves
---------------------------

-- Slightly increase opacity
-- config.window_background_opacity = 0.95

-- Cursor style
config.default_cursor_style = 'BlinkingBlock'

-- Disable audible bell
config.audible_bell = 'Disabled'

---------------------
-- Font configuration
---------------------

-- Examples:
-- config.font = wezterm.font 'JetBrains Mono'
-- config.font = wezterm.font 'Fira Code'
-- config.font = wezterm.font 'Cascadia Code'
config.font_size = 20.0

return config
