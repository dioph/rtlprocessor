-----------------------File micro.vhd (actual project)--------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity micro is
port (
	clk, rst     : in 	std_logic;
	input 	    : in 	std_logic_vector(7 downto 0);
	output 	    : out   std_logic_vector(7 downto 0);
	
	---DEBUG---
	disp_number_dez : out std_logic_vector(6 downto 0);
	disp_number_und : out std_logic_vector(6 downto 0);
	ins_debug       : out std_logic_vector(15 downto 0);
	y               : out std_logic_vector(7 downto 0)
);
end micro;
--------------------------------------------------------------------------------
architecture struct of micro is
    ----------------------------------------
	component datapath is
	port (
		clk                     :   in      std_logic;
		ins			            :   buffer  std_logic_vector(15 downto 0);
		c, z, n		            :   out     std_logic;
      src_r                   :   in	   std_logic_vector(2 downto 0);
		ula_op 		            :   in	   std_logic_vector(3 downto 0);
		sel_a, sel_b            :   in 	   std_logic_vector(1 downto 0);
		ld_0, ld_1, ld_2, ld_3  :   in      std_logic;
		ld_flags, mem_rw, ld_stk:   in      std_logic;
		ld_in, ld_out, ld_pc    :   in      std_logic;
		cnt_pc, sum_pc, clr_pc  :   in      std_logic;
		src_pc, ld_ir           :   in      std_logic;
				
		input 		            :   in		std_logic_vector(7 downto 0);
		output                  :   out		std_logic_vector(7 downto 0);
		
		---DEBUG---
		pc_out	 : buffer std_logic_vector(7 downto 0);
		y		    : buffer std_logic_vector(7 downto 0)
	);
	end component;
    ----------------------------------------
	component ctrl is
	port (
		clk, rst		        		:   in	    std_logic;
		ins 			        		:   in	    std_logic_vector(15 downto 0);
		c, z, n 		        		:   in	    std_logic;
		src_r 		            :   out	    std_logic_vector(2 downto 0);
		ula_op 		            :   out	    std_logic_vector(3 downto 0);
		sel_a, sel_b            :   out	    std_logic_vector(1 downto 0);
		ld_0, ld_1, ld_2, ld_3  :   out      std_logic;
		ld_flags, mem_rw, ld_stk:   out      std_logic;
		ld_in, ld_out, ld_pc    :   out      std_logic;
		cnt_pc, sum_pc, clr_pc  :   out      std_logic;
		src_pc, ld_ir 		    	:   out      std_logic
	);
	end component;
	----------------------------------------
	signal ins				        	  :   std_logic_vector(15 downto 0);
	signal c, z, n			        	  :   std_logic;
	signal src_r 			        	  :   std_logic_vector(2 downto 0);
	signal ula_op 			        	  :   std_logic_vector(3 downto 0);
	signal sel_a, sel_b	           :   std_logic_vector(1 downto 0);
	signal ld_0, ld_1, ld_2, ld_3   :   std_logic;
	signal ld_flags, mem_rw, ld_stk :   std_logic;
	signal ld_in, ld_out, ld_pc     :   std_logic;
	signal cnt_pc, sum_pc, clr_pc   :   std_logic;
	signal src_pc, ld_ir            :   std_logic;
	---CLOCK DIVIDER---
	signal count                    :   integer range 0 to 50000000 := 1;
	signal clk_d                    :   std_logic := '0';
	constant terminal_count         :   integer := 5;
	---DEBUG---
	signal pc_out                   :   std_logic_vector(7 downto 0);

begin
	ct : ctrl port map(clk_d, rst, ins, c, z, n, src_r, ula_op, sel_a, sel_b,
						ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
						ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir);
	dt : datapath port map(clk_d, ins, c, z, n, src_r, ula_op, sel_a, sel_b,
						ld_0, ld_1, ld_2, ld_3, ld_flags, mem_rw, ld_stk, ld_in,
						ld_out, ld_pc, cnt_pc, sum_pc, clr_pc, src_pc, ld_ir,
						input, output, pc_out, y);
						
	clk_div : process(clk)
	begin
		if (clk = '1' and clk'event) then
			count <= count + 1;
			if (count >= terminal_count) then
				count <= 1;
				clk_d <= not (clk_d);
			end if;
		end if;
	end process clk_div;
	
	---DEBUG---
	ins_debug <= ins;
	
	number_to_segments : process(pc_out)
		variable number						: integer;
		variable number_dez, number_und	: integer;
	begin
		number 		:= to_integer(unsigned(pc_out));
		number_dez 	:= number / 10;
		number_und 	:= number mod 10;
		case number_dez is
			when 0 		=> disp_number_dez <= "0000001"; 
			when 1 		=> disp_number_dez <= "1001111";  
			when 2 		=> disp_number_dez <= "0010010";  
			when 3 		=> disp_number_dez <= "0000110";  
			when 4 		=> disp_number_dez <= "1001100";  
			when 5 		=> disp_number_dez <= "0100100";  
			when 6 		=> disp_number_dez <= "0100000";  
			when 7 		=> disp_number_dez <= "0001111";  
			when 8 		=> disp_number_dez <= "0000000";      
			when 9 		=> disp_number_dez <= "0000100";
			when others => disp_number_dez <= "1111111";
		end case;
		case number_und is
			when 0 		=> disp_number_und <= "0000001"; 
			when 1 		=> disp_number_und <= "1001111";  
			when 2 		=> disp_number_und <= "0010010";  
			when 3 		=> disp_number_und <= "0000110";  
			when 4 		=> disp_number_und <= "1001100";  
			when 5 		=> disp_number_und <= "0100100";  
			when 6 		=> disp_number_und <= "0100000";  
			when 7 		=> disp_number_und <= "0001111";  
			when 8 		=> disp_number_und <= "0000000";      
			when 9 		=> disp_number_und <= "0000100"; 
			when others => disp_number_und <= "1111111";
		end case;
	end process number_to_segments;
end struct;
--------------------------------------------------------------------------------
