----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2016 03:53:32 PM
-- Design Name: 
-- Module Name: score_c - Behavioral
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
use work.defines.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity score_c is
    Port ( clk : in STD_LOGIC;
           res_n : in STD_LOGIC;
           enb : in STD_LOGIC;
           l_scored : in STD_LOGIC;
           r_scored : in STD_LOGIC;
           x_coord : out STD_LOGIC_VECTOR (9 downto 0);
           y_coord : out STD_LOGIC_VECTOR (8 downto 0);
           sel : out STD_LOGIC;
           rgb : out color_t);
end score_c;

architecture Behavioral of score_c is

begin


end Behavioral;
