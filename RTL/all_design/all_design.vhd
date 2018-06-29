library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RISC_const_and_types.all;


entity all_design is
	port (
		clk : in std_logic;
		rst : in std_logic;
		led : out std_logic_vector(3 downto 0);
		rgb : out std_logic_vector(1 downto 0);
		btn : in std_logic
		 );
end all_design;

architecture rtl of all_design is

	component risc_top is
    port(
       clk         : in std_logic;
       rst         : in std_logic;
       
       -- instruction memory interface
       instr_addr  : out address_t;
       instr_data  : in word_t;
       wait_instr  : in std_logic;
       
       -- data memory interface
       data_addr   : out address_t;
       data_out    : out word_t;
       data_in     : in word_t;
       data_rd     : out std_logic;
       data_wr     : out std_logic;
       wait_data   : in std_logic
    );
	end component risc_top;
	
	component simple_instr_mem is
	    port
	    (
	        rst, clk   : in std_logic;
	
	        btn        : in std_logic;
	
	        instr_addr : in address_t;
	
	        instr_wait : out std_logic;
	        instr_data : out word_t
	    );
	end component simple_instr_mem;
	
	component simple_data_mem is
	    port
	    (
	    	clk   		: in std_logic;
	        rst 		: in std_logic;
	
	
	        addr 		: in address_t;
	        
	        rd			: in std_logic;
	        wr			: in std_logic;
	
	        data_wait 	: out std_logic;
	        data_in 	: in word_t;
	        data_out    : out word_t;
	        led			: out std_logic_vector(3 downto 0)
	    );
	end component simple_data_mem;
	
	signal instr_addr, data_addr : address_t;
	signal instr_data, data_in, data_out : word_t;
	signal wait_instr, wait_data, data_rd, data_wr : std_logic;

begin
	
	risc: risc_top port map(
		clk => clk,
	    rst => rst,
	    instr_addr => instr_addr,
	    instr_data => instr_data,
	    wait_instr => wait_instr,
	    data_addr => data_addr,
	    data_out => data_out,
	    data_in => data_in, 
	    data_rd => data_rd,
	    data_wr => data_wr,
	    wait_data => wait_data
	);
	instr: simple_instr_mem port map (
		clk => clk,
		rst => rst,
		btn => btn,
		instr_addr => instr_addr,
		instr_wait => wait_instr,
		instr_data => instr_data
	);
	data: simple_data_mem port map(
		clk => clk,
		rst => rst,
		addr => data_addr,
		rd => data_rd,
		wr => data_wr,
		data_wait => wait_data,
		data_in => data_out,
		data_out => data_in,
		led => led	
	);
	
	rgb(0) <= rst;
	rgb(1) <= wait_instr;
	
end rtl;
