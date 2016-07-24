----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2016 09:33:04 PM
-- Design Name: 
-- Module Name: seven_seg_c - Behavioral
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

entity seven_seg_c is
    generic (X_POS, Y_POS: natural);
    Port ( clk       : in  STD_LOGIC;
           res_n     : in  STD_LOGIC;
           enb       : in  STD_LOGIC;
           seven_seg : in  STD_LOGIC_VECTOR (6 downto 0);
           x_coord   : in  x_axis_t;
           y_coord   : in  y_axis_t;
           sel       : out STD_LOGIC);
end seven_seg_c;

architecture Behavioral of seven_seg_c is
signal sel_a : STD_LOGIC;
signal sel_b : STD_LOGIC;
signal sel_c : STD_LOGIC;
signal sel_d : STD_LOGIC;
signal sel_e : STD_LOGIC;
signal sel_f : STD_LOGIC;
signal sel_g : STD_LOGIC;

begin
  rgb_p : process(res_n, clk)
  begin
    if(res_n = '0') then
      sel <= '0';
    elsif rising_edge(clk) then
      if(enb = '1') then
        sel <= sel_a or sel_b or sel_c or sel_d or sel_e or sel_f or sel_g;
      end if;
    end if;
  end process;
  
  seg_a : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_HIGHT)
        and (to_integer(unsigned(y_coord)) >= Y_POS) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + SCORE_BAR_WIDTH)
        and (seven_seg(6) = '1')) then
      sel_a <= '1';
    else
      sel_a <= '0';
    end if;
  end process;
  
  seg_b : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS + SCORE_BAR_HIGHT - SCORE_BAR_WIDTH) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_HIGHT)
        and (to_integer(unsigned(y_coord)) >= Y_POS) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + SCORE_BAR_HIGHT)
        and (seven_seg(5) = '1')) then
      sel_b <= '1';
    else
      sel_b <= '0';
    end if;
  end process;
  
  seg_c : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS + SCORE_BAR_HIGHT - SCORE_BAR_WIDTH) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_HIGHT)
        and (to_integer(unsigned(y_coord)) >= Y_POS + SCORE_BAR_HIGHT - SCORE_BAR_WIDTH) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + (2 * SCORE_BAR_HIGHT) - SCORE_BAR_WIDTH)
        and (seven_seg(4) = '1')) then
      sel_c <= '1';
    else
      sel_c <= '0';
    end if;
  end process;
  
  seg_d : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_HIGHT)
        and (to_integer(unsigned(y_coord)) >= Y_POS + (2 * SCORE_BAR_HIGHT) - (2* SCORE_BAR_WIDTH)) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + (2 * SCORE_BAR_HIGHT) - SCORE_BAR_WIDTH)
        and (seven_seg(3) = '1')) then
      sel_d <= '1';
    else
      sel_d <= '0';
    end if;
  end process;
  
  seg_e : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_WIDTH)
        and (to_integer(unsigned(y_coord)) >= Y_POS + SCORE_BAR_HIGHT - SCORE_BAR_WIDTH) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + (2 * SCORE_BAR_HIGHT) - SCORE_BAR_WIDTH)
        and (seven_seg(2) = '1')) then
      sel_e <= '1';
    else
      sel_e <= '0';
    end if;
  end process;
  
  seg_f : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_WIDTH)
        and (to_integer(unsigned(y_coord)) >= Y_POS) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + SCORE_BAR_HIGHT)
        and (seven_seg(1) = '1')) then
      sel_f <= '1';
    else
      sel_f <= '0';
    end if;
  end process;
  
  seg_g : process(seven_seg, x_coord, y_coord)
  begin
    if (    (to_integer(unsigned(x_coord)) >= X_POS) 
        and (to_integer(unsigned(x_coord)) <  X_POS + SCORE_BAR_HIGHT)
        and (to_integer(unsigned(y_coord)) >= Y_POS + SCORE_BAR_HIGHT - SCORE_BAR_WIDTH) 
        and (to_integer(unsigned(y_coord)) <  Y_POS + SCORE_BAR_HIGHT)
        and (seven_seg(0) = '1')) then
      sel_g <= '1';
    else
      sel_g <= '0';
    end if;
  end process;
  
end Behavioral;
