library ieee;
use ieee.std_logic_1164.all;

entity reg is
generic (
	N : integer := 8
);
port (
	clk : in std_logic;
	ld : in std_logic;
	input : in std_logic_vector(N-1 downto 0);
	output : out std_logic_vector(N-1 downto 0)
);
end reg;

architecture beh of reg is
begin
	process(clk) is
	begin
		if (clk = '1' and clk'event) then
			if (ld = '1') then
				output <= input;
			end if;
		end if;
	end process;
end beh;
