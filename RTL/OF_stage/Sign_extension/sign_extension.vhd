library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RISC_const_and_types.all;

ENTITY sign_extension IS
    PORT (
	    d_in  : in  immediate_t;
	    d_out : out word_t
	);
END sign_extension;

ARCHITECTURE rtl OF sign_extension IS 
BEGIN	
	d_out (16 downto 0) <= d_in;
	d_out (31 downto 17) <= (others => d_in(16));		
END rtl;
