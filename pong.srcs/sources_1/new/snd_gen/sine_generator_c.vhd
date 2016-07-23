library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sine_generator_c is
    Generic (MAX_COUNT : natural :=1000);
    Port ( clk : in  STD_LOGIC;
           res_n : in  STD_LOGIC;
           sine_out : out  std_logic_vector(17 downto 0));
end sine_generator_c;

architecture Behavioral of sine_generator_c is

signal counter : natural;
signal t : integer range 0 to 30 := 0;
type memory_type is array (0 to 29) of integer range -128 to 127;

-- ROM with precalculated sine values.
signal sine : memory_type :=(0,16,31,45,58,67,74,77,77,74,67,58,45,31,16,0,
-16,-31,-45,-58,-67,-74,-77,-77,-74,-67,-58,-45,-31,-16);

begin

-- clk divider to get the right frequency
process(clk, res_n)
begin
	if(res_n = '0') then
		counter <= 0;
	elsif rising_edge(clk) then
		if counter = MAX_COUNT then
			sine_out <= std_logic_vector(to_signed(sine(t), sine_out'length));
			t <= t+1;
			if t = 29 then
				t <= 0;
			end if;
			counter <= 0;
		else 
			counter <= counter + 1;
		end if;
	end if;
end process;


end Behavioral;
