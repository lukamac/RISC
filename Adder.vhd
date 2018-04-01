library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
	generic(
		g_numBits: integer:=6);
	port(
		a,b: in std_logic_vector(g_numBits-1 downto 0);
		add_sub : in std_logic;
		s: out std_logic_vector(g_numBits-1 downto 0);
		OV: out std_logic;
		co: out std_logic);
end Adder;

architecture structural of Adder is 
	signal notb: std_logic_vector(g_numBits-1 downto 0);
	signal s_inter: std_logic_vector(g_numBits+1 downto 0);
begin

	notb<=not b when add_sub='1' else b;
	
	s_inter<=std_logic_vector(unsigned('0'& a &add_sub)+unsigned('0'&notb&add_sub));  
		
	OV<='1' when add_sub='0' and a(g_numBits-1)=b(g_numBits-1) and a(g_numBits-1)/= s_inter(g_numBits) else
		'1' when add-sub='1' and s_inter(g_numBits+1)/=s_inter(g_numBits)
		 else '0';
		 
	s<=s_inter(g_numBits downto 1);
	co<=s_inter(g_numBits);
	
end structural;
	