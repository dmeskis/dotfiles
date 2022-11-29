local act = wezterm.action

return {
  color_scheme = "Gruvbox dark, medium (base16)",
  font_size = 13.0,
  leader = { key = 'a', mods = 'CMD' },
  keys = {
    {
      key = '|',
      mods = 'LEADER',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = '-',
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'h', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 },
    },
    {
      key = 'j', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 },
    },
    { key = 'k', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
    {
      key = 'l', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 },
    },
    {
        key = 'w',
        mods = 'CMD',
        action = act.CloseCurrentPane { confirm = true },
    },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-0.5) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(0.5) },
  },
}

