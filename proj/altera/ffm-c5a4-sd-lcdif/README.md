# Programming

Board DIP switch positions

    USB HDMI microUSB

       FT4232

     |o |
    1|o |

     |o |
    1|o |

       HDMI SD

Module DIP switch positions

    1      1      1        1
    | o|   |o |   | o|     |oo|
    |o |   | o|   |o |     |  |
       M0 M1  M2 M3  M4    SW4

Board power up sequence

     1. Connect 12V switcher but don't yet plug it to 230V
     2. Connect 10-pin Altera blaster but don't yet plug its mini USB to PC
     3. Plug board micro USB FT4232 to PC USB port
     4. Plug 230V to 12V switcher (green LED on)
     5. Plug Altera blaster mini USB to PC (red and green LED on)

Power down sequence reverse than power up.
Following commands should work then:

     make prog
     make flash
