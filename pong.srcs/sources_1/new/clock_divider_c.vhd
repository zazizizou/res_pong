----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2016 10:27:39 AM
-- Design Name: 
-- Module Name: clock_divider_c - Behavioral
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

entity clock_divider_c is
  generic (CLK_IN_SPEED, CLK_OUT_SPEED : integer);
  Port ( clk_in  : in STD_LOGIC;
         res_n   : in STD_LOGIC;
         clk_out : out STD_LOGIC);
end clock_divider_c;

architecture Behavioral of clock_divider_c is
  constant MAX_COUNTER : integer := CLK_IN_SPEED / CLK_OUT_SPEED / 2;
  signal counter : natural range 0 to MAX_COUNTER-1 := 0;
  signal clk_tmp : STD_LOGIC := '0';
begin
  seq : process (clk_in, res_n)
  begin
    if (res_n = '0') then
      clk_tmp <= '0';
      counter <= 0;
    elsif rising_edge(clk_in) then
      if (counter = MAX_COUNTER-1) then
        clk_tmp <= NOT(clk_tmp);
        counter <= 0;
      else
        clk_tmp <= clk_tmp;
        counter <= counter + 1;
      end if;
    end if;
  end process;
  clk_out <= clk_tmp;
end Behavioral;
