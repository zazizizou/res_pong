----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/08/2016 09:03:25 AM
-- Design Name: 
-- Module Name: image_generator_c - Behavioral
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

entity image_generator_c is
    Port ( clk           : in  STD_LOGIC;
           res_n         : in  STD_LOGIC;
           btn_up        : in  STD_LOGIC;
           btn_down      : in  STD_LOGIC;
           x_coord       : in  x_axis_t;
           y_coord       : in  y_axis_t;
           enb           : in  STD_LOGIC;
           l_scored      : in  STD_LOGIC;
           r_scored      : in  STD_LOGIC;
           l_paddle_hit  : in  STD_LOGIC;
           r_paddle_hit  : in  STD_LOGIC;
           rgb           : out color_t;
           y_paddle_left : out y_axis_t;
           y_paddle_right: out y_axis_t;
           x_ball        : out x_axis_t;
           y_ball        : out y_axis_t);
end image_generator_c;

architecture Behavioral of image_generator_c is
component score_c
    Port ( clk      : in  STD_LOGIC;
           res_n    : in  STD_LOGIC;
           enb      : in  STD_LOGIC;
           l_scored : in  STD_LOGIC;
           r_scored : in  STD_LOGIC;
           x_coord  : in x_axis_t;
           y_coord  : in y_axis_t;
           sel      : out STD_LOGIC;
           rgb      : out color_t);
end component;

component ball_c
  Port ( clk          : in  STD_LOGIC;
         res_n        : in  STD_LOGIC;
         enb          : in  STD_LOGIC;
         l_paddle_hit : in  STD_LOGIC;
         r_paddle_hit : in  STD_LOGIC;
         x_coord      : in  x_axis_t;
         y_coord      : in  y_axis_t;
         x_pos        : out x_axis_t;
         y_pos        : out y_axis_t;
         sel          : out STD_LOGIC;
         rgb          : out color_t);
end component;

component paddle_c
  generic (X_POS : natural; SPEED_COUNTER_MAX : natural);
  Port ( clk      : in  STD_LOGIC;
         res_n    : in  STD_LOGIC;
         enb      : in  STD_LOGIC;
         btn_up   : in  STD_LOGIC;
         btn_down : in  STD_LOGIC;
         x_coord  : in  STD_LOGIC_VECTOR;
         y_coord  : in  STD_LOGIC_VECTOR;
         y_pos    : out y_axis_t;
         sel      : out STD_LOGIC;
         rgb      : out color_t);
end component;

component wall_c
  Port ( clk     : in  STD_LOGIC;
         res_n   : in  STD_LOGIC;
         x_coord : in  x_axis_t;
         y_coord : in  y_axis_t;
         sel     : out STD_LOGIC;
         rgb     : out color_t);
end component;

signal score_sel_wire    : STD_LOGIC;
signal score_rgb_wire    : color_t;
signal ball_sel_wire     : STD_LOGIC;
signal ball_rgb_wire     : color_t;
signal wall_sel_wire     : STD_LOGIC;
signal wall_rgb_wire     : color_t;
signal l_paddle_sel_wire : STD_LOGIC;
signal l_paddle_rgb_wire : color_t;
signal r_paddle_sel_wire : STD_LOGIC;
signal r_paddle_rgb_wire : color_t;
signal mux_sel_wire      : STD_LOGIC_VECTOR (4 downto 0);
signal enb_wire          : STD_LOGIC;

begin

  score_I: score_c
  port map (
    clk      => clk,
    res_n    => res_n,
    enb      => enb,
    l_scored => l_scored,
    r_scored => r_scored,
    x_coord  => x_coord,
    y_coord  => y_coord,
    sel      => score_sel_wire,
    rgb      => score_rgb_wire
  );

  ball_I: ball_c
  port map (
    clk          => clk,
    res_n        => res_n,
    enb          => enb_wire,
    l_paddle_hit => l_paddle_hit,
    r_paddle_hit => r_paddle_hit,
    x_coord      => x_coord,
    y_coord      => y_coord,
    x_pos        => x_ball,
    y_pos        => y_ball,
    sel          => ball_sel_wire,
    rgb          => ball_rgb_wire
  );
  
  l_paddle_I: paddle_c
  generic map (L_PADDLE_POS_X, L_PADDLE_SPEED_COUNTER_MAX)
  port map (
    clk      => clk,
    res_n    => res_n,
    enb      => enb_wire,
    btn_up   => btn_up,
    btn_down => btn_down,
    x_coord  => x_coord,
    y_coord  => y_coord,
    y_pos    => y_paddle_left,
    sel      => l_paddle_sel_wire,
    rgb      => l_paddle_rgb_wire
  );
  
  r_paddle_I: paddle_c
  generic map (R_PADDLE_POS_X, R_PADDLE_SPEED_COUNTER_MAX)
  port map (
    clk      => clk,
    res_n    => res_n,
    enb      => enb_wire,
    btn_up   => btn_up,
    btn_down => btn_down,
    x_coord  => x_coord,
    y_coord  => y_coord,
    y_pos    => y_paddle_right,
    sel      => r_paddle_sel_wire,
    rgb      => r_paddle_rgb_wire
  );

  wall_I: wall_c
  port map (
    clk     => clk,
    res_n   => res_n,
    x_coord => x_coord,
    y_coord => y_coord,
    sel     => wall_sel_wire,
    rgb     => wall_rgb_wire
  );

  mux_sel_wire <= wall_sel_wire & ball_sel_wire & l_paddle_sel_wire & r_paddle_sel_wire & score_sel_wire;
  enb_wire <= enb and (not l_scored) and (not r_scored);

  mux : process(mux_sel_wire, wall_rgb_wire, ball_rgb_wire, l_paddle_rgb_wire, r_paddle_rgb_wire, score_sel_wire)
  begin
    case mux_sel_wire is
      when "11111" => rgb <= wall_rgb_wire;
      when "11110" => rgb <= wall_rgb_wire;
      when "11101" => rgb <= wall_rgb_wire;
      when "11100" => rgb <= wall_rgb_wire;
      when "11011" => rgb <= wall_rgb_wire;
      when "11010" => rgb <= wall_rgb_wire;
      when "11001" => rgb <= wall_rgb_wire;
      when "11000" => rgb <= wall_rgb_wire;
      when "10111" => rgb <= wall_rgb_wire;
      when "10110" => rgb <= wall_rgb_wire;
      when "10101" => rgb <= wall_rgb_wire;
      when "10100" => rgb <= wall_rgb_wire;
      when "10011" => rgb <= wall_rgb_wire;
      when "10010" => rgb <= wall_rgb_wire;
      when "10001" => rgb <= wall_rgb_wire;
      when "10000" => rgb <= wall_rgb_wire;
      when "01111" => rgb <= ball_rgb_wire;
      when "01110" => rgb <= ball_rgb_wire;
      when "01101" => rgb <= ball_rgb_wire;
      when "01100" => rgb <= ball_rgb_wire;
      when "01011" => rgb <= ball_rgb_wire;
      when "01010" => rgb <= ball_rgb_wire;
      when "01001" => rgb <= ball_rgb_wire;
      when "01000" => rgb <= ball_rgb_wire;
      when "00111" => rgb <= l_paddle_rgb_wire;
      when "00110" => rgb <= l_paddle_rgb_wire;
      when "00101" => rgb <= l_paddle_rgb_wire;
      when "00100" => rgb <= l_paddle_rgb_wire;
      when "00011" => rgb <= r_paddle_rgb_wire;
      when "00010" => rgb <= r_paddle_rgb_wire;
      when "00001" => rgb <= score_rgb_wire;
      when others => rgb <= BLACK;
    end case;
  end process;
end Behavioral;
