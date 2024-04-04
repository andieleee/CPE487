# Lab 3: Bouncing Ball

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

The main point of this lab was to make a ball move around a 600x800 serial monitor.  We were given five files, but only had to change ball.vhd. We had to change the size and color of the ball.  
 '''ARCHITECTURE Behavioral OF ball IS
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
		END PROCESS;'''
