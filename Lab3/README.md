# Lab 3: Bouncing Ball

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

The main point of this lab was to make a ball move around a 600x800 serial monitor.  We were given five files, but only had to change ball.vhd. We had to change the size and color of the ball.  
```
ARCHITECTURE Behavioral OF ball IS
	CONSTANT size  : INTEGER := 12;
	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to +4 pixels/frame
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
BEGIN
	red <= NOT ball_on; -- color setup for red ball on white background
	green <= '1';
	blue  <= '1';
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
	BEGIN
	    IF ((conv_integer(pixel_col)-conv_integer(ball_x))*(conv_integer(pixel_col)-conv_integer(ball_x))+
	    (conv_integer(pixel_row)-conv_integer(ball_y))*(conv_integer(pixel_row)-conv_integer(ball_y)) <= (size*size)) THEN
		    ball_on <= '1';
		ELSE
			ball_on <= '0';
		END IF;
		END PROCESS;
```

In the code block above, the first line is us changing the size of the ball from 8 pixels to 12 pixels.   I added a ball_x_motion below the ball_y_motion that makes the ball move in the x direction.  Originally, I combined all of the motions of the ball under one if statement, but it ran better under multiple if statements.  After the begin line, I changed the color from red to cyan by changing green and blue to one.

The ball would be drawn to the circle equation (x^2+y^2=r^2) instead of four lines of VHDL specifying the boundaries for a square.  We didn't really draw anything, as we just knew this formula from a previous class and decided to use it.  In addition, we changed pixel_col, pixel_row, ball_x, and ball_y to integers in order to fully make the ball.  Otherwise, a quarter of the ball would show up.  The video for the movement is below


https://github.com/andieleee/CPE487/assets/65604948/6f0d63b0-aebe-48f4-8ef8-8d1ee7022f0e

This is an image of the code running on the Nexys A7
![image](https://github.com/andieleee/CPE487/assets/65604948/fa157d41-bd16-4357-9f29-a27f1d2e48b4)


