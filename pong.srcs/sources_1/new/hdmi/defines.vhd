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

constant HDMI : boolean := true;
----------------------------------------------------
-- colors
-- example: vgaRed = BLACK(RED);
----------------------------------------------------
-- RGB
constant RED   : natural := 0;
constant GREEN : natural := 1;
constant BLUE  : natural := 2;

-- type color
type color_t is array (0 to 2) of STD_LOGIC_VECTOR(7 downto 0);

-- black
constant BLACK : color_t := ("00000000", "00000000", "00000000");

-- white
constant WHITE : color_t := ("11111111", "11111111", "11111111");

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
constant WINDOW_WIDTH : natural := 1280;
constant WINDOW_HIGHT : natural := 720;

--wall
constant WALL_THICKNESS : natural := 60;

--ball
constant BALL_SIZE : natural := 40;
constant BALL_RESET_POS_X : natural := 400;
constant BALL_RESET_POS_Y : natural := 400;
constant BALL_SPEED_COUNTER_MAX : natural := 2**19;

--panel
constant PANEL_WIDTH : natural := 40;
constant PANEL_HIGHT : natural := 160;
constant PANEL_RESET_POS_Y : natural := 200;
constant L_PANEL_POS_X : natural := 100;
constant L_PANEL_SPEED_COUNTER_MAX : natural := 2**19;
constant R_PANEL_POS_X : natural := 940;
constant R_PANEL_SPEED_COUNTER_MAX : natural := 2**19;
end package defines;
