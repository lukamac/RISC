library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity notAnd is

	generic(
	g_numBits : integer:=6);

	port(
		a,b	:	in		std_logic_vector(g_numBits - 1 downto 0);
		s		:	out	std_logic_vector(g_numBits - 1 downto 0)
	);
	
end notAnd;

architecture behavioral of notAnd is

begin

	s <= a nand b;

end behavioral;