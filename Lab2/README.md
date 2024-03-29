# Lab 2

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

In this lab, we are tasked with creating a finite-state machine for a counter. When the finite-state machine receives its desired output, the counter will reverse counting directions.

---
We designed a mealy machine that detects the bit sequence '11110'. The diagram for the mealy machine is below. 

![](/Lab2/Mealy11110Diagram.png)

We initially programmed and tested this machine in a separate project to ensure it functions properly. We used a test bench that gave hardcoded inputs to confirm the machine functions. These files are [FSM.vhd](https://github.com/andieleee/CPE487/blob/main/Lab2/FSM.vhd) and [FSM_tb.vhd](https://github.com/andieleee/CPE487/blob/main/Lab2/FSM_tb.vhd). These simulation results prove that our finite-state machine worked.

![](/Lab2/fsmsimulation.png)

---
