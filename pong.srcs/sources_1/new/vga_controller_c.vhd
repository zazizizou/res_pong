----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2016 04:01:35 PM
-- Design Name: 
-- Module Name: vga_controller_c - Behavioral
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

entity vga_controller_c is
  Port (clk     : in  STD_LOGIC;
        res_n   : in  STD_LOGIC;
        h_sync  : out STD_LOGIC;
        v_sync  : out STD_LOGIC;
        x_coord : out STD_LOGIC_VECTOR(9 downto 0);
        y_coord : out STD_LOGIC_VECTOR(8 downto 0));
end vga_controller_c;

architecture Behavioral of vga_controller_c is
  component clock_divider_c
    generic (CLK_IN_SPEED, CLK_OUT_SPEED : integer);
    port (clk_in : in  STD_LOGIC;
         res_n   : in  STD_LOGIC;
         clk_out : out STD_LOGIC);
  end component;
  
  component h_sync_c
    port (clk        : in  STD_LOGIC;
          res_n      : in  STD_LOGIC;
          h_sync     : out STD_LOGIC;
          v_sync_enb : out STD_LOGIC;
          h_count    : out STD_LOGIC_VECTOR (9 downto 0));
  end component;
  
  component v_sync_c
    port ( clk     : in  STD_LOGIC;
           res_n   : in  STD_LOGIC;
           enb     : in  STD_LOGIC;
           v_sync  : out STD_LOGIC;
           v_count : out STD_LOGIC_VECTOR (9 downto 0));
  end component;
  
  signal clk_wire         : STD_LOGIC;
  signal res_n_wire       : STD_LOGIC;
  signal h_sync_wire      : STD_LOGIC;
  signal v_sync_wire      : STD_LOGIC;
  signal v_sync_enb_wire  : STD_LOGIC;
  signal h_count_wire     : STD_LOGIC_VECTOR (9 downto 0);
  signal v_count_wire     : STD_LOGIC_VECTOR (9 downto 0);
begin
  clock_divider_I: clock_divider_c 
  generic map (CLK_IN_SPEED => 4, CLK_OUT_SPEED => 1)
  port map (
    clk_in  => clk, 
    res_n   => res_n_wire,
    clk_out => clk_wire
  );
  h_sync_I: h_sync_c
  port map (
    clk        => clk_wire,
    res_n      => res_n_wire,
    h_sync     => h_sync_wire,
    v_sync_enb => v_sync_enb_wire,
    h_count    => h_count_wire 
  );
  v_sync_I: v_sync_c
  port map (
    clk     => clk_wire,
    res_n   => res_n_wire,
    enb     => v_sync_enb_wire,
    v_sync  => v_sync_wire,
    v_count => v_count_wire
  );
  res_n_wire <= res_n;
  h_sync <= h_sync_wire;
  v_sync <= v_sync_wire;
  x_coord <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(h_count_wire)) - 144, x_coord'length));
  y_coord <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(v_count_wire)) - 35, y_coord'length));
end Behavioral;