LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Generates a 16-bit signed triangle wave sequence at a sampling rate determined
-- by input  clk and with a frequency of (clk*pitch)/65,536
ENTITY tone IS
	PORT (
	    clk : IN STD_LOGIC; -- 48.8 kHz audio sampling clock
	    -- CHANGE PITCH FROM IN TO INOUT
	    pitch : IN UNSIGNED (13 DOWNTO 0); -- frequency (in units of 0.745 Hz)
	    data : OUT SIGNED (15 DOWNTO 0);
	    KB_col : OUT STD_LOGIC_VECTOR (4 DOWNTO 1); -- keypad column pins
	    KB_row : IN STD_LOGIC_VECTOR (4 DOWNTO 1); -- keypad row pins
	    modpitch: out unsigned (13 downto 0)
	    );
END tone;

ARCHITECTURE Behavioral OF tone IS
        COMPONENT keypad IS
		PORT (
	        samp_ck : IN STD_LOGIC; -- clock to strobe columns
		col : OUT STD_LOGIC_VECTOR (4 DOWNTO 1); -- output column lines
		row : IN STD_LOGIC_VECTOR (4 DOWNTO 1); -- input row lines
		value : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- hex value of key depressed
	        hit : OUT STD_LOGIC -- indicates when a key has been pressed
		);
	END COMPONENT;
	SIGNAL count : unsigned (15 DOWNTO 0); -- represents current phase of waveform
	SIGNAL quad : std_logic_vector (1 DOWNTO 0); -- current quadrant of phase
	SIGNAL index : signed (15 DOWNTO 0); -- index into current quadrant
	
	signal tri_data: signed (15 downto 0);
	signal square_data: signed (15 downto 0);
	signal C,CS,D,DS,E,F,FS,G,GS,A,AS,B: signed (15 downto 0);
	
	SIGNAL kp_clk, kp_hit : std_logic;
	SIGNAL kp_value : std_logic_vector (3 downto 0);
	
BEGIN
	-- This process adds "pitch" to the current phase every sampling period. Generates
	-- an unsigned 16-bit sawtooth waveform. Frequency is determined by pitch. For
	-- example when pitch=1, then frequency will be 0.745 Hz. When pitch=16,384, frequency
	-- will be 12.2 kHz.
	cnt_pr : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(clk);
		count <= count + pitch;
	END PROCESS;
	quad <= std_logic_vector (count (15 DOWNTO 14)); -- splits count range into 4 phases
	index <= signed ("00" & count (13 DOWNTO 0)); -- 14-bit index into the current phase
	-- This select statement converts an unsigned 16-bit sawtooth that ranges from 65,535
	-- into a signed 12-bit triangle wave that ranges from -16,383 to +16,383
	--WITH quad SELECT
	--tri_data <= index WHEN "00", -- 1st quadrant
	            --16383 - index WHEN "01", -- 2nd quadrant
	            --0 - index WHEN "10", -- 3rd quadrant
	            --index - 16383 WHEN OTHERS; -- 4th quadrant
	WITH quad SELECT
	square_data <=  "0011111111111111" WHEN "00", -- 1st quadrant
	                "1100000000000001" WHEN "01", -- 2nd quadrant
	                "0011111111111111" WHEN "10", -- 3rd quadrant
	                "1100000000000001" WHEN OTHERS; -- 4th quadrant 
                                        
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

kp : keypad
	PORT MAP(
		samp_ck => clk,
		col => KB_col, 
		row => KB_row,
		value => kp_value,
		hit => kp_hit
		);
		
END Behavioral;
