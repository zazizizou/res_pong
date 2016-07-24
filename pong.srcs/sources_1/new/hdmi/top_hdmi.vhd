----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2016 01:35:47 PM
-- Design Name: 
-- Module Name: top_c - Behavioral
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
use work.defines.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_hdmi is
  Port (
		  --SYS_CLK : in  STD_LOGIC;
		  RSTBTN  : in  std_logic;
        SYS_CLK         : in  STD_LOGIC;
        --RSTBTN : in  STD_LOGIC;			RSTBTN disabled
        btnU        : in  STD_LOGIC;
        btnD        : in  STD_LOGIC;
		  
		  TMDS : out	std_logic_vector(3 downto 0);
        TMDSB : out	std_logic_vector(3 downto 0);
        --Hsync       : out STD_LOGIC;
        --Vsync       : out STD_LOGIC;
        --vgaRed      : out STD_LOGIC_VECTOR(3 downto 0);
        --vgaBlue     : out STD_LOGIC_VECTOR(3 downto 0);
        --vgaGreen    : out STD_LOGIC_VECTOR(3 downto 0));
		  
		  -- interface for sound generator
		  AUDSDI : in STD_LOGIC;
		  BITCLK : in STD_LOGIC;
		  SW : in STD_LOGIC_VECTOR (4 downto 0); -- switches for sound volume
		  AUDSYNC : out STD_LOGIC;
		  AUDSDO : out STD_LOGIC;
		  AUDRST : out STD_LOGIC
		  --
		  );
		  
end top_hdmi;

architecture Behavioral of top_hdmi is

  component debouncer_c
    Port (clk     : in  STD_LOGIC;
          res_n   : in  STD_LOGIC;
          btn     : in  STD_LOGIC;
          deb_btn : out STD_LOGIC);
  end component;

  component computer_opponent_c
      Port ( clk              : in  STD_LOGIC;
             res_n            : in  STD_LOGIC;
             enb              : in  STD_LOGIC;
             y_paddle_left    : in  y_axis_t;
             x_ball           : in  x_axis_t;
             y_ball           : in  y_axis_t;
             x_direction_ball : in  x_direction_t;
             btn_up           : out STD_LOGIC;
             btn_down         : out STD_LOGIC);
  end component;




  component image_generator_c
    Port ( clk              : in  STD_LOGIC;
           res_n            : in  STD_LOGIC;
           btn_up_left      : in  STD_LOGIC;
           btn_down_left    : in  STD_LOGIC;
           btn_up_right     : in  STD_LOGIC;
           btn_down_right   : in  STD_LOGIC;
           x_coord          : in  x_axis_t;
           y_coord          : in  y_axis_t;
           enb              : in  STD_LOGIC;
           l_scored         : in  STD_LOGIC;
           r_scored         : in  STD_LOGIC;
           l_paddle_hit     : in  STD_LOGIC;
           r_paddle_hit     : in  STD_LOGIC;
           rgb              : out color_t;
           y_paddle_left    : out y_axis_t;
           y_paddle_right   : out y_axis_t;
           x_ball           : out x_axis_t;
           y_ball           : out y_axis_t;
           x_direction_ball : out x_direction_t);
  end component;

--  component vga_controller_c
--  port (clk     : in  STD_LOGIC;
--        res_n   : in  STD_LOGIC;
--        h_sync  : out STD_LOGIC;
--        v_sync  : out STD_LOGIC;
--        x_coord : out STD_LOGIC_VECTOR(9 downto 0);
--        y_coord : out STD_LOGIC_VECTOR(8 downto 0));
--  end component;
  
	component clk_wiz_v3_6
	port
	(-- Clock in ports
		CLK_IN1           : in     std_logic;
		-- Clock out ports
		CLK_OUT1          : out    std_logic;
		CLK_OUT2          : out    std_logic;
		-- Status and control signals
		RESET             : in     std_logic;
		LOCKED            : out    std_logic
		);
	end component;
	
	component match_controller
   port ( 
			  clkfx			: 		in  STD_LOGIC;
			  res_n			: 		in  STD_LOGIC;
			  
			  y_paddle_left: 		in  y_axis_t;
           y_paddle_right: 		in  y_axis_t;
           x_ball 		: 	in  x_axis_t;
           y_ball 		: 	in  y_axis_t;
			  l_scored 		: 		out  STD_LOGIC;
           r_scored 		: 		out  STD_LOGIC;
           l_paddle_hit : 	out  STD_LOGIC;
           r_paddle_hit : 	out  STD_LOGIC);
	end component;


  
  component hdmi_red
  port (
			--clk 		: in  STD_LOGIC;
			clkfx		: in 	std_logic;
			RSTBTN  	: in  std_logic;
			rgb_wire : in color_t;
			pclk		: out	std_logic;
			pclk_lckd: in 	std_logic;
         TMDS 		: out	std_logic_vector(3 downto 0);
         TMDSB 	: out	std_logic_vector(3 downto 0);
			x_coord 	: out x_axis_t;
			y_coord 	: out y_axis_t);
  end component;
  
	component sound_generator_c
	port ( clk : in  STD_LOGIC;
           n_reset : in  STD_LOGIC;
			  SDATA_IN : in STD_LOGIC;	
			  BIT_CLK : in STD_LOGIC;
			  SOURCE : in STD_LOGIC_VECTOR(3 downto 0);
			  VOLUME : in STD_LOGIC_VECTOR(4 downto 0);
			  SYNC : out STD_LOGIC;
			  SDATA_OUT : out STD_LOGIC;
			  AC97_n_RESET : out STD_LOGIC
			  );
	end component;
  
  -- signals for sound generator
   
  --
  signal x_coord_wire      : x_axis_t;
  signal y_coord_wire      : y_axis_t;
  signal rgb_wire          : color_t;
  signal btn_up_left_wire      : STD_LOGIC;
  signal btn_down_left_wire    : STD_LOGIC;
  signal btn_up_right_wire     : STD_LOGIC;
  signal btn_down_right_wire   : STD_LOGIC;
  signal enb_wire          : STD_LOGIC;
  signal pclk					: STD_LOGIC;
  signal clkfx					: STD_LOGIC;
  signal clk					: STD_LOGIC;
  signal pclk_lckd			: STD_LOGIC;
  signal y_paddle_left		: y_axis_t;
  signal y_paddle_right		: y_axis_t;
  signal x_ball 				: x_axis_t;
  signal y_ball 				: y_axis_t;
  signal x_direction_ball_wire : x_direction_t;
  signal l_scored 			: STD_LOGIC;
  signal r_scored 			: STD_LOGIC;
  signal l_paddle_hit 		: STD_LOGIC;
  signal r_paddle_hit 		: STD_LOGIC;
begin

  btn_up_debouncer_I : debouncer_c
  port map (
    clk     => clkfx,
    res_n   => '1',		-- RSTBTN/reset disabled
    btn     => btnU,
    deb_btn => btn_up_right_wire
  );
  
  btn_down_debouncer_I : debouncer_c
  port map (
    clk     => clkfx,
    res_n   => '1',		-- RSTBTN/reset disabled
    btn     => btnD,
    deb_btn => btn_down_right_wire
  );
  
   clk_wiz_i : clk_wiz_v3_6
	port map
	(-- Clock in ports
		CLK_IN1 	=> SYS_CLK,
		-- Clock out ports
		CLK_OUT1 => clk,
		CLK_OUT2	=> clkfx,
		-- Status and control signals
		RESET		=> '0',		-- RSTBTN/reset disabled
		LOCKED	=> pclk_lckd
		);

  computer_opponent_I: computer_opponent_c
  port map ( 
    clk              => clkfx,
    res_n            => '1',
    enb              => enb_wire,
    y_paddle_left    => y_paddle_left,
    x_ball           => x_ball,
    y_ball           => y_ball,
    x_direction_ball => x_direction_ball_wire,
    btn_up           => btn_up_left_wire,
    btn_down         => btn_down_left_wire
  );
		
	match_controller_i : match_controller
   port map ( 
			  clkfx			=> clkfx,
			  res_n			=> '1',
			  
			  y_paddle_left=> y_paddle_left,
           y_paddle_right=> y_paddle_right,
           x_ball 		=> x_ball,
           y_ball 		=> y_ball,
			  l_scored 		=> l_scored,
           r_scored 		=> r_scored,
           l_paddle_hit => l_paddle_hit,
           r_paddle_hit => r_paddle_hit
			  );
	
  
--  GEN_HDMI: if HDMI = true generate
	 hdmi_red_I: hdmi_red
    port map (
      clkfx		=> clkfx,
      RSTBTN  	=> '0',		-- RSTBTN/reset disabled
      rgb_wire	=> rgb_wire,
		pclk 		=> pclk,
		pclk_lckd=> pclk_lckd,
      TMDS  	=> TMDS,
      TMDSB 	=> TMDSB,
		x_coord 	=> x_coord_wire,
		y_coord 	=> y_coord_wire
    );
--  end generate GEN_HDMI;

--  GEN_VGA: if HDMI = false generate
--    vga_controller_I: vga_controller_c
--    port map (
--      clk     => clk,
--      res_n   => btnCpuReset,
--      h_sync  => Hsync,
--      v_sync  => Vsync,
--      x_coord => x_coord_wire,
--      y_coord => y_coord_wire
--    );
--  end generate GEN_VGA;
  
  image_generator_I: image_generator_c
  port map (
    clk              => clkfx,
    res_n            => '1',		-- RSTBTN/reset disabled
    btn_up_left      => btn_up_left_wire,
    btn_down_left    => btn_down_left_wire,
    btn_up_right     => btn_up_right_wire,
    btn_down_right   => btn_down_right_wire,
    x_coord          => x_coord_wire,
    y_coord          => y_coord_wire,
    enb              => enb_wire,
    l_scored         => l_scored,
    r_scored         => r_scored,
    l_paddle_hit     => l_paddle_hit,
    r_paddle_hit     => r_paddle_hit,
    rgb              => rgb_wire,
    y_paddle_left    => y_paddle_left,
    y_paddle_right   => y_paddle_right,
    x_ball           => x_ball,
    y_ball           => y_ball,
    x_direction_ball => x_direction_ball_wire
  );
 
  snd_gen : sound_generator_c
  port map ( clk  => clk, 
           n_reset => RSTBTN, 
			  SDATA_IN => AUDSDI,
			  BIT_CLK => BITCLK,
			  SOURCE => (l_paddle_hit & r_paddle_hit & l_scored & r_scored),
			  VOLUME => SW,
			  SYNC => AUDSYNC,
			  SDATA_OUT => AUDSDO,
			  AC97_n_RESET => AUDRST
			  );

  
  color_test : process (clkfx) -- , RSTBTN
  begin
  --if (not RSTBTN = '0') then
  --  enb_wire <= '0';
  --els
  if rising_edge(clkfx) then
        enb_wire <= '1';
  end if;
  end process;
--  vgaRed   <= rgb_wire(RED);
--  vgaBlue  <= rgb_wire(BLUE);
--  vgaGreen <= rgb_wire(GREEN);
end Behavioral;
