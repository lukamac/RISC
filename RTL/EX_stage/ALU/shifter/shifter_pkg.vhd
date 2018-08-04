library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;


package shifter_pkg is

    constant SHIFT_AMOUNT_SIZE : integer := 5;
    subtype s_amount_t is std_logic_vector(SHIFT_AMOUNT_SIZE - 1 downto 0);

    component right_tri_shifter is
        port
        (
            op      : in op_t;
            a       : in word_t;
            amt     : in s_amount_t;

            res     : out word_t
        );
    end component right_tri_shifter;

    component left_shifter is
        port
        (
            a   : in word_t;
            amt : in s_amount_t;

            res : out word_t
        );
    end component left_shifter;

end package shifter_pkg;
