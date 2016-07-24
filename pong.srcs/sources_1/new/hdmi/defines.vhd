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
constant WALL_THICKNESS : natural := WINDOW_WIDTH / 50;

--ball
constant BALL_SIZE : natural := WINDOW_WIDTH / 50;
constant BALL_RESET_POS_X : natural := WINDOW_WIDTH / 5;
constant BALL_RESET_POS_Y : natural := WINDOW_WIDTH / 5;
constant BALL_SPEED_COUNTER_MAX : natural := 2**19;

--paddle
constant PADDLE_WIDTH : natural := WINDOW_WIDTH / 50;
constant PADDLE_HIGHT : natural := WINDOW_WIDTH / 10;
constant PADDLE_RESET_POS_Y : natural := WINDOW_WIDTH / 6;
constant L_PADDLE_POS_X : natural := WINDOW_WIDTH /25;
constant L_PADDLE_BLOCK : natural := L_PADDLE_POS_X + PADDLE_WIDTH;
constant L_PADDLE_SPEED_COUNTER_MAX : natural := 2**18;
constant R_PADDLE_POS_X : natural := WINDOW_WIDTH - PADDLE_WIDTH - L_PADDLE_POS_X;
constant R_PADDLE_BLOCK : natural := R_PADDLE_POS_X - BALL_SIZE;
constant R_PADDLE_SPEED_COUNTER_MAX : natural := 2**18;

--score
constant SCORE_BAR_WIDTH : natural := WINDOW_WIDTH / 100;
constant SCORE_BAR_HIGHT : natural := WINDOW_WIDTH / 25;
constant SCORE_DISTANCE  : natural := WINDOW_WIDTH / 20;
constant SCORE_POS_Y     : natural := WINDOW_HIGHT / 10;
constant SCORE_POS_X_L0  : natural := (WINDOW_WIDTH / 2) - SCORE_DISTANCE;
constant SCORE_POS_X_L1  : natural := (WINDOW_WIDTH / 2) - (2 * SCORE_DISTANCE);
constant SCORE_POS_X_R0  : natural := (WINDOW_WIDTH / 2) + (2 * SCORE_DISTANCE);
constant SCORE_POS_X_R1  : natural := (WINDOW_WIDTH / 2) + SCORE_DISTANCE;

end package defines;
