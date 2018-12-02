library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------
entity micro is
port (
	clk, rst	: in 	std_logic;
	input 	: in 	std_logic_vector(7 downto 0);
	output 	: out std_logic_vector(7 downto 0)
);
end micro;
------------------------------------------------
architecture struct of micro is
	component datapath is
	port (
		clk			: in		std_logic;
		ins			: buffer	std_logic_vector(15 downto 0);
		c, z, n		: out		std_logic;
		src_r			: in		std_logic_vector(2 downto 0);
		ula_op 		: in		std_logic_vector(3 downto 0);
		sel_a, sel_b: in 		std_logic_vector(1 downto 0);
		ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk,
		ld_in, ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc,
		ld_ir			: in		std_logic;
		input 		: in		std_logic_vector(7 downto 0);
		output		: out		std_logic_vector(7 downto 0)
	);
	end component;
	
	component ctrl is
	port (
		clk, rst		: in	std_logic;
		ins 			: in	std_logic_vector(15 downto 0);
		c, z, n 		: in	std_logic;
		src_r 		: out	std_logic_vector(2 downto 0);
		ula_op 		: out	std_logic_vector(3 downto 0);
		sel_a, sel_b: out	std_logic_vector(1 downto 0);
		ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
		ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc,
		ld_ir 		: out	std_logic
	);
	end component;
	
	signal ins				: std_logic_vector(15 downto 0);
	signal c, z, n			: std_logic;
	signal src_r 			: std_logic_vector(2 downto 0);
	signal ula_op 			: std_logic_vector(3 downto 0);
	signal sel_a, sel_b	: std_logic_vector(1 downto 0);
	signal ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
		ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir : std_logic;
	signal count: integer range 0 to 50000000 := 1;
	signal clk_d: std_logic := '0';
	constant terminal_count: integer := 5;

begin
	control	: ctrl		port map(clk_d, rst, ins, c, z, n, src_r, ula_op, sel_a, sel_b,
							ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
							ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir);
	data		: datapath	port map(clk_d, ins, c, z, n, src_r, ula_op, sel_a, sel_b,
							ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
							ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir,
							input, output);
							
	clk_div : process(clk)
	begin
		if (clk = '1' and clk'event) then
			count <= count + 1;
			IF (count >= terminal_count) then
				count <= 1;
				clk_d <= not (clk_d);
			end if;
		end if;
	end process clk_div;
end struct;
