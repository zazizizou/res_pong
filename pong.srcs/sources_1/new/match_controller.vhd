----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:10 07/23/2016 
-- Design Name: 
-- Module Name:    match_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.defines.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity match_controller is
    Port ( 
			  clkfx			: 		in  STD_LOGIC;
			  res_n			: 		in  STD_LOGIC;
			  
			  y_paddle_left: 		in  y_axis_t;
           y_paddle_right: 		in  y_axis_t;
           x_ball 		: 	in  x_axis_t;
           y_ball 		: 	in  y_axis_t;
			  l_scored 		: 		out  STD_LOGIC;
           r_scored 		: 		out  STD_LOGIC;
           l_paddle_hit : 	out  STD_LOGIC;
           r_paddle_hit : 	out  STD_LOGIC);
end match_controller;


architecture Behavioral of match_controller is

signal current_state 	: std_logic_vector (4 downto 0) := "00001"; -- one-hot

begin
  controller : process (res_n, clkfx) -- , RSTBTN
  begin
  if (not res_n = '1') then
    l_scored <= '0';
    r_scored <= '0';
    l_paddle_hit <= '0';
    r_paddle_hit <= '0';
  elsif rising_edge(clkfx) then
   case current_state is
		when "00001" =>
			if (x_ball = L_PADDLE_BLOCK and y_ball+BALL_SIZE>y_paddle_left and y_ball<(y_paddle_left+PADDLE_HIGHT)) then
				l_paddle_hit <= '1';
				current_state <= "00010";
			elsif (x_ball = R_PADDLE_BLOCK and y_ball+BALL_SIZE>y_paddle_right and y_ball<(y_paddle_right+PADDLE_HIGHT)) then
				r_paddle_hit <= '1';
				current_state <= "00100";
			elsif (x_ball = 0 ) then
				r_scored <= '1';
				current_state <= "01000";
			elsif (x_ball+BALL_SIZE = WINDOW_WIDTH-1) then
				l_scored <= '1';
				current_state <= "10000";
			end if;
		when "00010" =>			-- l_paddle_hit
			l_scored <= '0';
			r_scored <= '0';
			l_paddle_hit <= '0';
			r_paddle_hit <= '0';
			current_state <= "00001";
		when "00100" =>			-- r_paddle_hit
			l_scored <= '0';
			r_scored <= '0';
			l_paddle_hit <= '0';
			r_paddle_hit <= '0';
			current_state <= "00001";			
		when "01000" =>			-- l_scored
			l_scored <= '0';
			r_scored <= '0';
			l_paddle_hit <= '0';
			r_paddle_hit <= '0';
			current_state <= "00001";
		when "10000" =>			-- r_scored
			l_scored <= '0';
			r_scored <= '0';
			l_paddle_hit <= '0';
			r_paddle_hit <= '0';
			current_state <= "00001";
			--default
		when others =>
			l_scored <= '0';
			r_scored <= '0';
			l_paddle_hit <= '0';
			r_paddle_hit <= '0';
			current_state <= "00001";
	end case;
  
  end if;
  end process;


end Behavioral;

