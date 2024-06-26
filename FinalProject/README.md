# Final Project: Keyboard

> We pledge our Honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

## Introduction

Utilizing the keypad and the speaker, we created a single-octave keyboard. Based on the image below as the key to how the keyboard is mapped, simple songs can be played.

![Keyboard Octave Key](https://github.com/andieleee/CPE487/assets/65604948/6bde9756-8956-40f3-8657-b59192900fb0)

## Demo of the keyboard octave and Ode to Joy
The speaker is pressed to the microphone

https://github.com/andieleee/CPE487/assets/65604948/8b76b378-14dc-4497-aac0-dc87ade555ad

## Materials

* [NI Digilent Nexys A7-100T FPGA Trainer Board](https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum)
* [Pmod KYPD](https://digilent.com/shop/pmod-kypd-16-button-keypad)
* [Pmod I2S2 Digital-to-Analog Converter](https://digilent.com/shop/pmod-i2s2-stereo-audio-input-and-output)
* 3.5mm Speaker

## How to Run
1. Create a new RTL project in Vivado called Keyboard
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
   - Note: If siren.bit is not automatically set in the upload, browse to '....\Xilinx\Projects\Keyboard\Keyboard.runs\impl_1\siren.bit' to find the bitstream file

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
#### Inputs and Outputs using XDC
In order to have the ports working, we had to modify the XDC file.  This mainly combined the constraints from lab 4 and lab 5.
```
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { dac_LRCK }]; #IO_L21N_T3_DQS_A18_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { dac_SCLK }]; #IO_L21P_T3_DQS_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { dac_SDIN }]; #IO_L18N_T2_A23_15 Sch=ja[4]
set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { dac_MCLK }]; #IO_L20N_T3_A19_15 Sch=ja[1]
```
The constraints above allowed the dac to be used as a port.  The three clock signals LRCK, SCLK, amd MCLK are used, as well as the serial input SDIN. 

```
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { KB_col2[4] }]; #IO_L20N_T3_A19_15 Sch=jb[1]
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { KB_col2[3] }]; #IO_L21N_T3_DQS_A18_15 Sch=jb[2]
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { KB_col2[2] }]; #IO_L21P_T3_DQS_15 Sch=jb[3]
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { KB_col2[1] }]; #IO_L18N_T2_A23_15 Sch=jb[4]
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { KB_row2[4] }]; #IO_L16N_T2_A27_15 Sch=jb[7]
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { KB_row2[3] }]; #IO_L16P_T2_A28_15 Sch=jb[8]
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { KB_row2[2] }]; #IO_L22N_T3_A16_15 Sch=jb[9]
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { KB_row2[1] }]; #IO_L22P_T3_A17_15 Sch=jb[10]
```
The keypad was controlled through these constraint lines.  The only thing we changed was KB_row and KB_col with KB_row2 and KB_col2 respectively.  This is mentioned later in the keypad integration section.

#### Keypad Integration
- Keypad column and row vectors values added to the constraint file tied to pins for port JB
- 'KB_col' & 'KB_row' are out and in std_logic_vectors (4 downto 1) respectively that exist as ports through the entire project (keypad -> tone -> wail -> siren).
  |[keypad.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd)|[tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd)|[wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)|[siren.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/siren.vhd)|[siren.xdc](https://github.com/andieleee/CPE487/blob/main/FinalProject/siren.xdc)|
  |---|------|-------|-------|-------|
  |col|KB_col|KB_col1|KB_col2|KB_col2|
  |row|KB_row|KB_row1|KB_row2|KB_row2|
- Signal 'kp_value' added to [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd) and mapped to 'value' in [keypad.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd)
- Series of elsif-statements for keypad presses. We only uses the upper 3 rows since our keyboard only has 12 notes.\

In [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd)
```
square_tone : process
begin
    --if kp_value = "0000" then
        --data <= square_data;
    if kp_value = "0001" then
    -- C
        modpitch <= "00000010101111";
        data <= square_data;
    elsif kp_value = "0010" then
    -- C#
        modpitch <= "00000010111010";
        data <= square_data;
    elsif kp_value = "0011" then
    -- D
        modpitch <= "00000011000101";
        data <= square_data;
    elsif kp_value = "0100" then
    -- E
        modpitch <= "00000011011101";
        data <= square_data;
    elsif kp_value = "0101" then
    -- F
        modpitch <= "00000011101010";
        data <= square_data;
    elsif kp_value = "0110" then
    -- F#
        modpitch <= "00000011111000";    
        data <= square_data;
    elsif kp_value = "0111" then
    -- G#   
        modpitch <= "00000100010110";
        data <= square_data;
    elsif kp_value = "1000" then
    -- A    
        modpitch <= "00000100100111";
        data <= square_data;
    elsif kp_value = "1001" then
    -- A#    
        modpitch <= "00000100111000";
        data <= square_data;
    elsif kp_value = "1010" then
    -- D#    
        modpitch <= "00000011010000";
        data <= square_data;
    elsif kp_value = "1011" then
    -- G    
        modpitch <= "00000100000111";
        data <= square_data;
    elsif kp_value = "1100" then
    -- B    
        modpitch <= "00000101001011";
        data <= square_data;
    --elsif kp_value = "1101" then
        --data <= square_data;
    --elsif kp_value = "1110" then
        --data <= square_data;
    --elsif kp_value = "1111" then
        --data <= square_data;
    else
        modpitch <= "00000000000001";    
    end if;
end process;
```

#### Note Creation
- The same square signal is used for all notes to be constant.
- Due to 'pitch' being an in bit, we cannot directly assign values to it
- Extra port called 'modpitch' (modify pitch) identical to 'pitch' created in [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd) and as a signal in [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)
- The port in [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd), 'curr_pitch' is mapped to 'pitch' and thus we make the value of 'curr_pitch' be what 'modpitch' is
- Keypad presses change the value of 'modpitch' which will change the value of 'curr_pitch' and thus change the value of 'pitch' to change the frequency of the sound.

In [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)
```
BEGIN
	wp : PROCESS
		VARIABLE updn : std_logic;
	BEGIN
		WAIT UNTIL rising_edge(wclk);
		IF curr_pitch >= hi_pitch THEN
			updn := '0';
		ELSIF curr_pitch <= lo_pitch THEN
			updn := '1';
		END IF;
		IF updn = '1' THEN
			curr_pitch <= curr_pitch + wspeed;
		ELSE
			curr_pitch <= curr_pitch - wspeed;
		END IF;
		curr_pitch <= modpitch;
	END PROCESS;
	tgen : tone
	PORT MAP(
		clk => audio_clk,
		pitch => curr_pitch,
		data => audio_data,
		KB_col => KB_col1,
		KB_row => KB_row1,
		modpitch => modpitch 
		);
END Behavioral;
```

### Minor Changes
- In [keypad,vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd), 'value' changed from hex to 4-bit binary values
- Signals, 'kp_hit' and 'kp_clk', added to [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd) for keypad component

## Process Summary
### Development Process & Challenges
Prior to discovering how to modify the pitch value, Andrew tried modifying the amplitudes of the waves similar to how the triangle and square waves to create each note (Square wave just sounds like a louder triangle wave). This would produce a highly off-tone keyboard with notes estimated to be in relation to each other. Kavin introduced the idea of creating a second value to edit the value of pitch, significantly reducing the amount of work required and improving the quality of the notes played. 
### Flaws and Imperfections
Due to the nature of how the keypad sends key presses, how the program switches between notes, and how notes are created via modifying the pitch value, two keys cannot be pressed simultaneously to create a chord. The keypad is not capable of sending two outputs of different key presses simultaneously and will prioritize the key thats code is present earlier in the if-statements. The pitch is also unable to receive two assignments and is not able to "combine" values to create the unique frequencies chords have in many combinations.

We were also unable to find a method to modify the volume of the sound that comes out of the speaker
