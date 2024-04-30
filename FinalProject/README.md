# Final Project: Piano

> We pledge our Honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

## Introduction

Utilizing the keypad and the speaker, we created a single-octave piano. Based on the image below as the key to how the piano is mapped, simple songs can be played.

![](https://cdn.discordapp.com/attachments/1068296443279978527/1232369636046143488/2b1faa071fd33b47e28b964a58745aab.png?ex=66326fa9&is=66311e29&hm=3a9c91a5d55ae53e1fbe080df233c259d9c871b8999d240d1ba79bc56eabbc83&)

## Demo of the piano octave and Ode to Joy

INSERT DEMO VIDEO HERE

## Materials

* [NI Digilent Nexys A7-100T FPGA Trainer Board](https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum)
* [Pmod KYPD](https://digilent.com/shop/pmod-kypd-16-button-keypad)
* [Pmod I2S2 Digital-to-Analog Converter](https://digilent.com/shop/pmod-i2s2-stereo-audio-input-and-output)
* 3.5mm Speaker

## How to Run
1. Create a new RTL project in Vivado called Piano
    - Create five sources files of type VHDL called dac_if.vhd, keypad.vhd, siren.vhd, tone.vhd, wail.vhd
    - Create a constraint file of type XDC called siren.xdc
    - Choose Nexys A7-100T trainer board for the project
2. Copy the .vhd and .xdc files in this folder to their respective identical sources and constraint.
3. Run synthesis, implementation, and generate bitstream
4. Connect the hardware:
   - 3.5mm speaker to the I2S2
   - I2S2 to the upper pins of port JA on the board
   - The Keypad to port JB
   - The board to your computer
5. Open the hardware manager, click "Open Target" then "Auto Connect" to connect the board. Click "Program Device" then "xc7a100t_0" to upload siren.bit to the board.
   - Note: If siren.bit is not automatically set in the upload, browse to '....\Xilinx\Projects\Piano\Piano.runs\impl_1\siren.bit' to find the bitstream file

## Modifications

The code is primarily based off lab 5 (DAC Siren) with parts of the lab 4 (Hex Calculator) integrated to utilize the keypad. The major functionalities are:
    - When a key on the keypad is pressed, a note is played.
    - No sound is played when the system is idle.

### Core Changes

    

