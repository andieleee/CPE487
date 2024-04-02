# Lab 4: Hex Calculator

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

For this lab we were tasked with taking a basic 4-bit hex calculator that can only perform addition and making the calculator also be able to do subtraction and have leading-zero suppression.

While implementing the subtraction and leading-zero suppression functions, we noticed that the calculator is capable of utilizing the 4 unused LEDs with very minor adjustments.

---
The addition functionality is designed using a finite state machine to take inputs and add for an output. So for the subtraction functionality, I added a new set of states that the finite machine can go through, exactly the same as for addition but the input values will be subtracted instead of added. These new states were designated by an 'M' in their names to differentiate them from the addition states (ex. START_OPM, OPM_RELEASE, ENTER_OPM).

```
WHEN ENTER_OPM => -- waiting for next digit in 2nd operand subtraction
	display <= operand;
	IF bt_eq = '1' THEN
		nx_acc <= acc - operand;
		nx_state <= SHOW_RESULT;
	ELSIF kp_hit = '1' THEN
		nx_operand <= operand(27 DOWNTO 0) & kp_value;
		nx_state <= OPM_RELEASE;
	ELSE nx_state <= ENTER_OPM;
```

A new port was also created called 'bt_minus' represent the subtract button being pressed, which was bound to BTND in the constraints file.

```
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { bt_minus }]; #IO_L9N_T1_DQS_D13_14 Sch=btnd
```

---
To implement the leading-zero suppression, and extra statement was added to anode's conditional assignments to prevent LEDs from activating if the values greater than it is 0.

```
anode <= 
	         "11111110" WHEN (dig = "000" and data(31 downto 0) /= X"00000000") else
	         "11111101" WHEN (dig = "001" and data(31 downto 4) /= X"0000000") else
	         "11111011" WHEN (dig = "010" and data(31 downto 8) /= X"000000") else
	         "11110111" WHEN (dig = "011" and data(31 downto 12) /= X"00000") else
	         "11101111" WHEN (dig = "100" and data(31 downto 16) /= X"0000") else
	         "11011111" WHEN (dig = "101" and data(31 downto 20) /= X"000") else
	         "10111111" WHEN (dig = "110" and data(31 downto 24) /= X"00") else 
	         "01111111" WHEN (dig = "111" and data(31 downto 28) /= X"0") else
	         "11111111";
```

---
To utilize the 4 unused LEDs, minor changes were added to both files
In [leddec16.vhd](https://github.com/andieleee/CPE487/blob/main/Lab4/leddec16.vhd), data was changed from `(15 downto 0)` to `(31 downto 0)`, data4 was given additional possible assignments, and anode was uncommented to utilize the other half of the displays.

```
data4 <=
           data(3 DOWNTO 0) WHEN dig = "000" ELSE -- digit 0
	         data(7 DOWNTO 4) WHEN dig = "001" ELSE -- digit 1
	         data(11 DOWNTO 8) WHEN dig = "010" ELSE -- digit 2
	         data(15 DOWNTO 12)when dig = "011" else -- digit 3
	         data(19 downto 16) when dig = "100" else
	         data(23 downto 20) when dig = "101" else
	         data(27 downto 24) when dig = "110" else
	         data(31 downto 28);
```
In [hexcalc.vhd](https://github.com/andieleee/CPE487/blob/main/Lab4/hexcalc.vhd), nx_acc, acc, nx_operand, operand, and display were also changed from `(15 downto 0)` to `(31 downto 0)` to allows for the additional values that will be displayed.

```
SIGNAL  nx_acc, acc : std_logic_vector (31 DOWNTO 0); -- accumulated sum
	SIGNAL nx_operand, operand : std_logic_vector (31 DOWNTO 0); -- operand
	SIGNAL display : std_logic_vector (31 DOWNTO 0); -- value to be displayed
```
Additional zeros were also added to many of the vectors to accomadate the additional displays.

```
IF bt_clr = '1' THEN -- reset to known state
	acc <= X"00000000";
	operand <= X"00000000";
	pr_state <= ENTER_ACC;
```

---
These are the results of these modifications:

![](/Lab4/upload4.png)

https://github.com/andieleee/CPE487/assets/116908446/4c8d65c4-fdf2-4f3d-935b-d85a46dd0561 


