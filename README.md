![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg)

# IC102-A review sandbox

A small analog Tiny Tapeout project for [Lab 04: A change through review](https://uoftasic.com/ic102-a/labs/lab-04-a-change-through-review-overview.html)
of [IC102-A](https://uoftasic.com/ic102-a/). Its owner made it from the course's sandbox folder,
and their partner changes it through a pull request from a fork. It's a practice repository and is
never submitted to a shuttle.

The tile starts with one inverter, the anchor, between `ua[0]` and `ua[1]`, and eight empty slots.
Slot K takes its input from `ui_in[K]` and drives `uo_out[K]`, which is why there are eight: a 1x2
tile has eight `ui_in` and eight `uo_out` pins, and only six usable analog pins. In Lab 04 the
partner claims one slot and the owner claims the one next to it, each with an inverter of their
own.

## Claiming a slot

A pull request that claims a slot changes four things, and the lab writeup goes through each one:

1. `layout/cells/inv_<you>.mag`, a copy of your inverter from Lab 03, where `<you>` is your GitHub
   username with any `-` changed to `_`.
2. One line in `layout/slots.tcl`, `slot K inv_<you>`, in slot order.
3. The `ui[K]` and `uo[K]` lines of the pinout in `info.yaml`.
4. `gds/` and `lef/`, rebuilt with `make` from the three files above.

Before you push, run `make lvs` and `make precheck` in the workbench and paste their last lines
into the pull request's description.

## Conflicts in gds/ and lef/

Every claim changes `gds/tt_um_ic102a_sandbox.gds`, so once one pull request has been merged, any
other open one conflicts with `main`. Git can't merge a GDS file, because it's binary, and a LEF
file that git has merged line by line describes no real layout, so don't try to resolve either by
hand. Resolve the text files (`layout/slots.tcl`, `info.yaml`) by hand, keeping both sides'
claims, then run `make` to build `gds/` and `lef/` again from the merged sources, and commit the
result. GitHub doesn't run a pull request's workflows while it has a conflict, so its checks start
again once you push the merge.

## Rules for main

`main` takes changes only through a pull request with green `docs`, `gds` and `precheck` checks and
one approval from someone with write access other than the person who pushed last. The owner, as
the repository's admin, can merge a pull request of their own without an approval, and still can't
push to `main` directly. [RULESET.md](RULESET.md) lists the ruleset in full, and
[REVIEWING.md](REVIEWING.md) is the checklist for reviewers.

## Building

In the IC102-A workbench, from the top of this repository:

| Command | What it does |
|---|---|
| `make` | build `gds/` and `lef/` from `layout/` |
| `make precheck` | Tiny Tapeout's precheck, with the runner's versions of its tools |
| `make lvs` | the layout against a reference written from `layout/slots.tcl` |
| `make drc` | Magic DRC with the workbench's Magic, to compare with precheck's |
| `make docs` | the docs workflow's check of `info.yaml` and `docs/info.md` |
| `make view` | open the layout in Magic on the desktop |

The checks come from the course repository, cloned with `mod add ic102-a`.
[layout/UPSTREAM.md](layout/UPSTREAM.md) says where the copied files in `layout/` came from.
