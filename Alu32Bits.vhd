-- Alu32Bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Alu32Bits is
generic(
	g_numBits : integer:=6);
port(
	a,b		:	in	std_logic_vector(g_numBits - 1 downto 0);
	op_alu  :in std_logic_vector(3 downto 0);
	sol		:  out	std_logic_vector(g_numBits - 1 downto 0);
	OV      : out std_logic;
	z: out std_logic;
	co: out std_logic);
end Alu32Bits;

architecture structural of Alu32Bits is


signal sadd,smult,snand,sdisp,scomp,outaux,zeros: std_logic_vector(g_numBits - 1 downto 0):="000000";
signal coadd,ovadd,ovmult,aux,zbis: std_logic;

component setOnLessThan is
	generic(
	g_numBits : integer:=6);
	port(
		a,b	:	in	std_logic_vector(g_numBits - 1 downto 0);
		z   :	out	std_logic;
		s	:	out	std_logic
	);
end component;
	
component notAnd is
	generic(
	g_numBits : integer:=6);
	port(
		a,b	:	in		std_logic_vector(g_numBits - 1 downto 0);
		s		:	out	std_logic_vector(g_numBits - 1 downto 0)
	);	
end component;

component multiplier is
	generic(
	g_numBits : integer:=6);
	port(
		a,b	:	in		std_logic_vector(g_numBits - 1 downto 0);
		sign	:	in		std_logic;
		p		:	out	std_logic_vector(g_numBits - 1 downto 0);
		ov		:	out	std_logic
	);
end component;

component Adder is
	generic(
		g_numBits: integer:=6);
	port(
		a,b: in std_logic_vector(g_numBits-1 downto 0);
		add_sub : in std_logic;
		s: out std_logic_vector(g_numBits-1 downto 0);
		OV: out std_logic;
		co: out std_logic);
end component;

component Displacer is
	generic(
		g_numBits: integer:=6);
	port(
			a: in std_logic_vector(g_numBits-1 downto 0);
			left_right, sig_unsig : in std_logic; --0 Left, 1 Right     0 Sig  1 Unsig
			s: out std_logic_vector(g_numBits-1 downto 0));
end component;

component MultiplexVectors is
generic(
		g_numBits: integer:=6);
port(
	mult,add,disp,comp,opNand : in std_logic_vector(g_numBits-1 downto 0);
	sel:in std_logic_vector(3 downto 0);
	output: out std_logic_vector(g_numBits-1 downto 0));
end component;

component Multiplexer is

port(
	mult,add,disp,comp,opNand : in std_logic;
	sel:in std_logic_vector(3 downto 0);
	output: out std_logic);
end component;

begin
	i1: SetOnLessThan
	port map(
		a=>a,
		b=>b,
		z=>zbis,
		s=>scomp(g_numBits-1)
	);

	
	i2:notAnd
	port map(
	a=>a,
	b=>b,
	s=>snand);
	
	i3:multiplier
	port map(
		a=>a,
		b=>b,
		sign	=>op_alu(0),
		p		=>smult,
		ov		=>ovmult);
		
	i4:Adder
	port map(
		a=>a,
		b=>b,
		add_sub=>aux,
		s=>sadd,
		OV=>ovadd,
		co=>coadd);

	aux<=op_alu(0) or op_alu(3);
	
	i5: Displacer
	port map(
		a=>a,
		left_right=>op_alu(1),
		sig_unsig=>op_alu(0),
		s=>sdisp);
	
	i6:MultiplexVectors
	port map(
		mult=>smult,
		add=>sadd,
		disp=>sdisp,
		comp=>scomp,
		opNand=>snand,
		sel=>op_alu,
		output=>outaux);
		
	i7:Multiplexer
	port map(
		mult=>ovmult,
		add=>ovadd,
		disp=>'0',
		comp=>'0',
		opNand=>'0',
		sel=>op_alu,
		output=>OV);
		
	i8:Multiplexer
	port map(
		mult=>'0',
		add=>coadd,
		disp=>'0',
		comp=>'0',
		opNand=>'0',
		sel=>op_alu,
		output=>co);
		
		zeros<=(others=>'0');
		sol<=outaux;
		z<='1' when (outaux=zeros and op_alu/="1000") OR (zbis='1' and op_alu="1000") else '0' ;
		
end structural;
