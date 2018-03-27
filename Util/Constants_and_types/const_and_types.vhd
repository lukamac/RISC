library ieee;
use ieee.std_logic_1164.all;

package RISC_const_and_types is
    
    constant WORD_SIZE : integer := 32;
    subtype word_t is std_logic_vector(WORD_SIZE - 1 downto 0);

    constant OP_SIZE : integer := 5;
    subtype op_t : std_logic_vector(OP_SIZE - 1 downto 0);

end package RISC_const_and_types;
