
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY IF_stage_tb IS
END IF_stage_tb;
 
ARCHITECTURE behavior OF IF_stage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IF_stage
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         instr_addr : OUT  std_logic_vector(31 downto 0);
         instr_data : IN  std_logic_vector(31 downto 0);
         pc_alu_res_in : IN  std_logic_vector(31 downto 0);
         ctrl_pc_in_mux : IN  std_logic;
         pc_out : OUT  std_logic_vector(31 downto 0);
         ir_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr_data : std_logic_vector(31 downto 0) := (others => '0');
   signal pc_alu_res_in : std_logic_vector(31 downto 0) := (others => '0');
   signal ctrl_pc_in_mux : std_logic := '0';

 	--Outputs
   signal instr_addr : std_logic_vector(31 downto 0);
   signal pc_out : std_logic_vector(31 downto 0);
   signal ir_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IF_stage PORT MAP (
          clk => clk,
          rst => rst,
          instr_addr => instr_addr,
          instr_data => instr_data,
          pc_alu_res_in => pc_alu_res_in,
          ctrl_pc_in_mux => ctrl_pc_in_mux,
          pc_out => pc_out,
          ir_out => ir_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for 100 ns;	
		rst <='0';
      ctrl_pc_in_mux <= '0'; -- PC in is PC + 4

      wait;
   end process;

END;
