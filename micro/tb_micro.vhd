library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_micro is
end tb_micro;

architecture tb of tb_micro is
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
	signal input : std_logic_vector(7 downto 0) := "00000100";
	signal output : std_logic_vector(7 downto 0);
	component micro is
	port (
		clk, rst : in std_logic;
		input : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
	end component;
begin
	uut : micro port map (clk, rst, input, output);
	rst <= '0' after 100 ns;
	process is
	begin
		wait for 10 ns;
		--input <= std_logic_vector(unsigned(input) + 1);
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		--input <= std_logic_vector(unsigned(input) + 1);
	end process;
end tb;