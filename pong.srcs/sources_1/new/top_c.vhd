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

  component image_generator_c
    Port ( clk           : in  STD_LOGIC;
           res_n         : in  STD_LOGIC;
           btn_up        : in  STD_LOGIC;
           btn_down      : in  STD_LOGIC;
           x_coord       : in  STD_LOGIC_VECTOR (9 downto 0);
           y_coord       : in  STD_LOGIC_VECTOR (8 downto 0);
           enb           : in  STD_LOGIC;
           l_scored      : in  STD_LOGIC;
           r_scored      : in  STD_LOGIC;
           l_panel_hit   : in  STD_LOGIC;
           r_panel_hit   : in  STD_LOGIC;
           rgb           : out color_t;
           y_panel_left  : out STD_LOGIC_VECTOR (8 downto 0);
           y_panel_right : out STD_LOGIC_VECTOR (8 downto 0);
           x_ball        : out STD_LOGIC_VECTOR (9 downto 0);
           y_ball        : out STD_LOGIC_VECTOR (8 downto 0));
  end component;

  component vga_controller_c
  port (clk     : in  STD_LOGIC;
        res_n   : in  STD_LOGIC;
        h_sync  : out STD_LOGIC;
        v_sync  : out STD_LOGIC;
        x_coord : out STD_LOGIC_VECTOR(9 downto 0);
        y_coord : out STD_LOGIC_VECTOR(8 downto 0));
  end component;
  
  signal x_coord_wire      : STD_LOGIC_VECTOR (9 downto 0);
  signal y_coord_wire      : STD_LOGIC_VECTOR (8 downto 0);
  signal rgb_wire          : color_t;
  signal btn_up_deb_wire   : STD_LOGIC;
  signal btn_down_deb_wire : STD_LOGIC;
  signal enb_wire          : STD_LOGIC;
begin

  btn_up_debouncer_I : debouncer_c
  port map (
    clk     => clk,
    res_n   => btnCpuReset,
    btn     => btnU,
    deb_btn => btn_up_deb_wire
  );
  
  btn_down_debouncer_I : debouncer_c
  port map (
    clk     => clk,
    res_n   => btnCpuReset,
    btn     => btnD,
    deb_btn => btn_down_deb_wire
  );
  
  GEN_HDMI: if HDMI = true generate
  
  end generate GEN_HDMI;

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
    clk           => clk,
    res_n         => btnCpuReset,
    btn_up        => btn_up_deb_wire,
    btn_down      => btn_down_deb_wire,
    x_coord       => x_coord_wire,
    y_coord       => y_coord_wire,
    enb           => enb_wire,
    l_scored      => '0',
    r_scored      => '0',
    l_panel_hit   => '0',
    r_panel_hit   => '0',
    rgb           => rgb_wire,
    y_panel_left  => open,
    y_panel_right => open,
    x_ball        => open,
    y_ball        => open
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
