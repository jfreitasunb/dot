# -*- coding: utf-8 -*-

# Widget configuration.
# Each widget is defined as a variable, this gets used later in config.py
# See https://docs.qtile.org for more information about Qtile widgets.

logo = widget.TextBox(
    text="  ",
    font="JetBrainsMono Nerd Font",
    fontsize=20,
    background=colors[10],  # focus/accent
    foreground=colors[0],  # focus/accent
    margin=4,
    padding=3,
    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(f"{applauncher}")},
    **slash_powerlineRight,
)

workspaces = widget.GroupBox(
    highlight_method='text',
    active=colors[1],               # gray
    highlight_color=colors[0],      # bg
    padding=4,
    this_current_screen_border=colors[6],  # blue
    background=colors[12],
    **slash_powerlineLeft,
)

prompt = widget.Prompt()

separator = widget.TextBox(
    text="|",
    foreground="#8d8d8d"
)

window_title = widget.WindowName(
    background=colors[14],  # alt-bg
    padding=6,
    **slash_powerlineRight,
)

chord = widget.Chord(
    background=colors[3],  # red
    name_transform=lambda name: name.upper(),
)

systray = widget.Systray(**arrow_powerlineRight)

layout = widget.CurrentLayout(
    **slash_powerlineRight,
    padding=10,
    fmt="  {}",
    foreground=colors[0],       # bg
    background=colors[7],       # magenta
)

volume = widget.Volume(
    **slash_powerlineRight,
    fmt="  {}",
    foreground=colors[0],       # bg
    background=colors[5],       # yellow
)

battery = widget.Battery(
    **slash_powerlineRight,
    charge_char="",
    discharge_char="",
    format="  {percent:2.0%}",
    foreground=colors[0],       # bg
    background=colors[4],       # green
)

clock = widget.Clock(
    format="  %A %I:%M %p",
    foreground=colors[0],       # bg
    padding=12,
    background=colors[9],       # orange
)

