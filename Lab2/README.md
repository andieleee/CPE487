# Lab 2

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

In this lab, we are tasked with creating a finite-state machine for a counter. When the finite-state machine receives its desired output, the counter will reverse counting directions.

---
We designed a mealy machine that detects the bit sequence '11110'. The diagram for the mealy machine is below. 

![](/Lab2/Mealy11110Diagram.png)

We initially programmed and tested this machine in a separate project to ensure it functions properly. We used a test bench that gave hardcoded inputs to confirm the machine functions. These files are [FSM.vhd](https://github.com/andieleee/CPE487/blob/main/Lab2/FSM.vhd) and [FSM_tb.vhd](https://github.com/andieleee/CPE487/blob/main/Lab2/FSM_tb.vhd). These simulation results prove that our finite-state machine worked.

![](/Lab2/fsmsimulation.png)

---
We copied our finite state machine over to [counter.vhd](https://github.com/andieleee/CPE487/blob/main/Lab2/counter.vhd) and created an additional signal called 'bool' to control the counting direction of the counter. We connected the input of the finite-state machine to bit 29 on the count because lower bits would change too often and changes would be difficult to notice.
```
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
```
In the final state of the machine, when we receive the correct input to complete the sequence, a T Flip Flop is used to switch the counting direction of the counter until the final state is reached again, allowing for a sizable amount of time to see the counting in the opposite direction.
```
when stE =>
        if(data_in = '0') then
        next_state <= stA;
        data_out <= '1';
        bool <= bool XOR data_out;
        
        else 
        next_state <= stE;
        data_out <= '0';
        end if;
```
---
Here are the results of the program:

![](/Lab2/upload2.png)

https://github.com/andieleee/CPE487/assets/116908446/0ce85272-3114-42cc-827d-87d9520ee65b

