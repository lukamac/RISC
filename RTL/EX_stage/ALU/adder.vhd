library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;

subtype arithmetic_t is signed(31 downto 0);
constant ZERO_ARITHMETIC : arithmetic_t := (others=>'0');


entity adder is
    port
    (
        op        : in op_t;
        operand_b : in arithmetic_t;
        operand_c : in arithmetic_t;

        result_a  : out arithmetic_t
    );
end entity adder;

architecture functional of adder is

begin

    -- TODO
    -- Try to optimize with using only one adder.
    -- See performance vs. size after synthesis.

    process (op, operand_b, operand_c) is
    begin
        case (op) is
            when
            ADD_OP | ADDI_OP |
            LA_OP  | LD_OP   |
            ST_OP
            =>
                result_a <= operand_b + operand_c;
            when
            SUB_OP | SUBI_OP
            =>
                result_a <= operand_b - operand_c;
            when
            NEG_OP
            =>
                result_a <= -operand_c;
            when
            others
            =>
                result_a <= ZERO_ARITHMETIC;
        end case;
    end process;

end architecture rtl;
