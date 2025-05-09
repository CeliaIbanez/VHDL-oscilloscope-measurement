----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2025 16:03:45
-- Design Name: 
-- Module Name: XADC_WRAPPER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XADC_WRAPPER is
  Port ( 
  clk: in std_logic;
  reset: in std_logic ;
  
  Vaux1_v_n: in std_logic;
  Vaux1_v_p: in std_logic;
  
  start: in std_logic;
  leds: out std_logic_vector (11 downto 0)
   );
end XADC_WRAPPER;

architecture Behavioral of XADC_WRAPPER is

component freq_counter is
    Port(
    clk: in std_logic;
    reset: in std_logic;
    --- mas cosas
    signal_in   : in  std_logic;                         -- Signal whose frequency is to be measured
    freq_value  : out std_logic_vector(31 downto 0)      -- Output frequency value (in Hz)
    );
end component;

    constant zero : std_logic:= '0';

    signal di, do : std_logic_vector(15 downto 0);
    signal daddr : std_logic_vector(6 downto 0);
    signal den, dwe, drdy : std_logic;

begin


    XADC_INST : entity work.xadc_wiz_0
      PORT MAP (
        di_in => di,
        daddr_in => daddr,
        den_in => den,
        dwe_in => dwe,
        drdy_out => drdy,
        do_out => do,
        dclk_in => clk,
        reset_in => reset,
        vp_in => zero,
        vn_in => zero,
        vauxp1 => Vaux1_v_p,
        vauxn1 => Vaux1_v_n,
        channel_out => open,
        eoc_out => open,
        alarm_out => open,
        eos_out => open,
        busy_out => open
      );

end Behavioral;
