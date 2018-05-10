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
            ctrl_op         : in op_t;
            b, pc           : in word_t;
            ctrl_alu_b      : in std_logic;
            c, imm          : in word_t;
            ctfl_alu_c      : in std_logic;

            alu_res, mdr_out    : out word_t
        );
    end component EX_stage;

    signal clk, rst : std_logic;
    signal ctrl_op : op_t;
    signal imm, b, c, pc, alu_res, mdr_out : word_t;
    signal ctrl_alu_b, ctrl_alu_c : std_logic;

    constant t_clk  : time := 10  ns;
    constant t_wait : time := 100 ns;

begin

    uut : component EX_stage port map (clk        => clk,
                                       rst        => rst,
                                       ctrl_op    => ctrl_op,
                                       imm        => imm,
                                       b          => b,
                                       c          => c,
                                       pc         => pc,
                                       alu_res    => alu_res,
                                       ctrl_alu_b => ctrl_alu_b,
                                       ctrl_alu_c => ctrl_alu_c,
                                       mdr_out    => mdr_out
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
        
        ctrl_alu_b <= '0';
        ctrl_alu_c <= '0';
        pc <= (others => '0');
        imm <= (others => '0');
        ctrl_op <= ADD_OP;
        b <= X"00000004";
        c <= X"00000003";
        wait for t_wait;

        ctrl_op <= SUB_OP;
        wait for t_wait;
        
        ctrl_op <= OR_OP;
        wait for t_wait;

        ctrl_op <= AND_OP;
        wait;
    end process stimulus;
    
end architecture beh;
