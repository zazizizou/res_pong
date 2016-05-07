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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_c is
  Port (clk         : in  STD_LOGIC;
        btnCpuReset : in  STD_LOGIC;
        Hsync       : out STD_LOGIC;
        Vsync       : out STD_LOGIC;
        vgaRed      : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue     : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen    : out STD_LOGIC_VECTOR(3 downto 0));
end top_c;

architecture Behavioral of top_c is
  component vga_controller_c
  port (clk     : in  STD_LOGIC;
        res_n   : in  STD_LOGIC;
        h_sync  : out STD_LOGIC;
        v_sync  : out STD_LOGIC;
        h_count : out STD_LOGIC_VECTOR(9 downto 0);
        v_count : out STD_LOGIC_VECTOR(9 downto 0));
  end component;
  
  signal h_count_wire : STD_LOGIC_VECTOR (9 downto 0);
  signal v_count_wire : STD_LOGIC_VECTOR (9 downto 0);
begin

  vga_controller_I: vga_controller_c
  port map (
    clk => clk,
    res_n => btnCpuReset,
    h_sync => Hsync,
    v_sync => Vsync,
    h_count => h_count_wire,
    v_count => v_count_wire
  );
  
  color_test : process (clk, btnCpuReset)
  begin
  if (btnCpuReset = '0') then
    vgaRed   <= "0000";
    vgaBlue  <= "0000";
    vgaGreen <= "0000";
  elsif rising_edge(clk) then
    if ((to_integer(unsigned(h_count_wire)) >= 144) and (to_integer(unsigned(h_count_wire)) < 784) and (to_integer(unsigned(v_count_wire)) >= 35) and (to_integer(unsigned(v_count_wire)) < 515)) then
      vgaRed   <= "1111";
      vgaBlue  <= "0011";
      vgaGreen <= "0011";
    else
      vgaRed   <= "0000";
      vgaBlue  <= "0000";
      vgaGreen <= "0000";
    end if;
  end if;
  end process;
  
end Behavioral;
