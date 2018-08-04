library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;


package arithmetic_pkg is

    subtype arithmetic_t is signed(WORD_SIZE - 1 downto 0);
    constant ZERO : arithmetic_t := (others => '0');

    component arithmetic is
        port
        (
            op        : in op_t;
            operand_b : in arithmetic_t;
            operand_c : in arithmetic_t;

            result_a  : out arithmetic_t
        );
    end component arithmetic;

end package arithmetic_pkg;
