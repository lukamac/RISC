library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity IF_stage is
	port(
		-- clock and reset
		clk				: in std_logic;
		rst				: in std_logic;
		
		-- Memory interface
		instr_addr 		: out std_logic_vector(31 downto 0);
		instr_data		: in std_logic_vector(31 downto 0);
		
		-- PC multiplexer inputs
		pc_alu_res_in  : in std_logic_vector(31 downto 0);
		
		-- PC multiplexer control signal
		ctrl_pc_in_mux	: in std_logic;
		
		-- IF stage outputs
		pc_out			: out std_logic_vector(31 downto 0);
		ir_out			: out std_logic_vector(31 downto 0)
	);
	
end IF_stage;

architecture rtl of IF_stage is
	
	signal pc_reg : std_logic_vector(31 downto 0) := (others => '0'); -- Program counter register
	signal pc_add_4 : std_logic_vector(31 downto 0) := (others => '0');
	signal ir_reg : std_logic_vector(31 downto 0) := (others => '0'); -- Instruction register
	signal pc_next : std_logic_vector(31 downto 0) := (others => '0'); -- Next value for program counter register
	
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
	
	-- IR register process -- we will delete this if we are 1 clock late in the next stage (that depends on memory implementation)
	ir_reg_proc: process(clk) is
	begin
		if (rising_edge(clk)) then
			if(rst = '1') then
				ir_reg <= (others => '0');
			else
				ir_reg <= instr_data;
			end if;
		end if;
	end process ir_reg_proc;
	
	-- IR output
	ir_out <= ir_reg;
	
	-- PC incrementer
	pc_add_4 <= pc_reg + 4;
	
	-- PC input mux
	with ctrl_pc_in_mux select
		pc_next <=  pc_add_4 when '0',
						pc_alu_res_in when others;
	
	-- Instruction address output
	instr_addr <= pc_reg;
	
	-- PC output
	pc_out <= pc_add_4;

end rtl;

