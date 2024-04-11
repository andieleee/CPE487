# Lab 5: DAC Siren

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

For this lab, we were given a basic program that produces an identical dual-channel siren and our task was to implement a square wave sound, adjustable speed switches, and change differentiate the sounds between the left and right channels.

---
Beginning with the [constraints](https://github.com/andieleee/CPE487/blob/main/Lab5/siren.xdc) file, we add the 8 switches to control the speed and button BTNU to change the signal from sine to square wave.
```
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { button_select }]; #IO_L4N_T0_D05_14 Sch=btnu
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { SW[4] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { SW[5] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { SW[6] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { SW[7] }]; #IO_L5N_T0_D07_14 Sch=sw[7]
```

---
The siren produced identical sounds in both channels by duplicating the sound going through one channel to the other channel using `data_R <= data_L;`. So we commented out this line and instead duplicated the component that creates the noise and sent that one to the right channel. We inverted the pitch and tone to differentiate the sound from the left channel.
```
w1 : wail
		PORT MAP(
			lo_pitch => lo_tone, -- instantiate wailing siren
			hi_pitch => hi_tone, 
			wspeed => wail_speed, 
			wclk => slo_clk, 
			audio_clk => audio_clk, 
			audio_data => data_L,
			btn_select => button_select
		);
		w2 : wail
		PORT MAP(
			lo_pitch => hi_tone, -- instantiate wailing siren
			hi_pitch => lo_tone, 
			wspeed => wail_speed, 
			wclk => slo_clk, 
			audio_clk => audio_clk, 
			audio_data => data_R,
			btn_select => button_select
		);
```

---
To implement the square wave, firstly we added a signal that controls the wave and makes the program send out a square wave when the button is pressed.
```
square_tone : process
begin
    if bt_select = '1' then
        data <= square_data;
    else
        data <= tri_data;
    end if;
```
Next, we created the square wave itself that goes back and forth between the two peaks per quadrant for the square shape. In reality, the square wave sounds like a louder version of the sine wave.
```
WITH quad SELECT
	square_data <=  "0011111111111111" WHEN "00", -- 1st quadrant
	                "1100000000000001" WHEN "01", -- 2nd quadrant
	                "0011111111111111" WHEN "10", -- 3rd quadrant
	                "1100000000000001" WHEN OTHERS; -- 4th quadrant
```

---
To modify the speed of the signal using 8 switches, we noticed that the speed of the sound is already a vector from 7 downto 0. We created an identical array from 7 downto 0 that is connected to the switches and directly link it to the wail speed.
```
ENTITY siren IS
	PORT (
		clk_50MHz : IN STD_LOGIC; -- system clock (50 MHz)
		dac_MCLK : OUT STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : OUT STD_LOGIC;
		dac_SCLK : OUT STD_LOGIC;
		dac_SDIN : OUT STD_LOGIC;
		button_select : in std_logic;
		SW : in unsigned (7 downto 0)  -- new array same size as wail_speed
		);
END siren;

ARCHITECTURE Behavioral OF siren IS
	CONSTANT lo_tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (344, 14); -- lower limit of siren = 256 Hz
	CONSTANT hi_tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (687, 14); -- upper limit of siren = 512 Hz
	CONSTANT wail_speed : UNSIGNED (7 DOWNTO 0) := SW; -- sets wailing speed and directly connected to the switches
```

---
Here are the results:

![](/Lab5/upload5.png)

![Audio file](https://github.com/andieleee/CPE487/blob/main/Lab5/lab5speaker.m4a)
