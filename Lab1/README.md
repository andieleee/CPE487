# Lab 1

This lab gives us an introduction to the Nexys A-7 FPGA.  The first part of the lab is a LED decoder, that allows switches to control what digits are produced from the LEDs.  

The second part of the lab involves a hex counter, which counts 0 to F in order.  With the file that was given to us, the rightmost of the 8 bits would count from 0 to F.  We could change the speed of the counter and change the position of the counter while it is counting up.  Changing the speed of the clock requires the counter to slow down or speed up, and count could not be subtracted, thus the clock has to speed up.  

`BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- on rising edge of clock
			cnt <= cnt + 2; -- increment counter
		END IF;
	END PROCESS; `

The `cnt <= cnt + 2; ` line was changed from `cnt <= cnt + 1; ` to change the speed of the counter.
