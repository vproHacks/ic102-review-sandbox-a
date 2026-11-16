# Files copied from elsewhere

| File here | Copied from |
|---|---|
| `init.tcl` | Tiny Tapeout's `tech/sky130A/def/analog/magic_init_project.tcl`, with its settings block changed: the top cell's name, and the two power stripes moved to x = 112 um (VDPWR) and 100 um (VGND) |
| `tt_analog_1x2.def` | Tiny Tapeout's `tech/sky130A/def/analog/tt_analog_1x2.def`, unchanged |
| `cells/ic102_inv.mag` | AD104 Lab 03's reference inverter, `labs/lab-03-draw-an-inverter/solutions/inv_ref.mag` in https://github.com/uoftasic/ad104, renamed |
| `build.tcl`, `drc.tcl`, `extract.tcl`, `../Makefile` | IC102-A Lab 01's layout kit, `labs/lab-01-your-repo-from-the-template/kit/` in https://github.com/uoftasic/ic102-a |

Tiny Tapeout's two files come from https://github.com/TinyTapeout/tt-support-tools at commit
`9d13ff3e3e6202090740110438c6a10c1d62ca0f`, which is licensed under Apache-2.0, like this
repository.
