# Lab 1

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

This lab gives us an introduction to the Nexys A-7 FPGA.  The first part of the lab is a LED decoder, that allows switches to control what digits are produced from the LEDs.  

The second part of the lab involves a hex counter, which counts 0 to F in order at the rightmost position.  We were tasked with changing the speed of the counter and changing the position of the counter. We were able to create a counter with increased counting speed and will change positions from right to left until looping back.

---
In counter.vhd, the `cnt <= cnt + 2; ` line was changed from `cnt <= cnt + 1; ` to increase the speed of the counter.

```
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- on rising edge of clock
			cnt <= cnt + 2; -- count changed from +1 to +2 to increase speed of counter
		END IF;
	END PROCESS;
	count <= cnt (28 DOWNTO 25);
```

---
In hexcount.vhd, we added additional signals to enable us to manipulate the display location of the counter, 'spot' is a larger signal to help manipulate the speed at which the display will change. Using code inspired from counter.vhd, we created a counter for the display location and used a much larger value to reduce the speed at which the counter will change positions. The counter counts up to 28, though the 'dig' signal will only read changes from the final 3 bits, thus having a reduced speed to make changes to the position noticable.

```
	SIGNAL S : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL dig: std_logic_vector (2 downto 0);
    	SIGNAL spot: std_logic_vector (28 downto 0); -- additional signal to manipulate 'dig' location
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

---

Here are the results:

![](/Lab1/Upload.png)

https://github.com/andieleee/CPE487/assets/116908446/a4831a6f-cf2b-4011-8f87-eadcf1722dbe

