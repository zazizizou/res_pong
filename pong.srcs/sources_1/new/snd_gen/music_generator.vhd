library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity music_generator is
    Port ( 	clk : in STD_LOGIC;
				res_n : in STD_LOGIC;
				l_paddle_hit_pulse: in STD_LOGIC;
				r_paddle_hit_pulse: in STD_LOGIC;
				l_scored_pulse : in STD_LOGIC;
				r_scored_pulse : in STD_LOGIC;
				sound_effect_r : out STD_LOGIC_VECTOR(17 downto 0);
				sound_effect_l : out STD_LOGIC_VECTOR(17 downto 0)
			  );
end music_generator;

architecture Behavioral of music_generator is

component sine_generator_c
	Generic (MAX_COUNT : natural :=1000);
    Port ( clk : in  STD_LOGIC;
           res_n : in  STD_LOGIC;
           sine_out : out  std_logic_vector(17 downto 0));
end component;

signal counter : std_logic_vector(28 downto 0) := (others => '0'); 
signal music_l_paddle_hit_A : std_logic_vector(17 downto 0);
signal music_l_paddle_hit_C : std_logic_vector(17 downto 0);
signal enb_music_l_paddle_hit : std_logic := '0';
signal enb_l_scored_pulse : std_logic := '0';


begin

	ton_A : sine_generator_c
		generic map (MAX_COUNT => 2000) -- 440 Hz
		port map (clk => clk,
					res_n => res_n,
					sine_out => music_l_paddle_hit_A);
					
	ton_C : sine_generator_c
		generic map (MAX_COUNT => 4000) -- 260 Hz
		port map (clk => clk,
					res_n => res_n,
					sine_out => music_l_paddle_hit_C);
	
	
	enable_proc: process(counter, l_paddle_hit_pulse, r_paddle_hit_pulse, l_scored_pulse, r_scored_pulse)
	begin
		if(rising_edge(l_paddle_hit_pulse)) then
			enb_music_l_paddle_hit <= '1';
		else
			enb_music_l_paddle_hit <= enb_music_l_paddle_hit;
		end if;
		if counter >= "101111101011110000100000000" then
				enb_music_l_paddle_hit <= '0';
		end if;
		
		if(rising_edge(l_scored_pulse)) then
			enb_l_scored_pulse <= '1';
		else
			enb_l_scored_pulse <= enb_l_scored_pulse;
		end if;
		if counter >= "101111101011110000100000000" then
				enb_l_scored_pulse <= '0';
		end if;
	end process;
	
	
	music_left_paddle_hit_proc: process (clk, res_n)
	begin
		if(res_n = '0') then
			sound_effect_l <= (others => '0');
			sound_effect_r <= (others => '0');
		elsif (rising_edge(clk)) then -- every 10 ns
			if enb_music_l_paddle_hit = '1' then
				if counter <= "10111110101111000010000000" then -- counts to 0.5 sec
					sound_effect_l <= music_l_paddle_hit_A; 
					counter <= counter + 1;
				elsif counter >= "10111110101111000010000000" then
					sound_effect_l <= music_l_paddle_hit_C;
				elsif counter = "101111101011110000100000000" then -- counts to 1 sec
					counter <= (others => '0');
				end if;
			end if;
			
			if enb_l_scored_pulse = '1' then
				if counter <= "10111110101111000010000000" then -- counts to 0.5 sec
					sound_effect_l <= music_l_paddle_hit_A; 
					sound_effect_r <= music_l_paddle_hit_A;
					counter <= counter + 1;
				elsif counter >= "10111110101111000010000000" then
					sound_effect_l <= music_l_paddle_hit_C;
					sound_effect_r <= music_l_paddle_hit_C;
				elsif counter = "101111101011110000100000000" then -- counts to 1 sec
					counter <= (others => '0');
				end if;
			end if;
		end if;
	end process;


end Behavioral;

