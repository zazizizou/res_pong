library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

--/////////////////////// AC97 CONTROLLER //////////////////////////////////--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ac97 is
	port (
		n_reset        : in  std_logic;
		clk            : in  std_logic;
																		-- ac97 interface signals
		ac97_sdata_out : out std_logic;						-- ac97 output to SDATA_IN
		ac97_sdata_in  : in  std_logic;						-- ac97 input from SDATA_OUT
		ac97_sync      : out std_logic;						-- SYNC signal to ac97
		ac97_bitclk    : in  std_logic;						-- 12.288 MHz clock from ac97
		ac97_n_reset   : out std_logic;						-- ac97 reset for initialization [active low]
		ac97_ready_sig : out std_logic; 						-- pulse for one cycle
		L_out          : in  std_logic_vector(17 downto 0);	-- lt chan output from ADC
		R_out          : in  std_logic_vector(17 downto 0);	-- rt chan output from ADC
		L_in           : out std_logic_vector(17 downto 0);	-- lt chan input to DAC
		R_in           : out std_logic_vector(17 downto 0);	-- rt chan input to DAC
		latching_cmd   : in  std_logic;
		cmd_addr       : in  std_logic_vector(7 downto 0);	-- cmd address coming in from ac97cmd state machine
		cmd_data       : in  std_logic_vector(15 downto 0));-- cmd data coming in from ac97cmd state machine
end ac97;


architecture arch of ac97 is


	signal Q1, Q2   		: std_logic;					-- signals to deliver one cycle pulse at specified time
	signal bit_count    	: std_logic_vector(7 downto 0);	-- counter for aligning slots
	signal rst_counter  	: integer range 0 to 4097;		-- counter to set ac97_reset high for ac97 init
								
	signal latch_cmd_addr   : std_logic_vector(19 downto 0);-- signals to latch in registers and commands
	signal latch_cmd_data   : std_logic_vector(19 downto 0);

	signal latch_left_data	: std_logic_vector(19 downto 0);
	signal latch_right_data : std_logic_vector(19 downto 0);

	signal left_data     	: std_logic_vector(19 downto 0);
	signal right_data    	: std_logic_vector(19 downto 0);
	signal left_in_data  	: std_logic_vector(19 downto 0);
	signal right_in_data 	: std_logic_vector(19 downto 0);
	
begin
	

	-- concat for 18 bit usage can concat further for 16 bit use 
	-- by using <& "0000"> and <left_in_data(19 downto 4)>
	-------------------------------------------------------------------------------------
	left_data  <= L_out & "00";
	right_data <= R_out & "00";

	L_in <= left_in_data(19 downto 2);
	R_in <= right_in_data(19 downto 2);
	

	-- Delay for ac97_reset signal, clk = 100MHz
	-- delay 10ns * 37.89 us for active low reset on init
	--------------------------------------------------------------------------------------
	process (clk, n_reset)
	begin
		if (rising_edge(clk)) then
			if n_reset = '0' then
				rst_counter <= 0;
				ac97_n_reset <= '0';
			elsif rst_counter = 3789 then  
				ac97_n_reset <= '1';
				rst_counter <= 0;
			else
				rst_counter <= rst_counter + 1;
			end if;
		end if;
	end process;
	
	
	-- This process generates a single clkcycle pulse
	-- to get configuration data from the ac97cmd FSM
	-- and lets the user know when a sample is ready
	---------------------------------------------------------------------------------------										
	process (clk, n_reset, bit_count)
	begin
		if(rising_edge(clk)) then
			Q2 <= Q1;
			if(bit_count = "00000000") then
				Q1 <= '0';
				Q2 <= '0';
			elsif(bit_count >= "10000001") then
				Q1 <= '1';
			end if;
			ac97_ready_sig <= Q1 and not Q2;
		end if;
	end process;
		
		
	-- ac97-link frame is 256 cycles 
	-- [slot0], [slot1], [slot2], [slot3], [slot4], [slot5] ... [slot9], [slot10], [slot11], [slot12]
	-- slot 0 [tag phase] is 16 cycles slot1:12 are 20 cycles so 16 + 12 * 20 = 256 cycles
	-- ac97 link output frame [frame going out]
	---------------------------------------------------------------------------------------
	process (n_reset, bit_count, ac97_bitclk)
	begin
	 
		if(n_reset = '0') then							-- active low reset
			bit_count <= "00000000";					-- starts bit count at 0
		end if;
	 
	 
	 
		if (rising_edge(ac97_bitclk)) then
		
			if bit_count = "11111111" then					-- Generate sync signal for ac97
				ac97_sync <= '1';									-- at bitcnt = 255
			end if;

			if bit_count = "00001111" then					-- at bitcnt = 15
				ac97_sync <= '0';
			end if;


															-- At the end of each frame the user data is latched in 
			if bit_count = "11111111" then
				latch_cmd_addr   <= cmd_addr & "000000000000";
				latch_cmd_data   <= cmd_data & "0000";
				latch_left_data  <= left_data;
				latch_right_data <= right_data;
			end if;	 
			
			
																			-- Tag phase
			if (bit_count >= "00000000") and (bit_count <= "00001111") then	-- bit count 0 to 15
																			-- Slot 0 : Tag Phase
				case bit_count is											-- Can create input signals to verify on tag phase
					when "00000000"      => ac97_sdata_out <= '1';      	-- AC Link Interface ready
					when "00000001"      => ac97_sdata_out <= latching_cmd; -- Valid Status Adress or Slot request
					when "00000010"      => ac97_sdata_out <= '1';  		-- Valid Status data 
					when "00000011"      => ac97_sdata_out <= '1';      	-- Valid PCM Data (Left ADC)
					when "00000100"      => ac97_sdata_out <= '1';      	-- Valid PCM Data (Right ADC)
					when others => ac97_sdata_out <= '0';
				end case;
																				-- starting at slot 1 add 20 bit counts each time
			elsif (bit_count >= "00010000") and (bit_count <= "00100011") then	-- bit count 16 to 35
																				-- Slot 1 : Command address (8-bits, left justified)
																						
				if latching_cmd = '1' then
					ac97_sdata_out <= latch_cmd_addr(35 - to_integer(unsigned(bit_count)));
				else
					ac97_sdata_out <= '0';
				end if;

			elsif (bit_count >= "00100100") and (bit_count <= "00110111") then	-- bit count 36 to 55
																				-- Slot 2 : Command data (16-bits, left justified)
																						
				if latching_cmd = '1' then
					ac97_sdata_out <= latch_cmd_data(55 - to_integer(unsigned(bit_count)));
				else
					ac97_sdata_out <= '0';
				end if;

			elsif ((bit_count >= "00111000") and (bit_count <= "01001011")) then	-- bit count 56 to 75

																					-- Slot 3 : left channel
																						
				ac97_sdata_out <= latch_left_data(19);								-- send out bits and rotate through 20 bit word

				latch_left_data <= latch_left_data(18 downto 0) & latch_left_data(19);

			elsif ((bit_count >= "01001100") and (bit_count <= "01011111")) then	-- bit count 76 to 95
																					-- Slot 4 : right channel
																						
				ac97_sdata_out <= latch_right_data(95 - to_integer(unsigned(bit_count)));
		  
			else
				ac97_sdata_out <= '0';
			end if;

																					
			bit_count <= std_logic_vector(unsigned(bit_count) + 1);					-- increment bit counter
		end if;
	end process;

	-- ac97 link input frame [frame coming in]
	---------------------------------------------------------------------------
	process (ac97_bitclk)
	begin
		if (falling_edge(ac97_bitclk)) then						-- clock on falling edge of bitclk
			if (bit_count >= "00111001") and (bit_count <= "01001100") then 	-- from 57 to 76
																				-- Slot 3 : left channel
				left_in_data <= left_in_data(18 downto 0) & ac97_sdata_in;		-- concat incoming bits on end
			elsif (bit_count >= "01001101") and (bit_count <= "01100000") then 	-- from 77 to 96
																				-- Slot 4 : right channel
				right_in_data <= right_in_data(18 downto 0) & ac97_sdata_in;	-- concat incoming bits on end
			end if;
		end if;
	end process;

end arch;






