library ieee;
use ieee.std_logic_1164.all;

entity datapath is
port (
	clk : in std_logic;
	ins : buffer std_logic_vector(15 downto 0);
	c, z, n : out std_logic;
	src_r : in std_logic_vector(2 downto 0);
	ula_op :in std_logic_vector(3 downto 0);
	sel_a, sel_b : in std_logic_vector(1 downto 0);
	ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
	ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir : in std_logic;
	input : in std_logic_vector(7 downto 0);
	output : out std_logic_vector(7 downto 0)
);
end datapath;

architecture struct of datapath is
	component pc is
	port (
		clk : in std_logic;
		ld_pc, cnt_pc, sum, clr : in std_logic;
		k : in std_logic_vector(7 downto 0);
		pc_out : buffer std_logic_vector(7 downto 0)
	);
	end component;
	
	component ula is
	port (
		a, b : in std_logic_vector(7 downto 0);
		ula_op : in std_logic_vector(3 downto 0);
		y : out std_logic_vector(7 downto 0);
		c, z, n : buffer std_logic
	);
	end component;
	
	component mux2x1 is
	port (
		a0, a1 : in std_logic_vector(7 downto 0);
		s : in std_logic;
		y : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component mux4x1 is
	port (
		a0, a1, a2, a3 : in std_logic_vector(7 downto 0);
		s : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component mux8x1 is
	port (
		a0, a1, a2, a3, a4, a5, a6, a7 : in std_logic_vector(7 downto 0);
		s : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component reg is
	generic (
		N : integer := 8
	);
	port (
		clk : in std_logic;
		ld : in std_logic;
		input : in std_logic_vector(N-1 downto 0);
		output : out std_logic_vector(N-1 downto 0)
	);
	end component;
	
	component ram is
	port (
		address : in std_logic_vector(7 DOWNTO 0);
		clock : in std_logic := '1';
		data : in std_logic_vector(7 DOWNTO 0);
		wren : in std_logic;
		q : out std_logic_vector(7 DOWNTO 0)
	);
	end component;
	
	component rom is
	port (
		address : in std_logic_vector(7 DOWNTO 0);
		clock : in std_logic := '1';
		q : out std_logic_vector(15 DOWNTO 0)
	);
	end component;
	
	signal A, B, y, R, r00, r01, r10, r11 : std_logic_vector(7 downto 0);
	signal pc_in, pc_out, k, stk_out : std_logic_vector(7 downto 0);
	signal rin, rout, Dout : std_logic_vector(7 downto 0);
	signal ir_out : std_logic_vector(15 downto 0);
	signal c0, z0, n0 : std_logic;
	signal czn, czn_out : std_logic_vector(2 downto 0);
	signal nclk : std_logic;
	
begin
	nclk <= not clk;
	pc1 : pc port map(clk, ld_pc, cnt_pc, sum_pc, clr_pc, pc_in, pc_out);
	ula1 : ula port map (A, B, ula_op, y, c0, z0, n0);
	muxA : mux4x1 port map(r00, r01, r10, r11, sel_a, A);
	muxB : mux4x1 port map(r00, r01, r10, r11, sel_b, B);
	R0 : reg generic map(8) port map(clk, ld_0, R, r00);
	R1 : reg generic map(8) port map(clk, ld_1, R, r01);
	R2 : reg generic map(8) port map(clk, ld_2, R, r10);
	R3 : reg generic map(8) port map(clk, ld_3, R, r11);
	flags : reg generic map(3) port map(clk, ld_flags, czn, czn_out);
	IR : reg generic map(16) port map(clk, ld_ir, ins, ir_out);
	ri : reg generic map(8) port map(nclk, ld_in, input, rin);
	ro : reg generic map(8) port map(clk, ld_out, B, output);
	muxpc : mux2x1 port map(k, stk_out, src_pc, pc_in);
	muxR : mux8x1 port map(y, rin, Dout, k, B, "ZZZZZZZZ", "ZZZZZZZZ", "ZZZZZZZZ", src_r, R);
	D : ram port map(k, clk, B, mem_rw, Dout);
	I : rom port map(pc_out, clk, ins);
	stack : reg generic map(8) port map(clk, ld_stk, pc_out, stk_out);
	
	czn <= c0 & z0 & n0;
	c <= czn_out(2);
	z <= czn_out(1);
	n <= czn_out(0);
	k <= ir_out(7 downto 0);
end struct;

