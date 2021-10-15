----------------------------
-- ULX3S Top level for MINIMIG
-- http://github.com/emard
----------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

entity altera_flashrom is
port
(
  clock_50a: in std_logic;
  -- FT2232/4232
--  uart1_rxd  : in  std_logic; -- bdbus0
--  uart1_txd  : in  std_logic; -- bdbus1
--  uart1_cts  : out std_logic; -- bdbus2
--  uart1_rts  : in  std_logic; -- bdbus3
  ftdi_bdbus0  : in  std_logic;
  ftdi_bdbus1  : in  std_logic;
  ftdi_bdbus2  : out std_logic;
  ftdi_bdbus3  : in  std_logic;
--  ftdi_cdbus0  : in  std_logic;
--  ftdi_cdbus1  : in  std_logic;
--  ftdi_cdbus2  : out std_logic;
--  ftdi_cdbus3  : in  std_logic;
  -- FLASH (SPI)
--  dclk       : out std_logic; -- clk
--  as_data0   : out std_logic; -- mosi
--  epcs_data1 : in  std_logic; -- miso
--  epcs_data2 : out std_logic; -- 1
--  epcs_data3 : out std_logic; -- 1
--  epcs_ncso  : out std_logic;
  -- LED
  led        : out std_logic_vector(2 downto 0)
);
end;

architecture struct of altera_flashrom is
  alias clk         : std_logic is clock_50a  ;

--  alias ftdi_bdbus0   : std_logic is uart1_rxd  ;
--  alias ftdi_bdbus1   : std_logic is uart1_txd  ;
--  alias ftdi_bdbus2   : std_logic is uart1_cts  ;
--  alias ftdi_bdbus3   : std_logic is uart1_rts  ;

--  alias flash_clk   : std_logic is dclk       ;
--  alias flash_mosi  : std_logic is as_data0   ;
--  alias flash_miso  : std_logic is epcs_data1 ;
--  alias flash_csn   : std_logic is epcs_ncso  ;
--  alias flash_wpn   : std_logic is epcs_data2 ;
--  alias flash_holdn : std_logic is epcs_data3 ;

begin

--  flash_clk   <= uart1_rxd  ; -- dbus0
--  flash_mosi  <= uart1_txd  ; -- dbus1
--  uart1_cts   <= flash_miso ; -- dbus2
--  flash_csn   <= uart1_rts  ; -- dbus3
--  flash_wpn   <= '1';
--  flash_holdn <= '1';

  ftdi_bdbus2 <= ftdi_bdbus1; -- loopback MISO-MOSI

  led(0)      <= ftdi_bdbus0;
  led(1)      <= ftdi_bdbus1;
  led(2)      <= ftdi_bdbus3;

--  led(0)      <= ftdi_cdbus0;
--  led(1)      <= ftdi_cdbus1;
--  led(2)      <= ftdi_cdbus3;

end struct;
