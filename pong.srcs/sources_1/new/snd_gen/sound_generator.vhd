library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sound_generator_c is
    Port ( clk : in  STD_LOGIC;
           n_reset : in  STD_LOGIC;
			  SDATA_IN : in STD_LOGIC;	
			  BIT_CLK : in STD_LOGIC;
			  SOURCE : in STD_LOGIC_VECTOR(3 downto 0);
			  VOLUME : in STD_LOGIC_VECTOR(4 downto 0);
			  SYNC : out STD_LOGIC;
			  SDATA_OUT : out STD_LOGIC;
			  AC97_n_RESET : out STD_LOGIC
			  );
end sound_generator_c;


	architecture arch of sound_generator_c is

	signal L_bus, R_bus, R_bus_out, Sine_bus_out : std_logic_vector(17 downto 0);	
	signal cmd_addr : std_logic_vector(7 downto 0);
	signal cmd_data : std_logic_vector(15 downto 0);
	signal ready : std_logic;
	signal latching_cmd : std_logic;



	component ac97
	port(	n_reset        : in  std_logic;
			clk            : in  std_logic;
			ac97_sdata_out : out std_logic;						
			ac97_sdata_in  : in  std_logic;						
			ac97_sync      : out std_logic;						
			ac97_bitclk    : in  std_logic;						
			ac97_n_reset   : out std_logic;						
			ac97_ready_sig : out std_logic; 						
			L_out          : in  std_logic_vector(17 downto 0);
			R_out          : in  std_logic_vector(17 downto 0);
			L_in           : out std_logic_vector(17 downto 0);
			R_in           : out std_logic_vector(17 downto 0);
			latching_cmd   : in  std_logic;
			cmd_addr       : in  std_logic_vector(7 downto 0);	
			cmd_data       : in  std_logic_vector(15 downto 0)
			);
	end component;
	
	
	component ac97cmd
	Port (clk				: in std_logic;
			ac97_ready_sig : in std_logic;
			cmd_addr 		: out std_logic_vector(7 downto 0);
			cmd_data 		: out std_logic_vector(15 downto 0);
			latching_cmd	: out std_logic;
			volume   		: in  std_logic_vector(4 downto 0) 
			--source   		: in  std_logic_vector(2 downto 0)
			);
	end component;
	
	component sine_generator_c
	Port ( clk : in  STD_LOGIC;
           res_n : in  STD_LOGIC;
           sine_out : out  STD_LOGIC_VECTOR (17 downto 0));
	end component;
	
	component music_generator
	Port ( 	clk : in STD_LOGIC;
				res_n : in STD_LOGIC;
				l_paddle_hit_pulse: in STD_LOGIC;
				r_paddle_hit_pulse: in STD_LOGIC;
				l_scored_pulse : in STD_LOGIC;
				r_scored_pulse : in STD_LOGIC;
				sound_effect_r : out STD_LOGIC_VECTOR(17 downto 0);
				sound_effect_l : out STD_LOGIC_VECTOR(17 downto 0)
			  );
	end component;
	
begin
	
	
	ac97_cont0 : ac97
		port map(n_reset => n_reset, 
					clk => clk, 
					ac97_sdata_out => SDATA_OUT, 
					ac97_sdata_in => SDATA_IN, -- wird noch entfernt
					latching_cmd => latching_cmd,
					ac97_sync => SYNC, 
					ac97_bitclk => BIT_CLK, 
					ac97_n_reset => AC97_n_RESET, 
					ac97_ready_sig => ready,
					L_out => L_bus, 
					R_out => R_bus, 
					L_in => R_bus_out, -- wird noch entfernt
					R_in => R_bus_out, -- wird noch entfernt
					cmd_addr => cmd_addr, 
					cmd_data => cmd_data);
 

    ac97cmd_cont0 : ac97cmd
	   port map (clk => clk, 
					ac97_ready_sig => ready, 
					cmd_addr => cmd_addr, 
					cmd_data => cmd_data, 
					volume => VOLUME, 
					--source => SOURCE, 
					latching_cmd => latching_cmd);  
			

	sin : sine_generator_c
			Port map( clk => clk,
						res_n => n_reset,
						sine_out => sine_bus_out);
		
	music_gen : music_generator
			port map( 	clk => clk,
				res_n => n_reset,
				l_paddle_hit_pulse => source(0),
				r_paddle_hit_pulse => source(1),
				l_scored_pulse => source(2),
				r_scored_pulse => source(3),
				sound_effect_r => R_bus,
				sound_effect_l => L_bus
			  ); 
		


	-- Latch output back into input for Talkthrough testing

--	process ( clk, n_reset, L_bus_out, R_bus_out)
--  
--	begin		
--		if (rising_edge(clk)) then
--			if n_reset = '0' then
--				L_bus <= (others => '0');
--				R_bus <= (others => '0');
--			elsif(ready = '1') then
--				L_bus <= L_bus_out;
--				R_bus <= R_bus_out;
--			end if;
--		end if;
--	end process;
--	

end arch;
