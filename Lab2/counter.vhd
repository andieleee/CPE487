-- counter.vhd --

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

ENTITY counter IS
	PORT (
		clk,rst : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- NEED REVISE! 16 bits
		mpx : OUT STD_LOGIC_VECTOR (2 DOWNTO 0); -- NEW ONE ADD! send signal to select displays
		data_out: inout std_logic;
        data_in: inout std_logic_vector (1 downto 0));
END counter;

ARCHITECTURE Behavioral OF counter IS
	SIGNAL cnt : STD_LOGIC_VECTOR (38 DOWNTO 0); -- 39-bit counter
	type state_values is (stA,stB,stC,stD,stE);
    signal pres_state, next_state: state_values;
BEGIN
	PROCESS (clk,rst)
	   variable temp_cnt: unsigned (38 downto 0);
	BEGIN
	   if rising_edge(clk) then
	       if (rst = '0') then
	       pres_state <= stA;
		  else
		    if(data_out = '1') THEN -- on rising edge of clock
			temp_cnt := unsigned(cnt) - 1; -- increment counter
			pres_state <= next_state;
		    else
		    temp_cnt := unsigned(cnt) + 1;
		    pres_state <= next_state;
		END IF;
	END PROCESS;
	count <= cnt (38 DOWNTO 23); -- 16 bits
	mpx <= cnt (19 DOWNTO 17); -- 3 bits
	data_in <= cnt;
	
fsm: process (pres_state,data_in)
begin
    case pres_state is
    when stA =>
        if(data_in = "1") then
        next_state <= stB;
        else next_state <= stA;
        end if;
    when stB =>
        if(data_in = "1") then
        next_state <= stC;
        else next_state <= stA;
        end if;
    when stC =>
        if(data_in = "0") then
        next_state <= stD;
        else next_state <= stC;
        end if;
    when stD =>
        if(data_in = "1") then
        next_state <= stE;
        else next_state <= stA;
        end if;
    when stE =>
        if(data_in = "1") then
        next_state <= stC;
        else next_state <= stA;
        end if;
    when others => null;
end case;
end process fsm;
data_out <= '1' when (pres_state = stE and data_in= "1") else '0'; 

END Behavioral;