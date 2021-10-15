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

Attempt for altera, doesn't work because
it is not known to author how to set compiler
options to make SPI FLASH passthru.
