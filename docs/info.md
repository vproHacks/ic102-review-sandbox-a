<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A practice project for IC102-A Lab 04, never meant for a shuttle. The course's inverter sits between ua[0] and ua[1]. The repository's owner and their partner each add one more inverter, in one of eight slots: slot K takes its input from ui_in[K] and drives uo_out[K]. Every digital output that no slot drives is tied to ground.

## How to test

Drive ui_in[K] high and low and check that uo_out[K] does the opposite, for each claimed slot K. The pinout below says who claimed which slot.

## External hardware

None.
