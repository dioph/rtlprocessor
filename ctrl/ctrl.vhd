--------------------------------File ctrl.vhd-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity ctrl is
port (
	clk, rst                :   in  std_logic;
	ins                     :   in  std_logic_vector(15 downto 0);
	c, z, n                 :   in  std_logic;
   src_r                   :   out std_logic_vector(2 downto 0);
	ula_op                  :   out std_logic_vector(3 downto 0);
	sel_a, sel_b            :   out std_logic_vector(1 downto 0);
	ld_0, ld_1, ld_2, ld_3  :   out std_logic;
	ld_flags, mem_rw, ld_stk:   out std_logic;
	ld_in, ld_out, ld_pc    :   out std_logic;
	cnt_pc, sum_pc, clr_pc  :   out std_logic;
	src_pc, ld_ir           :   out std_logic
);
end ctrl;
--------------------------------------------------------------------------------
architecture beh of ctrl is
	type State is (init, fetch, decode, mv, ld, st, mvi, i, o, add, adc, sub, e, ou, 
					shl, shr, inc, dec, cmp, call, ret, jmp, jz, jn, brch, breq, brlo,
					hold);
	signal CurrState : State := init;
begin
	regs : process (clk, rst) is
		variable op : std_logic_vector(4 downto 0);
	begin
		if (rst = '1') then
			CurrState <= init;
		elsif (clk = '1' and clk'event) then
			case CurrState is
				when init   => CurrState <= fetch;
				when fetch  => CurrState <= decode;
				when decode =>
					op := ins(15 downto 11);
					case op is
						when "00000" => CurrState <= mv;
						when "00001" => CurrState <= ld;
						when "00010" => CurrState <= st;
						when "00011" => CurrState <= mvi;
						when "00100" => CurrState <= i;
						when "00101" => CurrState <= o;
						when "00110" => CurrState <= add;
						when "00111" => CurrState <= adc;
						when "01000" => CurrState <= sub;
						when "01001" => CurrState <= e;
						when "01010" => CurrState <= ou;
						when "01011" => CurrState <= shl;
						when "01100" => CurrState <= shr;
						when "01101" => CurrState <= inc;
						when "01110" => CurrState <= dec;
						when "01111" => CurrState <= cmp;
						when "10000" => CurrState <= call;
						when "10001" => CurrState <= ret;
						when "10010" => CurrState <= jmp;
						when "10011" => CurrState <= jz;
						when "10100" => CurrState <= jn;
						when "10101" => CurrState <= brch;
						when "10110" => CurrState <= breq;
						when "10111" => CurrState <= brlo;
						when others  => CurrState <= fetch;
					end case;
				when mv     => CurrState <= fetch;
				when ld     => CurrState <= fetch;
				when st     => CurrState <= fetch;
				when mvi    => CurrState <= fetch;
				when i      => CurrState <= fetch;
				when o      => CurrState <= fetch;
				when add    => CurrState <= fetch;
				when adc    => CurrState <= fetch;
				when sub    => CurrState <= fetch;
				when e      => CurrState <= fetch;
				when ou     => CurrState <= fetch;
				when shl    => CurrState <= fetch;
				when shr    => CurrState <= fetch;
				when inc    => CurrState <= fetch;
				when dec    => CurrState <= fetch;
				when cmp    => CurrState <= fetch;
				when call   => CurrState <= fetch;
				when ret    => CurrState <= fetch;
				when jmp    => CurrState <= hold;
				when jz     => CurrState <= hold;
				when jn     => CurrState <= hold;
				when brch   => CurrState <= hold;
				when breq   => CurrState <= hold;
				when brlo   => CurrState <= hold;
				when hold   => CurrState <= fetch;
			end case;
		end if;
	end process;
	
	comb : process (CurrState) is
		variable A, B : std_logic_vector(1 downto 0);
	begin
		ld_0     <= '0';
		ld_1     <= '0';
		ld_2     <= '0';
		ld_3     <= '0';
		ld_flags <= '0';
		mem_rw   <= '0';
		ld_stk   <= '0';
		ld_in    <= '0';
		ld_out   <= '0';
		ld_pc    <= '0';
		cnt_pc   <= '0';
		sum_pc   <= '0';
		clr_pc   <= '0';
		ld_ir    <= '0';
		case CurrState is
			when init =>
				clr_pc <= '1';
			when fetch =>
				ld_ir <= '1';
				cnt_pc <= '1';
			when mv =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "100";
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
			when ld =>
				A := ins(10 downto 9);
				src_r <= "010";
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
			when st =>
				B := ins(10 downto 9);
				sel_b <= B;
				mem_rw <= '1';
			when mvi =>
				A := ins(10 downto 9);
				src_r <= "011";
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
			when i =>
				ld_in <= '1';
				A := ins(10 downto 9);
				src_r <= "001";
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
			when o =>
				B := ins(10 downto 9);
				ld_out <= '1';
				sel_b <= B;
			when add =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0000";
			when adc =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0001";
			when sub =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0010";
			when e =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0011";
			when ou =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0100";
			when shl =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0101";
			when shr =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0110";
			when inc => 
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "0111";
			when dec =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				src_r <= "000";
				sel_a <= A;
				sel_b <= B;
				if (A = "00") then
					ld_0 <= '1';
				elsif (A = "01") then
					ld_1 <= '1';
				elsif (A = "10") then
					ld_2 <= '1';
				elsif (A = "11") then
					ld_3 <= '1';
				end if;
				ld_flags <= '1';
				ula_op <= "1000";
			when cmp =>
				A := ins(10 downto 9);
				B := ins(8 downto 7);
				sel_a <= A;
				sel_b <= B;
				ld_flags <= '1';
				ula_op <= "0010";
			when call =>
				ld_stk <= '1';
				ld_pc <= '1';
				src_pc <= '0';
			when ret =>
				ld_pc <= '1';
				src_pc <= '1';
			when jmp =>
				ld_pc <= '1';
				src_pc <= '0';
			when jz =>
				ld_pc <= z;
				src_pc <= '0';
			when jn =>
				ld_pc <= n;
				src_pc <= '0';
			when brch =>
				sum_pc <= '1';
				src_pc <= '0';
			when breq =>
				sum_pc <= z;
				src_pc <= '0';
			when brlo =>
				sum_pc <= n;
				src_pc <= '0';
			when decode =>
			when hold =>
		end case;
	end process;
end beh;
--------------------------------------------------------------------------------
