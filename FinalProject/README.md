# Final Project: Piano

> We pledge our Honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

## Introduction

Utilizing the keypad and the speaker, we created a single-octave piano. Based on the image below as the key to how the piano is mapped, simple songs can be played.

![Piano Octave Key](https://github.com/andieleee/CPE487/assets/65604948/6bde9756-8956-40f3-8657-b59192900fb0)

## Demo of the piano octave and Ode to Joy

https://github.com/andieleee/CPE487/assets/65604948/8b76b378-14dc-4497-aac0-dc87ade555ad

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

The code is primarily based on Lab 5 (DAC Siren) with parts of Lab 4 (Hex Calculator) integrated to utilize the keypad. The major functionalities are:
    - When a key on the keypad is pressed, a note is played.
    - No sound is played when the system is idle.

From Lab 4, we use [keypad.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd) to be able to utilize the keypad. When a key is pressed, the keypad sends out a value that for our uses is a 4-bit vector of values 0 through 15.

The keypad is made a component of [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd), and while in Lab 5 we created a value called 'bt_select' for a button to switch the mode, we now use the keypad value, 'kp_value' to switch the mode. 

Each individual note corresponds to a frequency, so to create each note, we change the frequency of the signal instead of modifying the shape of the wave. This is done by modifying the value of 'pitch'.
The math to figure out the value of pitch is: (Frequency of Note Hz)/0.745 Hz. These calculations are shown with their binary values in the rightmost columns.
![](https://cdn.discordapp.com/attachments/1068296443279978527/1232377032957231174/image.png?ex=6633c80d&is=6632768d&hm=4bd57339fdb490623bb5a26000d38313aa3e15aadb5506c8ef526f8c44cfb2ca&)

### Core Changes

    

