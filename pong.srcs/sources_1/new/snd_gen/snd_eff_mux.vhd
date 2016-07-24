library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity snd_eff_mux is
    Port ( res_n : in STD_LOGIC;
	        source_sel : in  STD_LOGIC_VECTOR (3 downto 0); -- one hot
           snd_eff_l_paddle_hit : in  STD_LOGIC_VECTOR (17 downto 0);
           snd_eff_r_paddle_hit : in  STD_LOGIC_VECTOR (17 downto 0);
			  snd_eff_r_scored : in  STD_LOGIC_VECTOR (17 downto 0);
			  snd_eff_l_scored : in  STD_LOGIC_VECTOR (17 downto 0);
			  snd_eff_r_out : out  STD_LOGIC_VECTOR (17 downto 0);
			  snd_eff_l_out : out  STD_LOGIC_VECTOR (17 downto 0)
			  );
end snd_eff_mux;

architecture Behavioral of snd_eff_mux is

begin
mux4_2: process(res_n, source_sel)
begin
	if(res_n = '0') then
		snd_eff_r_out <= (others => '0');
		snd_eff_l_out <= (others => '0');
	elsif(source_sel = "0001") then -- r_paddle_hit
		snd_eff_r_out <= snd_eff_r_paddle_hit;
		snd_eff_l_out <= (others => '0');
	elsif(source_sel = "0010") then -- l_paddle_hit
		snd_eff_r_out <= (others => '0');
		snd_eff_l_out <= snd_eff_l_paddle_hit;
	elsif(source_sel = "0100") then -- r_scored
		snd_eff_r_out <= snd_eff_r_scored;
		snd_eff_l_out <= snd_eff_r_scored;
	elsif(source_sel = "1000") then -- l_scored
		snd_eff_r_out <= snd_eff_l_scored;
		snd_eff_l_out <= snd_eff_l_scored;
	end if;
end process;

end Behavioral;

