library ieee;
use ieee.std_logic_1164.all;

entity tb_mux8x1 is
end tb_mux8x1;

architecture tb of tb_mux8x1 is
	signal a0, a1, a2, a3, a4, a5, a6, a7, y : std_logic_vector(7 downto 0);
	signal s : std_logic_vector(2 downto 0);
begin
	uut : entity work.mux8x1 port map (a0, a1, a2, a3, a4, a5, a6, a7, s, y);
	a0 <= "00000000", "11111111" after 20 ns;
	a1 <= "10101010", "01010101" after 40 ns;
	a4 <= "10000000", "01111111" after 60 ns;
	s <= "000", "001" after 40 ns, "100" after 80 ns;
end tb;