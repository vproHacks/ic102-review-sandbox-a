# layout/wires.tcl for the IC102-A Lab 04 sandbox. You don't edit this file in
# Lab 04: you claim a slot in layout/slots.tcl, and the `slot` command below
# places your cell there and wires it.
#
# The tile holds:
#   - the anchor: the course's inverter, between ua[0] and ua[1], so that the
#     project has analog pins for precheck's analog pin check to look at;
#   - up to eight slots, one per pair of digital pins: slot K is an inverter
#     with its input on ui_in[K] and its output on uo_out[K];
#   - ties from every unused uo_out, and every uio_out and uio_oe, to VGND.
#
# init.tcl draws the VGND stripe at x = 100 to 102 um and the VDPWR stripe at
# x = 112 to 114 um. Every cell sits between them, at x = 105, with its metal1
# rails extended to a stack of vias on each stripe.

# connect_power X Y: extend the rails of the 3 x 6 um cell at (X, Y) to the
# two stripes, and climb onto each through via1, via2 and via3.
proc connect_power {x y} {
    p metal1 100.4 $y $x [expr {$y + 0.4}]
    foreach layer {metal1 metal2 metal3} { p $layer 100.4 [expr {$y - 0.4}] 101.6 [expr {$y + 0.8}] }
    foreach layer {via1 via2 via3}       { p $layer 100.7 [expr {$y - 0.1}] 101.3 [expr {$y + 0.5}] }
    p metal1 [expr {$x + 3}] [expr {$y + 5.6}] 113.6 [expr {$y + 6.0}]
    foreach layer {metal1 metal2 metal3} { p $layer 112.4 [expr {$y + 5.2}] 113.6 [expr {$y + 6.4}] }
    foreach layer {via1 via2 via3}       { p $layer 112.7 [expr {$y + 5.5}] 113.3 [expr {$y + 6.1}] }
}

# contact_to_metal2 XC YC: from a locali pad centred at (XC, YC) up to metal2.
proc contact_to_metal2 {xc yc} {
    p locali [expr {$xc - 0.185}] [expr {$yc - 0.185}] [expr {$xc + 0.185}] [expr {$yc + 0.185}]
    p mcon   [expr {$xc - 0.085}] [expr {$yc - 0.085}] [expr {$xc + 0.085}] [expr {$yc + 0.085}]
    p metal1 [expr {$xc - 0.2}]   [expr {$yc - 0.2}]   [expr {$xc + 0.2}]   [expr {$yc + 0.2}]
    p via1   [expr {$xc - 0.13}]  [expr {$yc - 0.13}]  [expr {$xc + 0.13}]  [expr {$yc + 0.13}]
}

# metal2_to_metal4 XC YC: a stack from metal2 up to metal4, centred at (XC, YC).
proc metal2_to_metal4 {xc yc} {
    foreach layer {metal2 metal3 metal4} {
        p $layer [expr {$xc - 0.3}] [expr {$yc - 0.3}] [expr {$xc + 0.3}] [expr {$yc + 0.3}]
    }
    p via2 [expr {$xc - 0.16}] [expr {$yc - 0.16}] [expr {$xc + 0.16}] [expr {$yc + 0.16}]
    p via3 [expr {$xc - 0.18}] [expr {$yc - 0.18}] [expr {$xc + 0.18}] [expr {$yc + 0.18}]
}

# ------------------------------------------------------------------ the anchor
# The inverter from Lab 03 at (105, 10): A to ua[0] (x 151.81 to 152.71) and Y
# to ua[1] (x 132.49 to 133.39), both eastwards on metal2, then down metal4 to
# the pins on the bottom edge.
place ic102_inv 105 10 anchor
connect_power 105 10
contact_to_metal2 106.425 12.525
p metal2 106.2 12.3 152.56 12.75
metal2_to_metal4 152.26 12.525
p metal4 151.81 0 152.71 12.8
contact_to_metal2 107.365 13.485
p metal2 107.2 13.26 133.24 13.71
metal2_to_metal4 132.94 13.485
p metal4 132.49 0 133.39 13.78

# ------------------------------------------------------------------- the slots
# x centres of the pins on the top edge, from tt_analog_1x2.def.
set UI_IN_X  {138.46 135.70 132.94 130.18 127.42 124.66 121.90 119.14}
set UO_OUT_X {94.30 91.54 88.78 86.02 83.26 80.50 77.74 74.98}
set CLAIMED {}

# slot K CELL: place CELL (layout/cells/CELL.mag) in slot K, at (105, 40 + 20K),
# with its input A on ui_in[K] and its output Y on uo_out[K]. Each signal
# leaves the cell on metal2, climbs to metal4 under its pin, and runs straight
# up the tile to the pin on the top edge.
proc slot {k cell} {
    global UI_IN_X UO_OUT_X CLAIMED
    if {$k < 0 || $k > 7} { error "slot $k: slots are numbered 0 to 7" }
    if {[lsearch -exact $CLAIMED "uo_out\[$k\]"] >= 0} { error "slot $k is claimed twice in slots.tcl" }
    lappend CLAIMED "uo_out\[$k\]"
    set y [expr {40 + 20 * $k}]
    place $cell 105 $y "slot$k"
    connect_power 105 $y
    # A: east on metal2 to ui_in[K], then up.
    set xi [lindex $UI_IN_X $k]
    contact_to_metal2 106.425 [expr {$y + 2.525}]
    p metal2 106.2 [expr {$y + 2.3}] [expr {$xi + 0.3}] [expr {$y + 2.75}]
    metal2_to_metal4 $xi [expr {$y + 2.525}]
    p metal4 [expr {$xi - 0.15}] [expr {$y + 2.525}] [expr {$xi + 0.15}] 224.76
    # Y: west on metal2 to uo_out[K], then up.
    set xo [lindex $UO_OUT_X $k]
    contact_to_metal2 107.365 [expr {$y + 3.485}]
    p metal2 [expr {$xo - 0.3}] [expr {$y + 3.26}] 107.6 [expr {$y + 3.71}]
    metal2_to_metal4 $xo [expr {$y + 3.485}]
    p metal4 [expr {$xo - 0.15}] [expr {$y + 3.485}] [expr {$xo + 0.15}] 224.76
}

source ../slots.tcl

# Every digital output that no slot drives goes to ground.
tieoff 100 $CLAIMED
