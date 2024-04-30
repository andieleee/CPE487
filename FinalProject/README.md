# Final Project: Piano

> We pledge our Honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

## Introduction

Utilizing the keypad and the speaker, we created a single-scale piano. Based on the image below as the key to how the piano is mapped, simple songs can be played

## Demo of the piano and Ode to Joy


## Materials

* [NI Digilent Nexys A7-100T FPGA Trainer Board](https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum)
* [Pmod KYPD](https://digilent.com/shop/pmod-kypd-16-button-keypad)
* [Pmod I2S2 Digital-to-Analog Converter](https://digilent.com/shop/pmod-i2s2-stereo-audio-input-and-output)
* 3.5mm Speaker

## How to Run
1. Create five sources files of type VHDL called dac_if.vhd, keypad.vhd, siren.vhd, tone.vhd, wail.vhd
2. Create a constraint file of type XDC called siren.xdc
3. Choose Nexys A7-100T trainer board for the project
4. Copy the .vhd and .xdc files in this folder to their respective identical sources and constraint.
5. Run synthesis, implementation, and generate bitstream
6. Connect the board to .....
