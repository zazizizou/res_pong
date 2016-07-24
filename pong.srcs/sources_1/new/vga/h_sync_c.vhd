----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2016 01:48:38 PM
-- Design Name: 
-- Module Name: h_sync_c - Behavioral
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

entity h_sync_c is
  Port ( clk        : in STD_LOGIC;
         res_n      : in STD_LOGIC;
         h_sync     : out STD_LOGIC;
         v_sync_enb : out STD_LOGIC;
         h_count    : out STD_LOGIC_VECTOR (9 downto 0));
end h_sync_c;

architecture Behavioral of h_sync_c is
  signal counter    : natural range 0 to 799 := 0;
  signal h_sync_tmp : STD_LOGIC := '0';
begin
  count : process (clk, res_n)
  begin
    if (res_n = '0') then
      h_sync_tmp  <= '0';
      counter     <= 0;
    elsif rising_edge(clk) then
      counter <= counter + 1;
      case counter is
        when 0      => h_sync_tmp <= '1';
                       v_sync_enb <= '1';
        when 1      => v_sync_enb <= '0';
        when 96     => h_sync_tmp <= '0';
        when 799    => counter <= 0;
        when others => h_sync_tmp <= h_sync_tmp;
      end case;
    end if;
  end process;
  h_sync  <= h_sync_tmp;
  h_count <= STD_LOGIC_VECTOR(to_unsigned(counter, h_count'length));
end Behavioral;
