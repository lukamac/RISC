library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity all_design_tb is
end all_design_tb;

architecture Behavioral of all_design_tb is

	component all_design is
	port (
		clk : in std_logic;
		rst : in std_logic;
		led : out std_logic_vector(3 downto 0);
		rgb : out std_logic_vector(1 downto 0);
		btn : in std_logic
		 );
	end component all_design;
	
	signal clk, rst : std_logic := '0';
	signal led : std_logic_vector(3 downto 0);
	signal rgb : std_logic_vector(1 downto 0);
	signal btn : std_logic := '0';
	
	constant t_clk : time := 8 ns;
	
begin

	uut: all_design port map(
		clk => clk,
		rst => rst,
		led => led,
		rgb => rgb,
		btn => btn
	);
	
	rst <= '1', '0' after 10 * t_clk;
	clk <= not clk after t_clk/2;
	btn <= not btn after 400 ns;

	stimulus: process is
	begin
		wait until rst = '0';
		
		
		
		wait;
	end process stimulus;

end Behavioral;
