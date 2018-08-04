library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;


package logical_pkg is

    subtype logical_t is std_logic_vector(WORD_SIZE - 1 downto 0);
    constant ZERO : logical_t := (others => '0');

    component logical is
        port
        (
            op        : in op_t;
            operand_b : in logical_t;
            operand_c : in logical_t;

            result_a  : out logical_t
        );
    end component logical;

end package logical_pkg;
