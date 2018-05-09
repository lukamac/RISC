library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity right_tri_shifter_tb is
end entity right_tri_shifter_tb;


architecture behavioral of right_tri_shifter_tb is
    
    component right_tri_shifter is
        port
        (
            op    : in op_t;
            a       : in word_t;
            amt     : in s_amount_t;

            res     : out word_t
        );
    end component right_tri_shifter;

    signal op : op_t;
    signal a : word_t;
    signal amt : s_amount_t;
    signal res : word_t;

    constant t : time := 20 ns;

begin

    uut : component right_tri_shifter port map (op => op,
                                                a => a,
                                                amt => amt,
                                                res => res
                                                );

    stimulus : process is
    begin
        op <= SH_OP;
        a <= X"F000_000F";
        amt <= "00111"; -- 7
        wait for t;
        op <= SHRA_OP;
        wait for t;
        op <= SHC_OP;
        wait for t;
        wait;
    end process stimulus;

end architecture behavioral;
