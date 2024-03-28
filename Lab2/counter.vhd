LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

ENTITY counter IS
	PORT (
		clk,rst : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- NEED REVISE! 16 bits
		mpx : OUT STD_LOGIC_VECTOR (2 DOWNTO 0); -- NEW ONE ADD! send signal to select displays
        data_in: inout std_logic);
END counter;

ARCHITECTURE Behavioral OF counter IS
	SIGNAL cnt : STD_LOGIC_VECTOR (38 DOWNTO 0); -- 39-bit counter
	type state_values is (stA,stB,stC,stD,stE);
    signal pres_state, next_state: state_values;
    signal data_out : std_logic;
    signal bool: std_logic := '0';
BEGIN
	statereg: PROCESS (clk,rst)
	BEGIN
	   if rising_edge(clk) then
		    if(bool = '1') THEN 
			cnt <= cnt - 1;
		    else
		    cnt <= cnt + 1;
		    END IF;
		pres_state <= next_state;
		end if;
		data_in <= cnt(29);
	END PROCESS statereg;
	count <= cnt (38 DOWNTO 23); -- 16 bits
	mpx <= cnt (19 DOWNTO 17); -- 3 bits
	
	-- currently a 11110 mealy --
fsm: process (pres_state,data_in,data_out)
begin
    case pres_state is
    when stA =>
        if(data_in = '1') then
        next_state <= stB;
        data_out <= '0';
        else 
        next_state <= stA;
        data_out <= '0';
        end if;
    when stB =>
        if(data_in = '1') then
        next_state <= stC;
        data_out <= '0';
        else
        next_state <= stA;
        data_out <= '0';
        end if;
    when stC =>
        if(data_in = '1') then
        next_state <= stD;
        data_out <= '0';
        else 
        next_state <= stA;
        data_out <= '0';
        end if;
    when stD =>
        if(data_in = '1') then
        next_state <= stE;
        data_out <= '0';
        else 
        next_state <= stA;
        data_out <= '0';
        end if;
    when stE =>
        if(data_in = '0') then
        next_state <= stA;
        data_out <= '1';
        bool <= bool XOR data_out;
        
        else 
        next_state <= stE;
        data_out <= '0';
        end if;
    when others => 
        next_state <= stA;
end case;
end process fsm;
END Behavioral;
