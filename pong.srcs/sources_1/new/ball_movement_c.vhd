----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 09:03:22 AM
-- Design Name: 
-- Module Name: ball_movement_c - Behavioral
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

entity ball_movement_c is
generic(FIELD_WIDTH, FIELD_HIGHT, RESET_X_POS, RESET_Y_POS, Y_SPEED_COUNTER_MAX, X_SPEED_COUNTER_MAX : natural);
  Port ( clk : in STD_LOGIC;
         res_n : in STD_LOGIC;
         enb : in STD_LOGIC;
         x_pos : out STD_LOGIC_VECTOR (9 downto 0);
         y_pos : out STD_LOGIC_VECTOR (8 downto 0));
end ball_movement_c;

architecture Behavioral of ball_movement_c is
type x_direction_t is (RIGHT, LEFT);
type y_direction_t is (DOWN, UP);
signal x_pos_tmp : natural range 0 to FIELD_WIDTH - 1;
signal y_pos_tmp : natural range 0 to FIELD_HIGHT - 1;
signal x_speed_counter : natural range 0 to X_SPEED_COUNTER_MAX - 1 := 0;
signal y_speed_counter : natural range 0 to Y_SPEED_COUNTER_MAX - 1 := 0;
signal x_direction : x_direction_t := RIGHT;
signal y_direction : y_direction_t := DOWN;
begin
  seq : process(clk, res_n)
  begin
    if(res_n = '0') then
      x_pos_tmp <= RESET_X_POS;
      y_pos_tmp <= RESET_Y_POS;
      x_speed_counter <= 0;
      y_speed_counter <= 0;
    elsif(rising_edge(clk)) then
      if(enb = '1') then
        if(x_speed_counter < X_SPEED_COUNTER_MAX - 1) then
          x_speed_counter <= x_speed_counter + 1;
        else
          x_speed_counter <= 0;
        end if;
        if(y_speed_counter < Y_SPEED_COUNTER_MAX - 1) then
          y_speed_counter <= y_speed_counter + 1;
        else
          y_speed_counter <= 0;
        end if;
        if(x_speed_counter = 0) then
          if(x_direction = LEFT) then
            if(x_pos_tmp > 0) then
              x_pos_tmp <= x_pos_tmp - 1;
            else 
              x_direction <= RIGHT;
              x_pos_tmp <= x_pos_tmp + 1;
            end if;
          else 
            if(x_pos_tmp < FIELD_WIDTH - 1) then
              x_pos_tmp <= x_pos_tmp + 1;
            else
              x_direction <= LEFT;
              x_pos_tmp <= x_pos_tmp - 1;
            end if;
          end if;
        end if;
        if(y_speed_counter = 0) then
          if(y_direction = UP) then
            if(y_pos_tmp > 0) then
              y_pos_tmp <= y_pos_tmp - 1;
            else
              y_direction <= DOWN;
              y_pos_tmp <= y_pos_tmp + 1;
            end if;
          else
            if(y_pos_tmp < FIELD_HIGHT - 1) then
              y_pos_tmp <= y_pos_tmp + 1;
            else
              y_direction <= UP;
              y_pos_tmp <= y_pos_tmp - 1;
            end if;
          end if;
        end if;
      else
        x_speed_counter <= 0;
        y_speed_counter <= 0;
      end if;
    end if;
  end process;
  x_pos <= STD_LOGIC_VECTOR(to_unsigned(x_pos_tmp, x_pos'length));
  y_pos <= STD_LOGIC_VECTOR(to_unsigned(y_pos_tmp, y_pos'length));
end Behavioral;
