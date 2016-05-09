----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 07:13:45 AM
-- Design Name: 
-- Module Name: panel_input_handler_c - Behavioral
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

entity panel_input_handler_c is
  generic(PANEL_RESET_POS, PANEL_HIGHT, WINDOW_HIGHT, PANEL_SPEED_COUNTER_MAX : natural);
  Port ( btn_up : in STD_LOGIC;
         btn_down : in STD_LOGIC;
         clk : in STD_LOGIC;
         res_n : in STD_LOGIC;
         panel_pos : out STD_LOGIC_VECTOR (8 downto 0));
end panel_input_handler_c;

architecture Behavioral of panel_input_handler_c is
signal panel_pos_tmp : natural range 0 to WINDOW_HIGHT - PANEL_HIGHT - 1 := PANEL_RESET_POS;
signal panel_speed_counter : natural range 0 to PANEL_SPEED_COUNTER_MAX - 1 := 0;
begin
  seq : process(clk, res_n)
  begin
    if (res_n = '0') then
      panel_pos_tmp <= PANEL_RESET_POS;
      panel_speed_counter <= 0;
    elsif (rising_edge(clk)) then
      if ((btn_up = '1') and (btn_down = '0')) then
        if (panel_speed_counter < PANEL_SPEED_COUNTER_MAX - 1) then
          panel_speed_counter <= panel_speed_counter + 1;
        else
          panel_speed_counter <= 0;
        end if;
        if ((panel_pos_tmp < WINDOW_HIGHT - PANEL_HIGHT - 1) and (panel_speed_counter = 0)) then
          panel_pos_tmp <= panel_pos_tmp + 1;
        end if;
      elsif ((btn_down = '1') and (btn_up = '0')) then
        if (panel_speed_counter < PANEL_SPEED_COUNTER_MAX - 1) then
          panel_speed_counter <= panel_speed_counter + 1;
        else
          panel_speed_counter <= 0;
        end if;
        if ((panel_pos_tmp > 0) and (panel_speed_counter = 0)) then
          panel_pos_tmp <= panel_pos_tmp - 1;
        end if;
      else
        panel_speed_counter <= 0;
      end if;
    end if;
  end process;
  panel_pos <= STD_LOGIC_VECTOR(to_unsigned(panel_pos_tmp, panel_pos'length));
end Behavioral;
