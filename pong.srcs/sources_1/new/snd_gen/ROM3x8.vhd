library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM3x8 is
    Port ( addr : in  STD_LOGIC_VECTOR (2 downto 0);
           q : out  STD_LOGIC_VECTOR (7 downto 0);
			  clk : in STD_LOGIC;
			  res_n : in STD_LOGIC
			  );
end ROM3x8;

architecture Behavioral of ROM3x8 is

begin

process(clk, res_n)
begin
	if (res_n = '0') then
	q <= "00000000";
	end if;
end process;

process(addr)
begin
	case addr is 
		when "000" => q <= "00000001";
		when "001" => q <= "00000010";
		when "010" => q <= "00000100";
		when others => q <= "00000000";
	end case;
end process;

end Behavioral;

