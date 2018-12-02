library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
port (
	a0, a1 : in std_logic_vector(7 downto 0);
	s : in std_logic;
	y : out std_logic_vector(7 downto 0)
);
end mux2x1;

architecture beh of mux2x1 is
begin
	y <=	a0 when s = '0' else
			a1 when s = '1' else
			"ZZZZZZZZ";
end beh;