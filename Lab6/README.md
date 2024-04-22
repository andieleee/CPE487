# Lab 6: Video Game PONG

> We pledge our honor that we have abided by the Stevens Honor System - Andrew Lee and Kavin Mohan

In this lab, we were given a pong game that works with a potentiometer.  While the heavy majority of the code was given, we have to double the length of the bat and make the bat decrease in size every time the ball hit the bat.  In addition, whenever the ball hits the bar at least once, a score pops up on the display of the Nexys-A7.  Finally, we have to make the ball change speed with the switches.  

The first part of the lab was changing the size of the ball every time the bat hit the ball.  The part of the files that would be changed was the mball process in the bat_n_ball vhdl file.  Originally, We thought batdraw was the issue at first, but the bat was constantly changing its size even when the ball was not hitting it.  As a result, we knew it had to be mball because that is the only other process that involves the ball and the bat.  

---

![image](https://github.com/andieleee/CPE487/assets/65604948/e8c8fd06-3569-46c1-b6d1-d911a25a8e88)

Line 88 resets the bat width to 40 when the game starts over

---

![image](https://github.com/andieleee/CPE487/assets/65604948/c419a722-c74f-4197-ac56-5c0ca5770129)

Line 114 decreases the width of the bat by one when the ball hits it

---

The second part of the lab required the score to be displayed via the LED display on our Nexys-A7.  For this, we just used the leddec16 file from lab 4.  Throughout the pong and bat_n_ball files, we had to incorporate the numberofhits port as well as the seg7_anode and seg7_seg for the LED.  Numberofhits is needed because the score needs to be tracked through a variable.  SW was listed as a 5 bit standard logic vector, while numberofhits was a 16 bit standard logic vector. We also needed a signal for numberofhits called hitcount.  In addition, we created a signal called doublehit because the LED would sometimes go up by two even when it hit once. To get the LED set up in pong, we took the constraints from earlier labs and put them in our xdc file.  From there, we used seg7_anode and seg7_seg, which are 8 and 7 bit vectors respectively. There would be too many pictures to put in, so here is some code from pong initializing the leddec16 file.

![image](https://github.com/andieleee/CPE487/assets/65604948/86ec81d9-d24e-4138-ba2a-9ad91503cf51)

![image](https://github.com/andieleee/CPE487/assets/65604948/a6ff1da2-e250-4f1b-8785-3c46fa875f4e)

---

The final part of the lab involved the switches.  The switches would be a port SW and their constraints were copied from previous labs.  The switches change the speed of the ball, and the speed can be changed mid-game as well.  No switches would give it a speed of 0, which would not start the game.  The rightmost switch increases the speed by one. Then, the switch to the left of that increases the speed by two.  Then, the switch to the left of the just-mentioned switch increases by four, and so on until it hits the fourth switch from the right.  Some of the VHDL for the switches will be put below.

![image](https://github.com/andieleee/CPE487/assets/65604948/974568f7-91bc-4bb9-904b-7476cd5a6fc6)

![image](https://github.com/andieleee/CPE487/assets/65604948/89ae9a66-02ac-445d-91bc-a204387e52ba)

Line 82 is the main line that changes the ball speed in the picture.  Bits 0 to 4 are represented by SW, while bits 5 to 10 have a 0 so that the speed is not changed by the switches further to the left.  The speed of the ball was changed from a constant to a signal in order to get the ball speed to change in the first picture.  






