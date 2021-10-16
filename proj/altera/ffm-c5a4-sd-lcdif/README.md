# Programming with Altera USB Blaster

Board DIP switch positions for FT4232 or Altera USB Blaster

    USB HDMI microUSB

       FT4232

     |o |
    1|o |

     |o |
    1|o |

       HDMI SD

Module DIP switch positions for Altera USB Blaster

    1      1      1        1
    | o|   |o |   | o|     |oo|
    |o |   | o|   |o |     |  |
       M0 M1  M2 M3  M4    SW4

Board power up sequence.
Follow carefully, 12V switcher leaks 230V current
and this sequence assures board has common GND before 230V.

     1. Connect 12V switcher to board but don't yet plug it to 230V
     2. Connect 10-pin Altera USB Blaster to board but don't yet plug it to PC
     3. Plug Altera USB Blaster to PC (Blaster RED and GREEN LED ON)
     4. Plug 12V switcher to 230V (board GREEN LED ON)

Power down sequence is reverse of power up.
Following commands should work then:

     make prog
     make flash
