# Reviewing a pull request in the sandbox

The checks tell you that the GDS passed precheck. They can't tell you that the layout is the one
the pull request says it is, because precheck has no LVS and doesn't read the pinout of the
digital pins at all, and the diff of a GDS file is one line saying the binary changed. Review from
these instead, and say what you checked in your review.

1. **The run.** Open the pull request's latest `gds` run. Are `docs`, `gds` and `precheck` green on
   the latest commit, and does precheck's table on the run's summary page show all 15 rows green?
   If the checks say they're waiting for approval, read the change first, then approve its runs.
2. **The render.** Download the `gds_render` artifact from that run and open the PNG. Is there a
   new inverter in the slot that `layout/slots.tcl` claims (slot K sits at y = 40 + 20K µm, between
   the two stripes), with one wire running up to the top edge on each side?
3. **The text diff.** Does the pull request add exactly one `slot` line, for a slot nobody else
   holds? Does the cell file's name match that line? Are the `ui[K]` and `uo[K]` descriptions in
   `info.yaml` for the same K, and only those two? Did `gds/` and `lef/` change along with them?
4. **The description.** Did the author paste the end of `make lvs` and `make precheck`, from the
   latest commit? If you have the time, fetch the pull request into your clone with
   `git fetch origin pull/N/head:pr-N` (N is its number), switch to `pr-N`, and run `make lvs`
   yourself.
5. **Anything else.** Are there files the change didn't need, such as `layout/build/` or
   `tt_submission/`, or changes to files that have nothing to do with a slot? If part of the change
   was written with an AI tool, does the description say which part and what the author checked?

Ask for a change with "Request changes", and say what to change and why. When the author has
pushed it, look again: the new push dismisses earlier approvals, so approve again if it's right.
