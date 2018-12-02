library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc is
end tb_pc;

architecture tb of tb_pc is
	signal clk : std_logic := '0';
	signal sum : std_logic := '1';
	signal cnt_pc, ld_pc, clr: std_logic := '0';
	signal k : std_logic_vector(7 downto 0) := "00000010";
	signal pc_out : std_logic_vector(7 downto 0) := "00000000";
begin
	uut : entity work.pc port map (clk, ld_pc, cnt_pc, sum, k, pc_out);
	process is
	begin
		ld_pc <= sum;
		sum <= cnt_pc;
		cnt_pc <= clr;
		clr <= ld_pc;
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
	end process;
end tb;