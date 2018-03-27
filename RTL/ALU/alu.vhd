library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISC_const_and_types.all;
use work.OP_CODES.all;



entity alu is
    port
    (
        op      : in op_t;
        a       : in word_t;
        b       : in word_t;
        res     : out word_t;
    );
end entity alu;

architecture rtl of alu is

    signal adder_a, adder_b : signed(word_t'range);
    signal not_b : word_t;

    signal state_reg, state_next : word_t;

begin

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                state_reg <= (others => '0');
            else
                state_reg <= state_next;
            end if;
        end if;
    end;

    alu_execution: process (op, a, b) is
    begin
        adder_a <= a;
        adder_b <= b;
        res <= adder;
        case (op) is
            when ADD =>
            when SUB =>
                adder_b <= (signed(not_b) + 1);
            when ADDI =>
        end case;
    end process;

    not_b <= not b;

    adder <= adder_a + adder_b;

end architecture alu;
