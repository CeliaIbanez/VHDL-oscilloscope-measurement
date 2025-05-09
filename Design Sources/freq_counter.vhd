----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2025 09:43:00 AM
-- Design Name: 
-- Module Name: freq_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity freq_counter is
    Port (
        clk         : in  std_logic;                         -- Reference clock (e.g., 50 MHz)
        rst         : in  std_logic;                         -- Synchronous reset
        signal_in   : in  std_logic;                         -- Signal whose frequency is to be measured
        freq_value  : out std_logic_vector(31 downto 0)      -- Output frequency value (in Hz)
    );
end freq_counter;

architecture Behavioral of freq_counter is
    -- Time base: number of clk cycles for 1 second (e.g., for 50 MHz clock)
    constant CLK_FREQ : integer := 50000000;

    -- Counter to generate 1-second time window
    signal time_counter     : integer range 0 to CLK_FREQ -1;
    
    -- Signal edge detection
    signal signal_in_d      : std_logic := '0';              -- Delayed version of signal_in
    signal rising_edge_detected : std_logic := '0';              -- High when a rising edge is detected

    -- Frequency counting
    signal pulse_count      : std_logic_vector(31 downto 0) := (others => '0'); -- Internal count
    signal measured_freq    : std_logic_vector(31 downto 0) := (others => '0'); -- Latched output

begin
    -- Edge Detection
    process(clk)
    begin
        if rising_edge(clk) then
            signal_in_d <= signal_in;
            if signal_in = '1' and signal_in_d = '0' then
                rising_edge_detected <= '1';
            else
                rising_edge_detected <= '0';
            end if;
        end if;
    end process;
    
    process(clk, rst)
    begin
        if (rst = '1' ) then
            time_counter   <= 0; 
            pulse_count    <= (others => '0');
            measured_freq  <= (others => '0');
        elsif rising_edge(clk) then -- (clk_i'event and clk_i ='1')
            if (time_counter < CLK_FREQ - 1 ) then
                time_counter <= time_counter + 1;
    
                if rising_edge_detected = '1' then
                    pulse_count <= pulse_count + 1;
                end if;
    
            else
                    time_counter  <= 0;
                    measured_freq <= pulse_count;
                    pulse_count   <= (others => '0');
            end if;
            
       end if;
    end process;

-- output
 freq_value <= measured_freq;
 
end Behavioral;
