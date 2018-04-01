library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Displacer is
	generic(
		g_numBits: integer:=6);
	port(
			a: in std_logic_vector(g_numBits-1 downto 0);
			left_right, sig_unsig : in std_logic; --0 Left, 1 Right     0 Sig  1 Unsig
			s: out std_logic_vector(g_numBits-1 downto 0));
end Displacer;

	
architecture structural of Displacer is 

begin

	process(left_right,a,sig_unsig)
	begin
		if left_right='0' then
			s(g_numBits-1 downto 1)<=a(g_numBits-2 downto 0);
			s(0)<='0';
		else
			s(g_numBits-2 downto 0)<=a(g_numBits-1 downto 1);
			if sig_unsig='0' then
				s(g_numBits-1)<=a(g_numBits-1);
			else	
				s(g_numBits-1)<='0';
			end if;
		end if;
	end process;
	
end structural;