----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2016 01:35:47 PM
-- Design Name: 
-- Module Name: top_c - Behavioral
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

entity top_c is
  Port (clk         : in  STD_LOGIC;
        btnCpuReset : in  STD_LOGIC;
        btnU        : in  STD_LOGIC;
        btnD        : in  STD_LOGIC;
        Hsync       : out STD_LOGIC;
        Vsync       : out STD_LOGIC;
        vgaRed      : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue     : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen    : out STD_LOGIC_VECTOR(3 downto 0));
end top_c;

architecture Behavioral of top_c is

  component debouncer_c
    Port (clk     : in  STD_LOGIC;
          res_n   : in  STD_LOGIC;
          btn     : in  STD_LOGIC;
          deb_btn : out STD_LOGIC);
  end component;
  
  component computer_opponent_c
      Port ( clk              : in  STD_LOGIC;
             res_n            : in  STD_LOGIC;
             enb              : in  STD_LOGIC;
             y_paddle_left    : in  y_axis_t;
             x_ball           : in  x_axis_t;
             y_ball           : in  y_axis_t;
             x_direction_ball : in  x_direction_t;
             btn_up           : out STD_LOGIC;
             btn_down         : out STD_LOGIC);
  end component;
  
  component match_controller
      Port ( 
          clkfx          : in  STD_LOGIC;
          res_n          : in  STD_LOGIC;
          y_paddle_left  : in  y_axis_t;
          y_paddle_right : in  y_axis_t;
          x_ball         : in  x_axis_t;
          y_ball         : in  y_axis_t;
          l_scored       : out STD_LOGIC;
          r_scored       : out STD_LOGIC;
          l_paddle_hit   : out STD_LOGIC;
          r_paddle_hit   : out STD_LOGIC);
  end component;

  component image_generator_c
    Port ( clk              : in  STD_LOGIC;
           res_n            : in  STD_LOGIC;
           btn_up_left      : in  STD_LOGIC;
           btn_down_left    : in  STD_LOGIC;
           btn_up_right     : in  STD_LOGIC;
           btn_down_right   : in  STD_LOGIC;
           x_coord          : in  x_axis_t;
           y_coord          : in  y_axis_t;
           enb              : in  STD_LOGIC;
           l_scored         : in  STD_LOGIC;
           r_scored         : in  STD_LOGIC;
           l_paddle_hit     : in  STD_LOGIC;
           r_paddle_hit     : in  STD_LOGIC;
           rgb              : out color_t;
           y_paddle_left    : out y_axis_t;
           y_paddle_right   : out y_axis_t;
           x_ball           : out x_axis_t;
           y_ball           : out y_axis_t;
           x_direction_ball : out x_direction_t);
  end component;

  component vga_controller_c
  port (clk     : in  STD_LOGIC;
        res_n   : in  STD_LOGIC;
        h_sync  : out STD_LOGIC;
        v_sync  : out STD_LOGIC;
        x_coord : out x_axis_t;
        y_coord : out y_axis_t);
  end component;
  
  signal x_coord_wire          : x_axis_t;
  signal y_coord_wire          : y_axis_t;
  signal rgb_wire              : color_t;
  signal btn_up_left_wire      : STD_LOGIC;
  signal btn_down_left_wire    : STD_LOGIC;
  signal btn_up_right_wire     : STD_LOGIC;
  signal btn_down_right_wire   : STD_LOGIC;
  signal enb_wire              : STD_LOGIC;
  signal y_paddle_left_wire    : y_axis_t;
  signal y_paddle_right_wire   : y_axis_t;
  signal x_ball_wire           : x_axis_t;
  signal y_ball_wire           : y_axis_t;
  signal x_direction_ball_wire : x_direction_t;
  signal l_scored_wire         : STD_LOGIC;
  signal r_scored_wire         : STD_LOGIC;
  signal l_paddle_hit_wire     : STD_LOGIC;
  signal r_paddle_hit_wire     : STD_LOGIC;
begin

  btn_up_debouncer_I : debouncer_c
  port map (
    clk     => clk,
    res_n   => btnCpuReset,
    btn     => btnU,
    deb_btn => btn_up_right_wire
  );
  
  btn_down_debouncer_I : debouncer_c
  port map (
    clk     => clk,
    res_n   => btnCpuReset,
    btn     => btnD,
    deb_btn => btn_down_right_wire
  );
  
  computer_opponent_I: computer_opponent_c
  port map ( 
    clk              => clk,
    res_n            => btnCpuReset,
    enb              => enb_wire,
    y_paddle_left    => y_paddle_left_wire,
    x_ball           => x_ball_wire,
    y_ball           => y_ball_wire,
    x_direction_ball => x_direction_ball_wire,
    btn_up           => btn_up_left_wire,
    btn_down         => btn_down_left_wire
  );
  
  match_controller_I : match_controller
  port map ( 
    clkfx          => clk,
    res_n          => btnCpuReset,
    y_paddle_left  => y_paddle_left_wire,
    y_paddle_right => y_paddle_right_wire,
    x_ball         => x_ball_wire,
    y_ball         => y_ball_wire,
    l_scored       => l_scored_wire,
    r_scored       => r_scored_wire,
    l_paddle_hit   => l_paddle_hit_wire,
    r_paddle_hit   => r_paddle_hit_wire
  );

  GEN_VGA: if HDMI = false generate
    vga_controller_I: vga_controller_c
    port map (
      clk     => clk,
      res_n   => btnCpuReset,
      h_sync  => Hsync,
      v_sync  => Vsync,
      x_coord => x_coord_wire,
      y_coord => y_coord_wire
    );
  end generate GEN_VGA;
  
  image_generator_I: image_generator_c
  port map (
    clk              => clk,
    res_n            => btnCpuReset,
    btn_up_left      => btn_up_left_wire,
    btn_down_left    => btn_down_left_wire,
    btn_up_right     => btn_up_right_wire,
    btn_down_right   => btn_down_right_wire,
    x_coord          => x_coord_wire,
    y_coord          => y_coord_wire,
    enb              => enb_wire,
    l_scored         => l_scored_wire,
    r_scored         => r_scored_wire,
    l_paddle_hit     => l_paddle_hit_wire,
    r_paddle_hit     => r_paddle_hit_wire,
    rgb              => rgb_wire,
    y_paddle_left    => y_paddle_left_wire,
    y_paddle_right   => y_paddle_right_wire,
    x_ball           => x_ball_wire,
    y_ball           => y_ball_wire,
    x_direction_ball => x_direction_ball_wire
  );
  
  color_test : process (clk, btnCpuReset)
  begin
  if (btnCpuReset = '0') then
    enb_wire <= '0';
  elsif rising_edge(clk) then
        enb_wire <= '1';
  end if;
  end process;
  vgaRed   <= rgb_wire(RED);
  vgaBlue  <= rgb_wire(BLUE);
  vgaGreen <= rgb_wire(GREEN);
end Behavioral;
