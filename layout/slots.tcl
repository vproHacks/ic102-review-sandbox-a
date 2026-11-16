# layout/slots.tcl: who has which slot. One line per claimed slot:
#
#   slot K CELL
#
# K is 0 to 7. CELL is the name of your cell's file in layout/cells/ without
# the .mag: inv_ followed by your GitHub username, with any - changed to _.
# Keep the lines in slot order. Your pull request claims the slot here and
# describes the same two pins, ui[K] and uo[K], in info.yaml's pinout.

slot 2 inv_vprohacks
slot 3 inv_vprohacks_owner
