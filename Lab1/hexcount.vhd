LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY hexcount IS
	PORT (
		clk_100MHz : IN STD_LOGIC;
		anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END hexcount;

ARCHITECTURE Behavioral OF hexcount IS
	COMPONENT counter IS
		PORT (
			clk : IN STD_LOGIC;
			count : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT leddec IS
		PORT (
			dig : IN STD_LOGIC_vector (2 downto 0);
			data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL S : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL dig: std_logic_vector (2 downto 0);
    SIGNAL spot: std_logic_vector (28 downto 0);
BEGIN
	C1 : counter
	PORT MAP(clk => clk_100MHz, count => S);
	L1 : leddec
	PORT MAP(dig => dig, data => S, anode => anode, seg => seg);
	PROCESS (spot)
	BEGIN
		IF rising_edge(clk_100MHz) THEN -- on rising edge of clock
			spot <= spot + 1; -- increment counter
		END IF;
	END PROCESS;
	dig  <= spot (28 downto 26);
END Behavioral;