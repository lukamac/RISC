library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MultiplexVectors is
generic(
		g_numBits: integer:=6);
port(
	mult,add,disp,comp,opNand 	: in std_logic_vector(g_numBits-1 downto 0);
	sel								: in std_logic_vector(3 downto 0);
	output							: out std_logic_vector(g_numBits-1 downto 0));
end MultiplexVectors;

architecture structural of MultiplexVectors is
signal aux1,aux2:std_logic_vector(g_numBits-1 downto 0);
begin
	aux1<=(others=>'0');
	aux2<=(0=>'1', others=>'0');
	
	output	<=  add when (sel(3 downto 0)="0000" or sel(3 downto 0)="0001") else
				mult when (sel(3 downto 0)="0010" or sel(3 downto 0)="0011")else 
				opNand when sel(3 downto 0)="0100" else
				disp when (sel(3 downto 0)="0101" or sel(3 downto 0)="0110" or sel(3 downto 0)="0111") else
				aux1 when sel(3 downto 0)="1000" and comp(g_numBits-1)='0' else
				aux2 when sel(3 downto 0)="1000" and comp(g_numBits-1)='1' else
				aux1;
				
end structural;