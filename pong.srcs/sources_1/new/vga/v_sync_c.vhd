----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2016 02:47:09 PM
-- Design Name: 
-- Module Name: v_sync_c - Behavioral
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

entity v_sync_c is
  Port ( clk     : in STD_LOGIC;
         res_n   : in STD_LOGIC;
         enb     : in STD_LOGIC;
         v_sync  : out STD_LOGIC;
         v_count : out STD_LOGIC_VECTOR (9 downto 0));
end v_sync_c;

architecture Behavioral of v_sync_c is
  signal counter    : natural range 0 to 524 := 0;
  signal v_sync_tmp : STD_LOGIC;
begin
  count : process (res_n, clk)
  begin
    if (res_n = '0') then
      v_sync_tmp  <= '0';
      counter     <= 0; 
    elsif rising_edge(clk) then
      if (enb = '1') then
        counter <= counter + 1;
        case counter is
          when 0      => v_sync_tmp <= '1';
          when 2      => v_sync_tmp <= '0';
          when 524    => counter    <= 0;
          when others => v_sync_tmp <= v_sync_tmp;
        end case;
      end if;
    end if;
  end process;
  v_sync <= v_sync_tmp;
  v_count <= STD_LOGIC_VECTOR(to_unsigned(counter, v_count'length));
end Behavioral;
