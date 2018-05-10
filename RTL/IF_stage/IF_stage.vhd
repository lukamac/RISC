library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.RISC_const_and_types.all;

entity IF_stage is
	port(
		-- clock and reset
		clk				: in std_logic;
		rst				: in std_logic;
		
		-- Memory interface
		instr_addr 		: out address_t;
		instr_data		: in word_t;
		
		-- PC multiplexer inputs
		pc_alu_res_in  : in word_t;
		
		-- PC multiplexer control signal
		ctrl_pc_in_mux	: in std_logic;
		
		-- IF stage outputs
		pc_out			: out address_t;
		ir_out			: out word_t
	);
	
end IF_stage;

architecture rtl of IF_stage is
	
	signal pc_reg : address_t := (others => '0'); -- Program counter register
	signal pc_add_4 : address_t := (others => '0');
	signal ir_reg : word_t := (others => '0'); -- Instruction register
	signal pc_out_reg : address_t := (others => '0'); -- PC output register
	signal pc_next : address_t := (others => '0'); -- Next value for program counter register
	
begin

	-- PC register process
	pc_reg_proc: process(clk) is
	begin
		if (rising_edge(clk)) then
			if(rst = '1') then
				pc_reg <= (others => '0');
			else
				pc_reg <= pc_next;
			end if;
		end if;
	end process pc_reg_proc;
	
	-- IR output
	ir_out <= instr_data;
	
	-- PC incrementer
	pc_add_4 <= pc_reg + 4;
	
	-- PC input mux
	with ctrl_pc_in_mux select
		pc_next <=  pc_add_4 when '0',
						pc_alu_res_in when others;
	
	-- Instruction address output
	instr_addr <= pc_reg;
	
	-- PC output
	pc_out_reg_proc: process(clk) is
	begin
		if (rising_edge(clk)) then
			if(rst = '1') then
				pc_out_reg <= (others => '0');
			else
				pc_out_reg <= pc_add_4;
			end if;
		end if;
	end process pc_out_reg_proc;

end rtl;