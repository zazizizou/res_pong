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
    Port ( clk              : in  STD_LOGIC;
           res_n            : in  STD_LOGIC;
           enb              : in  STD_LOGIC;
           y_paddle_left    : in  y_axis_t;
           x_ball           : in  x_axis_t;
           y_ball           : in  y_axis_t;
           x_direction_ball : in  x_direction_t;
           btn_up           : out STD_LOGIC;
           btn_down         : out STD_LOGIC);
end computer_opponent_c;

architecture Behavioral of computer_opponent_c is

component lfsr_c
  Generic (NUM_REG :     natural;
           POLY    :     STD_LOGIC_VECTOR); -- MSB and LSB have to be '1'
  Port ( clk       : in  STD_LOGIC;
         res_n     : in  STD_LOGIC;
         d_out     : out STD_LOGIC_VECTOR (NUM_REG - 1 downto 0));
end component;

signal lfsr_wire        : STD_LOGIC_VECTOR(LFSR_SIZE - 1 downto 0);
signal enb_paddle       : STD_LOGIC;
signal lfsr_valid       : STD_LOGIC;
signal lfsr_value       : STD_LOGIC_VECTOR(LFSR_SIZE - 1 downto 0);
signal ball_direction_x : x_direction_t;

begin

  lfsr_I: lfsr_c
    generic map (NUM_REG => LFSR_SIZE,
                 POLY    => LFSR_POLY) -- MSB and LSB have to be '1'
    port map (   clk     => clk,
                 res_n   => res_n,
                 d_out   => lfsr_wire
    );
    
  read: process(res_n, clk)
  begin
    if(res_n = '0') then
      lfsr_valid  <= '0';
    elsif rising_edge(clk) then
      if (enb = '1') then
        if (x_direction_ball = LEFT) then
          if (lfsr_valid = '0') then
            lfsr_value <= lfsr_wire;
            lfsr_valid  <= '1';
          end if;
        else
          lfsr_valid <= '0';
        end if;
      else
        lfsr_valid <= '0';
      end if;
    end if;
  end process;
  
  enb_p: process(res_n, clk)
  begin
    if(res_n = '0') then
      enb_paddle <= '0';
    elsif rising_edge(clk) then
      if (enb = '1') then
        if (x_direction_ball = LEFT) and (lfsr_valid = '1') then
          if (to_integer(unsigned(x_ball)) < (to_integer(unsigned(lfsr_value)) + X_POS_OFFSET)) then
            enb_paddle <= '1';
          else
            enb_paddle <= '0';
          end if;
        else
          enb_paddle <= '0';
        end if;
      else
        enb_paddle <= '0';
      end if;
    end if;
  end process;

  btn: process(res_n, clk)
  begin
    if(res_n = '0') then
      btn_up   <= '0';
      btn_down <= '0';
    elsif rising_edge(clk) then
      if (enb_paddle = '1') and (enb = '1') then
        if (to_integer(unsigned(y_ball)) + (BALL_SIZE / 2)) > (to_integer(unsigned(y_paddle_left)) + (PADDLE_HIGHT / 2)) then
          btn_up   <= '0';
          btn_down <= '1';
        elsif (to_integer(unsigned(y_ball)) + (BALL_SIZE / 2)) < (to_integer(unsigned(y_paddle_left)) + (PADDLE_HIGHT / 2)) then
          btn_up   <= '1';
          btn_down <= '0';      
        else
          btn_up   <= '0';
          btn_down <= '0';  
        end if;
      else
        btn_up   <= '0';
        btn_down <= '0';
      end if;
    end if;
  end process;

end Behavioral;
