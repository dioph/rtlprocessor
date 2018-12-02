library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
port (
	clk : in std_logic;
	ld_pc, cnt_pc, sum, clr : in std_logic;
	k : in std_logic_vector(7 downto 0);
	pc_out : buffer std_logic_vector(7 downto 0)
);
end pc;

architecture beh of pc is
begin
	process(clk) is
	begin
		if (clk'event and clk = '1') then
			if (clr = '1') then
				pc_out <= "00000000";
			elsif (ld_pc = '1') then
				pc_out <= k;
			elsif (cnt_pc = '1') then
				pc_out <= std_logic_vector(unsigned(pc_out) + 1);
			elsif (sum = '1') then
				pc_out <= std_logic_vector(unsigned(pc_out) + unsigned(k));
			end if;
		end if;
	end process;
end beh;