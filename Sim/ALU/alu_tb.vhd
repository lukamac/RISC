library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.op_codes.all;
use work.RISC_const_and_types.all;


entity alu_tb is
end entity alu_tb;

architecture beh of alu_tb is

    component alu is
        port
        (
            op  : in op_t;
            b, c: in word_t;

            a   : out word_t
        );
    end component alu;

    signal b, c : word_t;
    signal op   : op_t;
    signal a    : word_t;

    constant wait_t : time := 50 ns;
begin

    uut : component alu port map (op    => op,
                                  b     => b,
                                  c     => c,
                                  a     => a);

    stimulus: process is
    begin
        b <= (others => '0');
        c <= (others => '0');
        op <= NOT_OP;
        wait for wait_t;

        b <= X"00000001";
        c <= X"00000003";
        op <= ADD_OP;
        wait for wait_t;

        op <= SUB_OP;
        wait for wait_t;

        op <= NOT_OP;
        wait for wait_t;

        op <= NEG_OP;
        wait for wait_t;

        op <= OR_OP;
        wait for wait_t;

        b <= X"0000FF36";
        c <= X"00003C11";
        op <= AND_OP;
        wait for wait_t;

        b <= X"FF000004";
        c <= X"00000004";
        op <= SHR_OP;
        wait for wait_t;

        op <= SHRA_OP;
        wait for wait_t;

        op <= SHC_OP;
        wait for wait_t;

        op <= SHL_OP;
        wait;
    end process stimulus;

end architecture beh;
