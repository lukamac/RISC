library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISC_const_and_types.all;
use work.OP_CODES.all;



entity alu is
    port
    (
        op      : in op_t;
        reg_a   : in word_t;
        reg_b   : in word_t;
        res     : out word_t;
    );
end entity alu;

architecture rtl of alu is

    signal adder_a, adder_b : signed(word_t'range);

begin

    alu_execution: process (op, reg_a, reg_b) is
    begin
        adder_a <= reg_a;
        adder_b <= reg_b;
        case (op) is
            when ADD =>
            when SUB =>
                adder_b <= (not reg_b + 1);
        end case;
    end process;

    adder <= adder_a + adder_b;

end architecture alu;
