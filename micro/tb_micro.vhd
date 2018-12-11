------------------------File tb_micro.vhd (testbench)---------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity tb_micro is
end tb_micro;
--------------------------------------------------------------------------------
architecture tb of tb_micro is
	signal clk 		: std_logic := '0';
	signal rst 		: std_logic := '1';
	signal input 	: std_logic_vector(7 downto 0) := "00000100";
	signal output 	: std_logic_vector(7 downto 0);
    ----------------------------------------
	component micro is
	port (
		clk, rst : in std_logic;
		input 	: in std_logic_vector(7 downto 0);
		output 	: out std_logic_vector(7 downto 0);
		---DEBUG---
		disp_number_dez : out std_logic_vector(6 downto 0);
		disp_number_und : out std_logic_vector(6 downto 0);
		ins_debug       : out std_logic_vector(15 downto 0);
		y               : out std_logic_vector(7 downto 0)
	);
	end component;
    ----------------------------------------
	signal disp1, disp2 : std_logic_vector(6 downto 0);
begin
	uut : micro port map (clk, rst, input, output, disp1, disp2);
	rst <= '0' after 100 ns;
	process is
	begin
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
	end process;
end tb;
--------------------------------------------------------------------------------