library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is

	generic(
	g_numBits : integer:=6);

	port(
		a,b	:	in		std_logic_vector(g_numBits - 1 downto 0);
		sign	:	in		std_logic;
		p		:	out	std_logic_vector(g_numBits - 1 downto 0);
		ov		:	out	std_logic
	);
	
end multiplier;

architecture behavioral of multiplier is


	signal product : std_logic_vector(2*g_numBits - 1 downto 0); 
	signal ones	 : std_logic_vector(2*g_numBits  downto g_numBits);
	signal zeroes	 : std_logic_vector(2*g_numBits  downto g_numBits);
begin
	

	product <= std_logic_vector(unsigned(a)*unsigned(b)) when sign = '1' else
					std_logic_vector(signed(a)*signed(b));
					
	ones <= (others => '1');
	zeroes <= (others => '0');
	

		
	p <= product(g_numBits - 1 downto 0);
	
	ov <= '0' when product(2*g_numBits -1 downto g_numBits-1) = ones or product(2*g_numBits -1 downto g_numBits-1) = zeroes else
			'1';
	
end behavioral;