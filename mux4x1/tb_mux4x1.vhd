library ieee;
use ieee.std_logic_1164.all;

entity tb_mux4x1 is
end tb_mux4x1;

architecture tb of tb_mux4x1 is
	signal a0, a1, a2, a3, y : std_logic_vector(7 downto 0);
	signal s : std_logic_vector(1 downto 0);
begin
	uut : entity work.mux4x1 port map (a0, a1, a2, a3, s, y);
	a0 <= "00000000", "11111111" after 20 ns;
	a1 <= "10101010", "01010101" after 40 ns;
	s <= "00", "01" after 40 ns, "10" after 80 ns;
end tb;