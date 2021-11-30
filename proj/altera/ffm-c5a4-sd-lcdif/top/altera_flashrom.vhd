----------------------------
-- For FFM/FFC board
-- AUTHOR=EMARD
-- LICENSE=MIT
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
  -- B-port works on new module V4r0 with 3 LEDs
  ftdi_bdbus0  : in  std_logic;
  ftdi_bdbus1  : in  std_logic;
  ftdi_bdbus2  : out std_logic;
  ftdi_bdbus3  : in  std_logic;
  -- C-port doesn't work on old module V2r0 with 1 LED
  --ftdi_cdbus0  : in  std_logic;
  --ftdi_cdbus1  : in  std_logic;
  --ftdi_cdbus2  : out std_logic;
  --ftdi_cdbus3  : in  std_logic;
  -- LEDs on PS/2 pinout for old module V2r0
  --fio          : inout std_logic_vector(7 downto 0);
  -- LEDs on V4r0
  led          : out std_logic_vector(2 downto 0)
);
end;

architecture struct of altera_flashrom is
  alias clk         : std_logic is clock_50a  ;

  --alias ftdi_bdbus0   : std_logic is uart1_rxd;
  --alias ftdi_bdbus1   : std_logic is uart1_txd;
  --alias ftdi_bdbus2   : std_logic is uart1_cts;
  --alias ftdi_bdbus3   : std_logic is uart1_rts;

  --alias flash_clk   : std_logic is dclk       ;
  --alias flash_mosi  : std_logic is as_data0   ;
  --alias flash_miso  : std_logic is epcs_data1 ;
  --alias flash_csn   : std_logic is epcs_ncso  ;
  --alias flash_wpn   : std_logic is epcs_data2 ;
  --alias flash_holdn : std_logic is epcs_data3 ;

  --alias led_ps2_green: std_logic is fio(5); -- green LED
  --alias led_ps2_red:   std_logic is fio(7); -- red LED

  COMPONENT altserial_flash_loader
  GENERIC
  (
    intended_device_family  : STRING  ;
    enhanced_mode           : NATURAL ;
    enable_shared_access    : STRING  ;
    enable_quad_spi_support : NATURAL ;
    ncso_width              : NATURAL
  );
  PORT
  (
    dclkin                  : in  std_logic;
    scein                   : in  std_logic;
    sdoin                   : in  std_logic;
    data0out                : out std_logic;
    data_in                 : in  std_logic_vector(3 downto 0);
    data_oe                 : in  std_logic_vector(3 downto 0);
    data_out                : out std_logic_vector(3 downto 0);
    noe                     : in  std_logic;
    asmi_access_granted     : in  std_logic;
    asmi_access_request     : out std_logic
  );
  END COMPONENT;

  signal csn, sck, miso, mosi: std_logic;
begin

--  flash_clk   <= ftdi_bdbus0 ;
--  flash_mosi  <= ftdi_bdbus1 ;
--  ftdi_bdbus2 <= flash_miso  ;
--  flash_csn   <= ftdi_bdbus3 ;
--  flash_wpn   <= '1';
--  flash_holdn <= '1';

  spiflash: altserial_flash_loader
  GENERIC MAP
  (
    -- INTENDED_DEVICE_FAMILY  => "Cyclone 10 LP",
    -- INTENDED_DEVICE_FAMILY  => "Cyclone IV E",
    INTENDED_DEVICE_FAMILY  => "Cyclone V",
    ENHANCED_MODE           => 1,
    ENABLE_SHARED_ACCESS    => "ON",
    ENABLE_QUAD_SPI_SUPPORT => 0,
    NCSO_WIDTH              => 1
  )
  PORT MAP
  (
    dclkin   => sck,  -- ftdi_bdbus0,
    sdoin    => mosi, -- ftdi_bdbus1,
    data0out => miso, -- ftdi_bdbus2,
    scein    => csn,  -- ftdi_bdbus3,
    data_in  => x"0",
    data_oe  => x"0",
    data_out => open,
    noe      => '0',
    asmi_access_granted => '1',
    asmi_access_request => open
  );

  sck  <= ftdi_bdbus0;
  mosi <= ftdi_bdbus1;
  ftdi_bdbus2 <= miso;
  --ftdi_bdbus2 <= ftdi_bdbus1; -- loopback for debug
  csn  <= ftdi_bdbus3;

  led(0)      <= sck;  -- green
  led(1)      <= mosi; -- yellow
  led(2)      <= miso; -- red

  -- led_ps2_green <= mosi;
  -- led_ps2_red   <= miso;

end struct;
