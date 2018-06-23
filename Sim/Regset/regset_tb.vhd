library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity regset_tb is
end regset_tb;

library work;
use work.RISC_const_and_types.all;
 
architecture behavior of regset_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component regset
    port(
            clk : in std_logic; -- Clock
            we  : in std_logic; -- Write enable for input port C
			a   : in reg_address_t; -- Address for output port A
			b   : in reg_address_t; -- Address for output port B
			c   : in reg_address_t; -- Address for input port C
			dob : out word_t; -- Data output for port B
			doc : out word_t; -- Data output for port C
			dia : in word_t -- Data input for port A
        );
    end component;
    
   --Inputs
   signal clk : std_logic := '0';
   signal we : std_logic := '0';
   signal a : reg_address_t := (others => '0');
   signal b : reg_address_t := (others => '0');
   signal c : reg_address_t := (others => '0');
   signal dia : word_t := (others => '0');

 	--Outputs
   signal dob : word_t;
   signal doc : word_t;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: regset port map (
          clk => clk,
          we => we,
          a => a,
          b => b,
          c => c,
          dob => dob,
          doc => doc,
          dia => dia
        );

   -- Clock process definitions
	clk <= not clk after clk_period/2;

   -- Stimulus process
   stim_proc: process
   begin
	
		a <= "00111"; -- register r7
		b <= "01000"; -- register r8
		c <= "01001"; -- register r9
		dia <= X"1234ABCD"; -- data to be written to register a
		we <= '1'; -- write enable
		
		wait for clk_period;
		
		we <= '0'; -- write enable
		a <= "01001"; -- register r9
		b <= "00111"; -- register r7
		c <= "01000"; -- register r8
		dia <= X"DEF12345"; -- data to be written to register a
		
		wait for clk_period;
		
		we <= '1';
		
		wait for clk_period;
		
		we <= '0';
		
		wait for clk_period;
		
		we <= '1';
		a <= "01001"; -- register r9
		c <= "01001"; -- register r9
		dia <= X"00120034"; -- data to be written to register a
		
		wait for clk_period;
		
		we <= '0';
		
		wait;
		
   end process;
end;
