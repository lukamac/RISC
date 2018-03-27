library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity regset_tb is
end regset_tb;
 
architecture behavior of regset_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component regset
    port(
         clk : in  std_logic;
         we  : in  std_logic;
         a   : in  std_logic_vector(4 downto 0);
         b   : in  std_logic_vector(4 downto 0);
         c   : in  std_logic_vector(4 downto 0);
         dic : in  std_logic_vector(31 downto 0);
         doa : out  std_logic_vector(31 downto 0);
         dob : out  std_logic_vector(31 downto 0)
        );
    end component;
    
   --Inputs
   signal clk : std_logic := '0';
   signal we : std_logic := '0';
   signal a : std_logic_vector(4 downto 0) := (others => '0');
   signal b : std_logic_vector(4 downto 0) := (others => '0');
   signal c : std_logic_vector(4 downto 0) := (others => '0');
   signal dic : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal doa : std_logic_vector(31 downto 0);
   signal dob : std_logic_vector(31 downto 0);

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
          dic => dic,
          doa => doa,
          dob => dob
        );

   -- Clock process definitions
	clk <= not clk after clk_period/2;

   -- Stimulus process
   stim_proc: process
   begin
	
		a <= "00111"; -- register r7
		b <= "01000"; -- register r8
		c <= "01001"; -- register r9
		dic <= X"1234ABCD"; -- data to be written to register c
		we <= '1'; -- write enable
		
		wait for clk_period;
		
		we <= '0'; -- write enable
		a <= "01001"; -- register r9
		b <= "01000"; -- register r8
		c <= "01000"; -- register r8
		dic <= X"DEF12345"; -- data to be written to register c
		
		wait for clk_period;
		
		we <= '1';
		
		wait for clk_period;
		
		we <= '0';
		
		wait for clk_period;
		
		we <= '1';
		a <= "01001"; -- register r9
		c <= "01001"; -- register r9
		dic <= X"00120034"; -- data to be written to register c
		
		wait for clk_period;
		
		we <= '0';
		
		wait;
		
   end process;
end;
