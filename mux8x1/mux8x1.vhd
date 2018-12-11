-------------------------------File mux8x1.vhd----------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity mux8x1 is
port (
	a0, a1, a2, a3, a4, a5, a6, a7 	: in 	std_logic_vector(7 downto 0);
	s 											: in 	std_logic_vector(2 downto 0);
	y 											: out std_logic_vector(7 downto 0)
);
end mux8x1;
--------------------------------------------------------------------------------
architecture mux of mux8x1 is
    ----------------------------------------
	component mux4x1 is
	port (
		a0, a1, a2, a3 : in 	std_logic_vector(7 downto 0);
		s 					: in 	std_logic_vector(1 downto 0);
		y 					: out std_logic_vector(7 downto 0)
	);
	end component;
    ----------------------------------------
	signal y1, y2 : std_logic_vector(7 downto 0);
begin
	mux1 : mux4x1 port map (a0, a1, a2, a3, s(1 downto 0), y1);
	mux2 : mux4x1 port map (a4, a5, a6, a7, s(1 downto 0), y2);
	y <=	y1 when s(2) = '0' else
			y2 when s(2) = '1' else
			"ZZZZZZZZ";
end mux;
--------------------------------------------------------------------------------