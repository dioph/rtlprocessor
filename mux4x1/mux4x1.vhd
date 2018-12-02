library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
port (
	a0, a1, a2, a3 : in std_logic_vector(7 downto 0);
	s : in std_logic_vector(1 downto 0);
	y : out std_logic_vector(7 downto 0)
);
end mux4x1;

architecture mux of mux4x1 is
begin
	y <=	a0 when s = "00" else
			a1 when s = "01" else
			a2 when s = "10" else
			a3 when s = "11" else
			"ZZZZZZZZ";
end mux;