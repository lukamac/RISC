library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;

entity simple_data_mem is
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
end entity simple_data_mem;

architecture rtl of simple_data_mem is

	signal led_reg, led_next	: std_logic_vector(3 downto 0);
	
begin

	leds: process(clk) is
	begin
		if(rising_edge(clk)) then
			if (rst = '1') then 
				led_reg <= (others => '0');
			else
				led_reg <= led_next;
			end if;
		end if;
	end process leds;
	
	led_next <= data_in(3 downto 0) when wr = '1' else
				led_reg;
	
	data_out <= X"0000000" & led_reg;
	data_wait <= '0';
	led <= led_reg;
	
	
end architecture rtl;