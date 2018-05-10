library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RISC_const_and_type.ALL;

ENTITY sign_extension IS
    PORT (
	    d_in  : IN  IMMEDIATE_T;
	    d_out : OUT WORD_T
	);
END sign_extension;

ARCHITECTURE rtl OF sign_extension IS 
BEGIN	
	d_out (16 DOWNTO 0) <= d_in;
	d_out (31 DOWNTO 17) <= (OTHERS => d_in(16));		
END rtl;
