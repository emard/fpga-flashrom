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
  --uart1_dbus0: in  std_logic; -- dbus0
  --uart1_dbus1: in  std_logic; -- dbus1
  --uart1_dbus2: out std_logic; -- dbus2
  --uart1_dbus3: in  std_logic; -- dbus3
  uart1_rxd  : in  std_logic; -- dbus0
  uart1_txd  : in  std_logic; -- dbus1
  uart1_cts  : out std_logic; -- dbus2
  uart1_rts  : in  std_logic; -- dbus3
  -- FLASH (SPI)
--  dclk       : out std_logic; -- clk
--  as_data0   : out std_logic; -- mosi
--  epcs_data1 : in  std_logic; -- miso
--  epcs_data2 : out std_logic; -- 1
--  epcs_data3 : out std_logic; -- 1
--  epcs_ncso  : out std_logic;
  -- LED
  led: out std_logic
);
end;

architecture struct of altera_flashrom is
  alias clk         : std_logic is clock_50a  ;

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

  led         <= '1';

end struct;
