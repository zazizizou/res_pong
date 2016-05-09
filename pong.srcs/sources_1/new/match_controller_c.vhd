----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 04:31:33 PM
-- Design Name: 
-- Module Name: match_controller_c - Behavioral
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

entity match_controller_c is
  Port (clk : in STD_LOGIC;
        res_n : in STD_LOGIC;
        btn_up : in STD_LOGIC;
        btn_down : in STD_LOGIC);
end match_controller_c;

architecture Behavioral of match_controller_c is

component panel_input_handler_c is
  generic(PANEL_RESET_POS, PANEL_HIGHT, WINDOW_HIGHT, PANEL_SPEED_COUNTER_MAX : natural);
  Port ( btn_up : in STD_LOGIC;
         btn_down : in STD_LOGIC;
         clk : in STD_LOGIC;
         res_n : in STD_LOGIC;
         panel_pos : out STD_LOGIC_VECTOR (8 downto 0));
end component;
signal DEB_COUNTER_MAX : natural;
begin
end Behavioral;
