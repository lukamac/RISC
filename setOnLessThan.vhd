library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity setOnLessThan is

	generic(
	g_numBits : integer:=6);

	port(
		a,b	:	in	std_logic_vector(g_numBits - 1 downto 0);
		z	:	out	std_logic;
		s	:	out	std_logic
		
	);
	
end setOnLessThan;

architecture behavioral of setOnLessThan is

begin

	s <= '1' when unsigned(a)<unsigned(b) else
		  '0';
	z <= '1' when a=b else '0';
	
end behavioral;