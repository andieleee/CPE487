library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
 port(clk,rst: in std_logic;
      data_out: out std_logic;
      data_in: in std_logic);
end FSM;

architecture Behavioral of FSM is
    type state_values is (stA,stB,stC,stD,stE);
    signal pres_state, next_state: state_values;
begin
statereg: process (clk,rst)
    begin
    if(rst='0') then
    pres_state <= stA;
    elsif (rising_edge(clk)) then
        pres_state <= next_state;
    end if;
end process statereg;

fsm: process (pres_state,data_in)
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
        else 
        next_state <= stE;
        data_out <= '0';
        end if;
    when others => next_state <= stA;
end case;
end process fsm;      
end Behavioral;


