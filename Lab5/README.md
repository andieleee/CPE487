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

