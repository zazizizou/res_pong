----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2016 08:57:40 PM
-- Design Name: 
-- Module Name: bcd_2_7seg_c - Behavioral
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

entity bcd_2_7seg_c is
    Port ( bcd       : in  STD_LOGIC_VECTOR (3 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end bcd_2_7seg_c;

architecture Behavioral of bcd_2_7seg_c is

begin
  decoder: process (bcd)
  begin
    case  bcd is
      when "0000"=> seven_seg <="1111110";  -- '0'
      when "0001"=> seven_seg <="0110000";  -- '1'
      when "0010"=> seven_seg <="1101101";  -- '2'
      when "0011"=> seven_seg <="1111001";  -- '3'
      when "0100"=> seven_seg <="0110011";  -- '4' 
      when "0101"=> seven_seg <="1011011";  -- '5'
      when "0110"=> seven_seg <="1011111";  -- '6'
      when "0111"=> seven_seg <="1110000";  -- '7'
      when "1000"=> seven_seg <="1111111";  -- '8'
      when "1001"=> seven_seg <="1111011";  -- '9'
      when others=> seven_seg <="0010011";  -- ERROR 
    end case;
  end process;
end Behavioral;
