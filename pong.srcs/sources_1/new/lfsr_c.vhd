----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/24/2016 11:05:28 AM
-- Design Name: 
-- Module Name: lfsr_c - Behavioral
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

entity lfsr_c is
    Generic (NUM_REG :     natural;
             POLY    :     STD_LOGIC_VECTOR); -- MSB and LSB have to be '1'
    Port ( clk       : in  STD_LOGIC;
           res_n     : in  STD_LOGIC;
           d_out     : out STD_LOGIC_VECTOR (NUM_REG - 1 downto 0));
end lfsr_c;

architecture Behavioral of lfsr_c is
  signal q_reg : STD_LOGIC_VECTOR(NUM_REG - 1 downto 0);
begin
  lfsr: process(res_n, clk)
  begin
    if(res_n = '0') then
      q_reg <= (others => '1');
    elsif rising_edge(clk) then
      for i in 0 to (NUM_REG - 1) loop
        if(i = 0) then
          q_reg(0) <= q_reg(NUM_REG - 1);
        else
          if(POLY(i) = '1') then
            q_reg(i) <= q_reg(i - 1) xor q_reg(NUM_REG - 1);
          else
            q_reg(i) <= q_reg(i - 1);
          end if;
        end if;
      end loop;
    end if;
  end process;

  d_out <= q_reg;

end Behavioral;
