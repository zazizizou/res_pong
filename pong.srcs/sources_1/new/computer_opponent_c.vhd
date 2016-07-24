----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/24/2016 09:22:01 AM
-- Design Name: 
-- Module Name: computer_opponent_c - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity computer_opponent_c is
    Port ( clk           : in  STD_LOGIC;
           res_n         : in  STD_LOGIC;
           enb           : in  STD_LOGIC;
           y_paddle_left : in  y_axis_t;
           x_ball        : in  x_axis_t;
           y_ball        : in  y_axis_t;
           btn_up        : out STD_LOGIC;
           btn_down      : out STD_LOGIC);
end computer_opponent_c;

architecture Behavioral of computer_opponent_c is

begin
  btn: process(res_n, clk)
  begin
    if(res_n = '0') then
      btn_up   <= '0';
      btn_down <= '0';
    elsif rising_edge(clk) then
      if (to_integer(unsigned(y_ball)) + (BALL_SIZE / 2)) > (to_integer(unsigned(y_paddle_left)) + (PADDLE_HIGHT / 2)) then
        btn_up <= '0';
        btn_down <= '1';
      elsif (to_integer(unsigned(y_ball)) + (BALL_SIZE / 2)) < (to_integer(unsigned(y_paddle_left)) + (PADDLE_HIGHT / 2)) then
        btn_up <= '1';
        btn_down <= '0';      
      else
        btn_up <= '0';
        btn_down <= '0';      
      end if;
    end if;
  end process;

end Behavioral;
