LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
	PORT (
		clk : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END counter;

ARCHITECTURE Behavioral OF counter IS
	SIGNAL cnt : STD_LOGIC_VECTOR (28 DOWNTO 0); -- 29 bit counter
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN -- on rising edge of clock
			cnt <= cnt + 2; -- count changed from +1 to +2 to increase speed of counter
		END IF;
	END PROCESS;
	count <= cnt (28 DOWNTO 25);
END Behavioral;
