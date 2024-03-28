library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is
component fsm
 port(clk,rst: in std_logic;
       data_out: out std_logic;
       data_in: in std_logic);
 end component;
 
 signal data_in: std_logic := '0';
 signal rst: std_logic := '0';
 signal clk: std_logic := '1';
 signal data_out: std_logic;
begin
mealy11011: fsm port map (rst=>rst,clk=>clk,data_in=>data_in,data_out=>data_out);
clock:
process
begin
wait for 50 ns;
clk <= not clk;
if(Now > 7799 ns) then
wait;
end if;
end process;
stimulus:
process
begin
wait for 10 ns;
rst <= '1';
wait for 40 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '0';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '0';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '1';
wait for 100 ns;
data_in <= '0';
wait;
end process;
end Behavioral;
