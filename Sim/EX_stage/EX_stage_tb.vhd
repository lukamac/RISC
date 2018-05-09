library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity EX_stage_tb is
end entity EX_stage_tb;


architecture beh of EX_stage_tb is

    component EX_stage is
        port
        (
            clk, rst        : in std_logic;
            op              : in op_t;
            imm, b, c, pc   : in word_t;

            alu_res, mdr_out    : out word_t
        );
    end component EX_stage;

    signal clk, rst : std_logic;
    signal op : op_t;
    signal imm, b, c, pc, alu_res, mdr_out : word_t;

    constant t_clk  : time := 10  ns;
    constant t_wait : time := 100 ns;

begin

    uut : component EX_stage port map (clk      => clk,
                                       rst      => rst,
                                       op       => op,
                                       imm      => imm,
                                       b        => b,
                                       c        => c,
                                       pc       => pc,
                                       alu_res  => alu_res,
                                       mdr_out  => mdr_out
                                      );

    clk_p : process is
    begin
        clk <= '0';
        wait for t_clk / 2;
        clk <= '1';
        wait for t_clk / 2;
    end process clk_p;

    stimulus : process is
    begin
        rst <= '0';

        pc <= (others => '0');
        imm <= (others => '0');
        op <= ADD_OP;
        b <= X"00000004";
        c <= X"00000003";
        wait for t_wait;

        op <= SUB_OP;
        wait for t_wait;
        
        op <= OR_OP;
        wait;

        op <= AND_OP;
        wait;
    end process stimulus;
    
end architecture beh;
