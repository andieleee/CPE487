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
#### Keypad Integration
- Keypad column and row vectors values added to the constraint file tied to pins for port JB
- KB_col[] & KB_row[] are out and in std_logic_vectors (4 downto 1) that exist as ports through the entire project (keypad -> tone -> wail -> siren).
  |[keypad.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd)|[tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd)|[wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)|[siren.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/siren.vhd)|[siren.xdc](https://github.com/andieleee/CPE487/blob/main/FinalProject/siren.xdc)|
  |col|KB_col|KB_col1|KB_col2|KB_col2|
  |row|KB_row|KB_row1|KB_row2|KB_row2|
- Signal 'kp_value' added to [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd) and mapped to 'value' in [keypad.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/keypad.vhd)
- Series of elsif-statements for keypad presses. We only uses the upper 3 rows since our piano only has 12 notes.\

In [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd)
```
square_tone : process
-- We will be using the top 3 rows of the keypad for our octave so not using 0,F,E,D
begin
    --if kp_value = "0000" then
        --data <= tri_data;
    if kp_value = "0001" then
    -- C
        modpitch <= "00000010101111";
        data <= square_data;
    elsif kp_value = "0010" then
    -- CS
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
    -- FS
        modpitch <= "00000011111000";    
        data <= square_data;
    elsif kp_value = "0111" then
    -- GS    
        modpitch <= "00000100010110";
        data <= square_data;
    elsif kp_value = "1000" then
    -- A    
        modpitch <= "00000100100111";
        data <= square_data;
    elsif kp_value = "1001" then
    -- AS    
        modpitch <= "00000100111000";
        data <= square_data;
    elsif kp_value = "1010" then
    -- DS    
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
- Extra port called 'modpitch' (modify pitch) created in [tone.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/tone.vhd) and as a signal in [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)
- The port in [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd), 'curr_pitch' is mapped to 'pitch' and thus we make the value of 'curr_pitch' be what 'modpitch' is
- Keypad presses change the value of 'modpitch' which will change the value of 'curr_pitch' and thus change the value of 'pitch' to change the frequency of the sound.

In [wail.vhd](https://github.com/andieleee/CPE487/blob/main/FinalProject/wail.vhd)
```
BEGIN
	-- this process modulates the current pitch. It keep a variable updn to indicate
	-- whether tone is currently rising or falling. Each wclk period it increments
	-- (or decrements) the current pitch by wspeed. When it reaches hi_pitch, it
	-- starts counting down. When it reaches lo_pitch, it starts counting up
	wp : PROCESS
		VARIABLE updn : std_logic;
	BEGIN
		WAIT UNTIL rising_edge(wclk);
		IF curr_pitch >= hi_pitch THEN
			updn := '0'; -- check to see if still in range
		ELSIF curr_pitch <= lo_pitch THEN
			updn := '1'; -- if not, adjust updn
		END IF;
		IF updn = '1' THEN
			curr_pitch <= curr_pitch + wspeed; -- modulate pitch according to
		ELSE
			curr_pitch <= curr_pitch - wspeed; -- current value of updn
		END IF;
		curr_pitch <= modpitch;
	END PROCESS;
	tgen : tone
	PORT MAP(
		clk => audio_clk, -- instance a tone module
		pitch => curr_pitch, -- use curr-pitch to modulate tone
		data => audio_data,
		KB_col => KB_col1,
		KB_row => KB_row1,
		modpitch => modpitch
		);
END Behavioral;
```
