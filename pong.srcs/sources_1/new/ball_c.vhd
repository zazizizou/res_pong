----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 09:03:22 AM
-- Design Name: 
-- Module Name: ball_c - Behavioral
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
use work.defines.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ball_c is
  Port ( clk          : in  STD_LOGIC;
         res_n        : in  STD_LOGIC;
         enb          : in  STD_LOGIC;
         l_paddle_hit : in  STD_LOGIC;
         r_paddle_hit : in  STD_LOGIC;
         x_coord      : in  x_axis_t;
         y_coord      : in  y_axis_t;
         x_pos        : out x_axis_t;
         y_pos        : out y_axis_t;
         x_direction  : out x_direction_t;
         sel          : out STD_LOGIC;
         rgb          : out color_t);
end ball_c;

architecture Behavioral of ball_c is

signal x_pos_tmp        : natural range 0 to WINDOW_WIDTH - BALL_SIZE - 1;
signal y_pos_tmp        : natural range 0 to WINDOW_HIGHT - BALL_SIZE - 1;
signal x_speed_counter  : natural range 0 to BALL_SPEED_COUNTER_MAX - 1 := 0;
signal y_speed_counter  : natural range 0 to BALL_SPEED_COUNTER_MAX - 1 := 0;
signal x_direction_wire : x_direction_t := RIGHT;
signal y_direction      : y_direction_t := DOWN;
begin
  rgb_p : process(clk, res_n)
  begin
    if(res_n = '0') then
      sel <= '0';
    elsif(rising_edge(clk)) then
      if((to_integer(unsigned(x_coord)) > x_pos_tmp) and (to_integer(unsigned(x_coord)) < (x_pos_tmp + BALL_SIZE))
        and (to_integer(unsigned(y_coord)) > y_pos_tmp) and (to_integer(unsigned(y_coord)) < (y_pos_tmp + BALL_SIZE))) then
        sel <= '1';
      else
        sel <= '0';
      end if;
    end if;
  end process;

  movement_p : process(clk, res_n)
  begin
    if(res_n = '0') then
      x_pos_tmp <= BALL_RESET_POS_X;
      y_pos_tmp <= BALL_RESET_POS_Y;
      x_direction_wire <= RIGHT;
      y_direction <= DOWN;
      x_speed_counter <= 0;
      y_speed_counter <= 0;
    elsif(rising_edge(clk)) then
      if(enb = '1') then -- ball movement module is enabled
        if(l_paddle_hit = '1') then
          x_direction_wire <= RIGHT;
        elsif(r_paddle_hit = '1') then
          x_direction_wire <= LEFT;
        else
          --dividing clk so the ball has the right movement speed
          if(x_speed_counter < BALL_SPEED_COUNTER_MAX - 1) then
            x_speed_counter <= x_speed_counter + 1;
          else
            x_speed_counter <= 0;
          end if;
          if(y_speed_counter < BALL_SPEED_COUNTER_MAX - 1) then
            y_speed_counter <= y_speed_counter + 1;
          else
            y_speed_counter <= 0;
          end if;
          --move the ball everytime the speed_counter is 0
          if(x_speed_counter = 0) then
            if(x_direction_wire = LEFT) then -- ball is moving to the left
              if(x_pos_tmp > 0) then -- ball is not at the left edge
                x_pos_tmp <= x_pos_tmp - 1;
              else -- ball is at the left edge
                x_direction_wire <= RIGHT;
                x_pos_tmp <= x_pos_tmp + 1;
              end if;
            else -- ball is moving to the right
              if(x_pos_tmp < WINDOW_WIDTH - BALL_SIZE - 1) then -- ball is not at the right edge
                x_pos_tmp <= x_pos_tmp + 1;
              else -- ball is at the right edge
                x_direction_wire <= LEFT;
                x_pos_tmp <= x_pos_tmp - 1;
              end if;
            end if;
          end if;
          if(y_speed_counter = 0) then
            if(y_direction = UP) then -- ball is moving to the top
              if(y_pos_tmp >= WALL_THICKNESS) then -- ball is not at the top edge
                y_pos_tmp <= y_pos_tmp - 1;
              else -- ball is at the top edge
                y_direction <= DOWN;
                y_pos_tmp <= y_pos_tmp + 1;
              end if;
            else -- ball is moving to the bottom
              if(y_pos_tmp < WINDOW_HIGHT - BALL_SIZE - WALL_THICKNESS) then -- ball is not at the bottom edge
                y_pos_tmp <= y_pos_tmp + 1;
              else -- ball is at the bottom edge
                y_direction <= UP;
                y_pos_tmp <= y_pos_tmp - 1;
              end if;
            end if;
          end if;
        end if;
      else -- ball movement module is disabled
        x_pos_tmp <= BALL_RESET_POS_X;
        y_pos_tmp <= BALL_RESET_POS_Y;
        x_direction_wire <= RIGHT;
        y_direction <= DOWN;
        x_speed_counter <= 0;
        y_speed_counter <= 0;
      end if;
    end if;
  end process;
  -- outputs
  x_direction <= x_direction_wire;
  rgb <= WHITE;
  x_pos <= STD_LOGIC_VECTOR(to_unsigned(x_pos_tmp, x_pos'length));
  y_pos <= STD_LOGIC_VECTOR(to_unsigned(y_pos_tmp, y_pos'length));
end Behavioral;
