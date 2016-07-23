--/////////////// STATE MACHINE TO CONFIGURE THE AC97 ///////////////////////////--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- one can add extra inputs and signals to control the input to LM4550 (ac97) 
-- register map below see volume and source for example
entity ac97cmd is
	port (
		 clk      		: in  std_logic;
		 ac97_ready_sig : in  std_logic;
		 cmd_addr 		: out std_logic_vector(7 downto 0);
		 cmd_data 		: out std_logic_vector(15 downto 0);
		 latching_cmd	: out std_logic;
		 volume   		: in  std_logic_vector(4 downto 0);  -- input for encoder for volume control 0->31
		 source   		: in  std_logic_vector(2 downto 0)); -- 000=Mic, 100=LineIn
end ac97cmd;


architecture arch of ac97cmd is
	signal cmd		: std_logic_vector(23 downto 0);  
	signal atten	: std_logic_vector(4 downto 0);							-- used to set atn in 04h ML4:0/MR4:0
	type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
	signal cur_state, next_state : state_type;
begin
																			-- parse command from data
   cmd_addr <= cmd(23 downto 16);
   cmd_data <= cmd(15 downto 0);
   atten    <= std_logic_vector(31 - unsigned(volume));      				-- convert vol to attenuation

	-- USED TO DETERMINE IF THE REGISTER ADDRESS IS VALID 
	-- one can add more with select statments with output signals to do more error checking
	---------------------------------------------------------------------------------------------
	with cmd(23 downto 16) select
		latching_cmd <=
			'1' when X"02" | X"04" | X"06" | X"0A" | X"0C" | X"0E" | X"10" | X"12" | X"14" | 
					 X"16" | X"18" | X"1A" | X"1C" | X"20" | X"22" | X"24" | X"26" | X"28" | 
					 X"2A" | X"2C" | X"32" | X"5A" | X"74" | X"7A" | X"7C" | X"7E" | X"80",
			'0' when others;
			
	
	-- go through states based on input pulses from ac97 ready signal
	------------------------------------------------------------------------------------------
	process(clk, next_state, cur_state)
		begin
																
		if(rising_edge(clk)) then
			if ac97_ready_sig = '1' then
				cur_state <= next_state;
			end if;
		end if;
	end process;
	
		
	-- use state machine to configure controller
	-- states and input signals can be added for real time configuration of 
	-- any ac97 register
	-------------------------------------------------------------------------------------------
	process (next_state, cur_state, atten, source)
	begin

		case cur_state is
			when S0 =>
				cmd <= X"02_8000";  -- master volume	0 0000->0dB atten, 1 1111->46.5dB atten								
				next_state <= S2;
			when S1 => 
				cmd <= X"04" & "000" & atten & "000" & atten;	-- headphone volume
				next_state <= S4;
			when S2 => 
				cmd <= X"0A_0000";  							-- Set pc_beep volume
				next_state <= S11;
			when S3 => 
				cmd <= X"0E_8048";  							-- Mic Volume set to gain of +20db
				next_state <= S10;
			when S4 => 
				cmd <= X"18_0808";  							-- PCM volume
				next_state <= S6;
			when S5 =>
				cmd <= X"1A" & "00000" & source & "00000" & source; -- Record select reg 000->Mic, 001->CD in l/r, 010->Video in l/r, 011->aux in l/r
				next_state <= S7;		-- 100->line_in l/r, 101->stereo mix, 110->mono mix, 111->phone input
			when S6 =>
				cmd <= X"1C_0F0F";  	-- Record gain set to max (22.5dB gain)
				next_state <= S8;	
			when S7 =>
				cmd <= X"20_8000";  	-- PCM out path 3D audio bypassed
				next_state <= S0;
			when S8 => 
				cmd <= X"2C_BB80";   	-- DAC rate 48 KHz,	can be set to 1F40 = 8Khz, 2B11 = 11.025KHz, 3E80 = 16KHz,											 
				next_state <= S5;		-- 5622 = 22.05KHz, AC44 = 44.1KHz, BB80 = 48KHz
			when S9 =>
				cmd <= X"32_BB80";  	-- ADC rate 48 KHz,	can be set to 1F40 = 8Khz, 2B11 = 11.025KHz, 3E80 = 16KHz,									 
				next_state <= S3;		-- 5622 = 22.05KHz, AC44 = 44.1KHz, BB80 = 48KHz	
			when S10 =>
				cmd <= X"80_0000";  							  					
				next_state <= S9;
			when S11 =>
				cmd <= X"80_0000";  												
				next_state <= S1;
			end case;
	 
  end process;

end arch;
