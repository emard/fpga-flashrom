# FPGA FLASHROM

FPGA compatibility core for boards with FT2232 or FT4232
to read/write config FLASH with
[flashrom](https://www.flashrom.org/Flashrom) utility.

"flashrom" utility supports a lot of different FLASH chips.

Core is the passthru of DBUS0-3 pins from FT2232/4232 to
SPI FLASH chip. Additional 2 columns are reference in case
the FT2232/4232 pins are labeled as ther JTAG or RS232 role.

| FLASH | FLASH | FT2232 | JTAG | RS232 |
|-------|-------|--------|------|-------|
| CLK   |  CLK  | DBUS0  | TCK  |  RXD  |
| MOSI  |  IO0  | DBUS1  | TDI  |  TXD  |
| MISO  |  IO1  | DBUS2  | TDO  |  CTS  |
| CSn   |  CSn  | DBUS3  | TMS  |  RTS  |
| WPn   |  IO2  |  VCC   | VCC  |  VCC  |
| HOLDn |  IO3  |  VCC   | VCC  |  VCC  |
| GND   |  GND  |  GND   | GND  |  GND  |

Usage:

Upload bitstream with openFPGALoader:

    make prog_ofl

or with openocd:

    make prog_ocd

Check that it works:

    make test
    ...
    Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) on ft2232_spi.
    ...

use "flashrom" utility to write bitstream to FLASH:

    make flash_rom

use "openFPGALoader" utility to write bitstream to FLASH:

    make flash_ofl

use native utility and Altera USB Blaster to write bitstream to FLASH:

    make flash
