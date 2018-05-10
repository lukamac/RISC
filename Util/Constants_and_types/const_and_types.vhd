library ieee;
use ieee.std_logic_1164.all;

package RISC_const_and_types is
    
    constant WORD_SIZE : integer := 32;
    subtype word_t is std_logic_vector(WORD_SIZE - 1 downto 0);
	
	constant ADDRESS_SIZE : integer := 32;
	subtype address_t is std_logic_vector(ADDRESS_SIZE - 1 downto 0);

    constant OP_SIZE : integer := 5;
    subtype op_t is std_logic_vector(OP_SIZE - 1 downto 0);

    constant IMMEDIATE_SIZE : integer := 17;
    subtype immedate_t is std_logic_vector(IMMEDIATE_SIZE - 1 downto 0);

    constant SHIFT_AMOUNT_SIZE : integer := 5;
    subtype s_amount_t is std_logic_vector(SHIFT_AMOUNT_SIZE - 1 downto 0);

end package RISC_const_and_types;
