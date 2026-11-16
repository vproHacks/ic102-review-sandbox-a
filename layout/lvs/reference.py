#!/usr/bin/env python3
"""Write the sandbox's LVS reference netlist to stdout, for `make lvs`.

    python3 layout/lvs/reference.py TOP_MODULE > layout/build/reference.spice

The sandbox's circuit depends on who has claimed which slot, so the reference
is written from layout/slots.tcl each time instead of being kept in git: the
anchor inverter between ua[0] and ua[1], one inverter per claimed slot K
between ui_in[K] and uo_out[K], and a 0-ohm tie to VGND for every other digital
output. Every cell is expected to be the AD104 inverter: if you change the
devices in yours, change them here too, or LVS will report the difference.
"""
import re
import sys
from pathlib import Path

INVERTER = """.subckt {name} A Y VPWR VGND
XM1 Y A VGND VGND sky130_fd_pr__nfet_01v8     w=0.65 l=0.15
XM2 Y A VPWR VPWR sky130_fd_pr__pfet_01v8_hvt w=1    l=0.15
.ends
"""

top = sys.argv[1]
slots = re.findall(r"^\s*slot\s+(\d)\s+(\S+)", Path("layout/slots.tcl").read_text(), re.M)

ports = (["VGND", "VDPWR"] + [f"ui_in[{i}]" for i in range(8)] + [f"uo_out[{i}]" for i in range(8)]
         + [f"uio_in[{i}]" for i in range(8)] + [f"uio_out[{i}]" for i in range(8)]
         + [f"uio_oe[{i}]" for i in range(8)] + [f"ua[{i}]" for i in range(8)] + ["ena", "clk", "rst_n"])

print("* Written by layout/lvs/reference.py from layout/slots.tcl. Don't edit; it's rewritten by make lvs.")
for name in ["ic102_inv"] + sorted({cell for _, cell in slots}):
    print(INVERTER.format(name=name))
print(f".subckt {top} " + " ".join(ports))
print("Xanchor ua[0] ua[1] VDPWR VGND ic102_inv")
driven = set()
for k, cell in slots:
    print(f"Xslot{k} ui_in[{k}] uo_out[{k}] VDPWR VGND {cell}")
    driven.add(f"uo_out[{k}]")
n = 0
for bus in ("uo_out", "uio_out", "uio_oe"):
    for i in range(8):
        pin = f"{bus}[{i}]"
        if pin not in driven:
            print(f"Rtie{n} {pin} VGND 0")
            n += 1
print(".ends")
