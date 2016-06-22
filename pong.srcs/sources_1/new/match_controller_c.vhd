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
        enb : in STD_LOGIC;
        left_panel_up : in STD_LOGIC;
        left_panel_down : in STD_LOGIC;
        right_panel_up : in STD_LOGIC;
        right_panel_down : in STD_LOGIC);
end match_controller_c;

architecture Behavioral of match_controller_c is

component panel_input_handler_c is
  generic(PANEL_RESET_POS, PANEL_HIGHT, WINDOW_HIGHT, PANEL_SPEED_COUNTER_MAX : natural);
  Port ( btn_up : in STD_LOGIC;
         btn_down : in STD_LOGIC;
         clk : in STD_LOGIC;
         res_n : in STD_LOGIC;
         enb : in STD_LOGIC;
         panel_pos : out STD_LOGIC_VECTOR (8 downto 0));
end component;

component ball_movement_c is
  generic(FIELD_WIDTH, FIELD_HIGHT, BALL_SIZE, RESET_X_POS, RESET_Y_POS, Y_SPEED_COUNTER_MAX, X_SPEED_COUNTER_MAX : natural);
  Port ( clk : in STD_LOGIC;
         res_n : in STD_LOGIC;
         enb : in STD_LOGIC;
         x_pos : out STD_LOGIC_VECTOR (9 downto 0);
         y_pos : out STD_LOGIC_VECTOR (8 downto 0));
end component;
signal DEB_COUNTER_MAX : natural;
signal left_panel_pos_wire : STD_LOGIC_VECTOR (8 downto 0);
signal right_panel_pos_wire : STD_LOGIC_VECTOR (8 downto 0);
begin
  panel_input_handler_left_I : panel_input_handler_c
  generic map(PANEL_RESET_POS => 0, PANEL_HIGHT => 50, WINDOW_HIGHT => 640, PANEL_SPEED_COUNTER_MAX => 30)
  port map(
    clk => clk,
    res_n => res_n,
    enb => enb,
    btn_up => left_panel_up,
    btn_down => left_panel_down,
    panel_pos => left_panel_pos_wire
  );

  panel_input_handler_right_I : panel_input_handler_c
  generic map(PANEL_RESET_POS => 0, PANEL_HIGHT => 50, WINDOW_HIGHT => 640, PANEL_SPEED_COUNTER_MAX => 30)
  port map(
    clk => clk,
    res_n => res_n,
    enb => enb,
    btn_up => right_panel_up,
    btn_down => right_panel_down,
    panel_pos => right_panel_pos_wire
  );
end Behavioral;
