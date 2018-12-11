---------------------------------File ula.vhd-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity ula is
port (
	a, b 		: in 		std_logic_vector(7 downto 0);
	ula_op 	: in 		std_logic_vector(3 downto 0);
	y 			: out 	std_logic_vector(7 downto 0);
	c, z, n 	: buffer std_logic
);
end ula;
--------------------------------------------------------------------------------
architecture beh of ula is
begin
	process(a, b, ula_op) is
		variable ans 			: std_logic_vector(8 downto 0);
		variable anew, bnew 	: std_logic_vector(8 downto 0);
	begin
		anew := "0" & a;
		bnew := "0" & b;
		case ula_op is
			when "0000" => ans := std_logic_vector(signed(anew) + signed(bnew));
			when "0001" => if (c = '1') then
									ans := std_logic_vector(signed(anew) + signed(bnew) + 1);
								else
									ans := std_logic_vector(signed(anew) + signed(bnew));
								end if;
			when "0010" => ans := std_logic_vector(signed(anew) - signed(bnew));
			when "0011" => ans := anew and bnew;
			when "0100" => ans := anew or bnew;
			when "0101" => ans := std_logic_vector(shift_left(unsigned(anew), 1));
			when "0110" => ans := std_logic_vector(shift_right(unsigned(anew), 1));
			when "0111" => ans := std_logic_vector(signed(anew) + 1);
			when "1000" => ans := std_logic_vector(signed(anew) - 1);
			when others => ans := "000000000";
		end case;
		if (signed(ans) = 0) then
			z <= '1';
		else
			z <= '0';
		end if;
		if (signed(ans) < 0) then
			n <= '1';
		else
			n <= '0';
		end if;
		c <= ans(8);
		y <= ans(7 downto 0);
	end process;
end beh;
--------------------------------------------------------------------------------