# Lab 1

This lab gives us an introduction to the Nexys A-7 FPGA.  The first part of the lab is a LED decoder, that allows switches to control what digits are produced from the LEDs.  

The second part of the lab involves a hex counter, which counts 0 to F in order.  With the file that was given to us, the rightmost of the 8 bits would count from 0 to F.  We could change the speed of the counter and change the position of the counter while it is counting up.  Changing the speed of the clock requires the counter to slow down or speed up, and count could not be subtracted, thus the clock has to speed up.  

```
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- on rising edge of clock
			cnt <= cnt + 2; -- increment counter
		END IF;
	END PROCESS; `
```
The `cnt <= cnt + 2; ` line was changed from `cnt <= cnt + 1; ` to increase the speed of the counter.

```
BEGIN
	C1 : counter
	PORT MAP(clk => clk_100MHz, count => S);
	L1 : leddec
	PORT MAP(dig => dig, data => S, anode => anode, seg => seg);
	PROCESS (spot) -- additional process added to change which segment the display is on
	BEGIN
		IF rising_edge(clk_100MHz) THEN -- on rising edge of clock
			spot <= spot + 1; -- increment counter
		END IF;
	END PROCESS;
	dig  <= spot (28 downto 26); -- dig takes the last 3 bits of the larger 'spot signal' to slow down the speed
END Behavioral;
```
This block of VHDL changes the location of the number in the LED.
