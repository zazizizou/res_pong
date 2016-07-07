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
