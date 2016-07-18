<<<<<<< Updated upstream
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2016 09:57:44 AM
-- Design Name: 
-- Module Name: defines - Behavioral
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
library work;
package defines is
----------------------------------------------------
-- colors
-- example: vgaRed = BLACK(RED);
----------------------------------------------------
-- type color
type color_t is array (0 to 2) of STD_LOGIC_VECTOR(3 downto 0);

-- RGB
constant RED   : natural := 0;
constant GREEN : natural := 1;
constant BLUE  : natural := 2;

-- black
constant BLACK : color_t := ("0000", "0000", "0000");

-- white
constant WHITE : color_t := ("1111", "1111", "1111");

------------------------------------------------------------------------------------------------------------
-- the x/y coords, which determine the position of an object are always the upper left corner of the oject
-- the origin of the coordinate system is the upper left corner of the screen
-- y-axis: downwards, x-axis: rightwards
------------------------------------------------------------------------------------------------------------

--common
type x_direction_t is (RIGHT, LEFT);
type y_direction_t is (DOWN, UP);

-- input
constant DEBOUNCER_COUNTER_MAX : natural := 2**20;

-- window
constant WINDOW_WIDTH : natural := 640;
constant WINDOW_HIGHT : natural := 480;

--wall
constant WALL_THICKNESS : natural := 30;

--ball
constant BALL_SIZE : natural := 20;
constant BALL_RESET_POS_X : natural := 200;
constant BALL_RESET_POS_Y : natural := 200;
constant BALL_SPEED_COUNTER_MAX : natural := 2**19;

--panel
constant PANEL_WIDTH : natural := 20;
constant PANEL_HIGHT : natural := 80;
constant PANEL_RESET_POS_Y : natural := 100;
constant L_PANEL_POS_X : natural := 50;
constant L_PANEL_SPEED_COUNTER_MAX : natural := 2**19;
constant R_PANEL_POS_X : natural := 590;
constant R_PANEL_SPEED_COUNTER_MAX : natural := 2**19;
end package defines;
=======
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2016 09:57:44 AM
-- Design Name: 
-- Module Name: defines - Behavioral
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

package defines is
----------------------------------------------------
-- colors
----------------------------------------------------

-- black
constant BLACK_R : STD_LOGIC_VECTOR := "0000"; 
constant BLACK_G : STD_LOGIC_VECTOR := "0000";
constant BLACK_B : STD_LOGIC_VECTOR := "0000";

-- white
constant WHITE_R : STD_LOGIC_VECTOR := "1111";
constant WHITE_G : STD_LOGIC_VECTOR := "1111";
constant WHITE_B : STD_LOGIC_VECTOR := "1111";
end defines;
>>>>>>> Stashed changes
