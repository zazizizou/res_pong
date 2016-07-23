----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2016 03:53:32 PM
-- Design Name: 
-- Module Name: score_c - Behavioral
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

entity score_c is
    Port ( clk      : in  STD_LOGIC;
           res_n    : in  STD_LOGIC;
           enb      : in  STD_LOGIC;
           l_scored : in  STD_LOGIC;
           r_scored : in  STD_LOGIC;
           x_coord  : in  x_axis_t;
           y_coord  : in  y_axis_t;
           sel      : out STD_LOGIC;
           rgb      : out color_t);
end score_c;

architecture Behavioral of score_c is

component bcd_2_7seg_c
    Port ( 
      bcd       : in  STD_LOGIC_VECTOR (3 downto 0);
      seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component seven_seg_c
    generic (X_POS, Y_POS: natural);
    Port ( clk       : in  STD_LOGIC;
           res_n     : in  STD_LOGIC;
           enb       : in  STD_LOGIC;
           seven_seg : in  STD_LOGIC_VECTOR (6 downto 0);
           x_coord   : in  x_axis_t;
           y_coord   : in  y_axis_t;
           sel       : out STD_LOGIC);
end component;

-- score counters in bcd
signal l_score_bcd    : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal r_score_bcd    : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal l_score_7seg_0 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
signal l_score_7seg_1 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
signal r_score_7seg_0 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
signal r_score_7seg_1 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
signal sel_l0         : STD_LOGIC                    := '0';
signal sel_l1         : STD_LOGIC                    := '0';
signal sel_r0         : STD_LOGIC                    := '0';                                                            
signal sel_r1         : STD_LOGIC                    := '0';

begin

  bcd_2_7seg_l0_I: bcd_2_7seg_c
    port map ( 
      bcd       => l_score_bcd(3 downto 0),
      seven_seg => l_score_7seg_0
    );
    
  bcd_2_7seg_l1_I: bcd_2_7seg_c
    port map ( 
      bcd       => l_score_bcd(7 downto 4),
      seven_seg => l_score_7seg_1
    );  
        
  bcd_2_7seg_r0_I: bcd_2_7seg_c
    port map ( 
      bcd       => r_score_bcd(3 downto 0),
      seven_seg => r_score_7seg_0
    );
            
  bcd_2_7seg_r1_I: bcd_2_7seg_c
    port map ( 
      bcd       => r_score_bcd(7 downto 4),
      seven_seg => r_score_7seg_1
    );
    
  seven_seg_l0_I: seven_seg_c
    generic map(X_POS => SCORE_POS_X_L0, Y_POS => SCORE_POS_Y)
    port map( 
      clk       => clk,
      res_n     => res_n,
      enb       => enb,
      seven_seg => l_score_7seg_0,
      x_coord   => x_coord,
      y_coord   => y_coord,
      sel       => sel_l0
    );
        
  seven_seg_l1_I: seven_seg_c
    generic map(X_POS => SCORE_POS_X_L1, Y_POS => SCORE_POS_Y)
    port map( 
      clk       => clk,
      res_n     => res_n,
      enb       => enb,
      seven_seg => l_score_7seg_1,
      x_coord   => x_coord,
      y_coord   => y_coord,
      sel       => sel_l1
    );
            
  seven_seg_r0_I: seven_seg_c
    generic map(X_POS => SCORE_POS_X_R0, Y_POS => SCORE_POS_Y)
    port map( 
      clk       => clk,
      res_n     => res_n,
      enb       => enb,
      seven_seg => r_score_7seg_0,
      x_coord   => x_coord,
      y_coord   => y_coord,
      sel       => sel_r0
    );
    
  seven_seg_r1_I: seven_seg_c
    generic map(X_POS => SCORE_POS_X_R1, Y_POS => SCORE_POS_Y)
    port map( 
      clk       => clk,
      res_n     => res_n,
      enb       => enb,
      seven_seg => r_score_7seg_1,
      x_coord   => x_coord,
      y_coord   => y_coord,
      sel       => sel_r1
    );

  count_score: process (res_n, clk)
  begin
    if(res_n = '0') then
      l_score_bcd <= "00000000";
      r_score_bcd <= "00000000";
    elsif rising_edge(clk) then
      if(l_scored = '1') then
        if(l_score_bcd(3 downto 0) = "1001") then
          l_score_bcd(7 downto 4) <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(l_score_bcd(7 downto 4))) + 1, l_score_bcd(7 downto 4)'length));
          l_score_bcd(3 downto 0) <= "0000";
        else
          l_score_bcd <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(l_score_bcd)) + 1, l_score_bcd'length));
        end if;
      end if;
      if(r_scored = '1') then
        if(r_score_bcd(3 downto 0) = "1001") then
        r_score_bcd(7 downto 4) <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(r_score_bcd(7 downto 4))) + 1, r_score_bcd(7 downto 4)'length));
        r_score_bcd(3 downto 0) <= "0000";
      else
        r_score_bcd <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(r_score_bcd)) + 1, r_score_bcd'length));
      end if;
      end if;
    end if;
  end process;
  
  sel <= sel_l0 or sel_l1 or sel_r0 or sel_r1;
  rgb <= WHITE;

end Behavioral;
