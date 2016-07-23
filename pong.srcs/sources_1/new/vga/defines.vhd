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

constant HDMI : boolean := false;
----------------------------------------------------
-- colors
-- example: vgaRed = BLACK(RED);
----------------------------------------------------
-- RGB
constant RED   : natural := 0;
constant GREEN : natural := 1;
constant BLUE  : natural := 2;

--types x/y-axis
subtype x_axis_t is STD_LOGIC_VECTOR(9 downto 0);
subtype y_axis_t is STD_LOGIC_VECTOR(8 downto 0);

-- type color
type color_t is array (0 to 2) of STD_LOGIC_VECTOR(3 downto 0);

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
constant WALL_THICKNESS : natural := 20;

--ball
constant BALL_SIZE : natural := 15;
constant BALL_RESET_POS_X : natural := 200;
constant BALL_RESET_POS_Y : natural := 200;
constant BALL_SPEED_COUNTER_MAX : natural := 2**19;

--paddle
constant PADDLE_WIDTH : natural := 15;
constant PADDLE_HIGHT : natural := 80;
constant PADDLE_RESET_POS_Y : natural := 100;
constant L_PADDLE_POS_X : natural := 30;
constant L_PADDLE_BLOCK : natural := L_PADDLE_POS_X + PADDLE_WIDTH;
constant L_PADDLE_SPEED_COUNTER_MAX : natural := 2**19;
constant R_PADDLE_POS_X : natural := WINDOW_WIDTH - PADDLE_WIDTH - L_PADDLE_POS_X;
constant R_PADDLE_BLOCK : natural := R_PADDLE_POS_X - BALL_SIZE;
constant R_PADDLE_SPEED_COUNTER_MAX : natural := 2**19;
end package defines;
