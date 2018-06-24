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
            b				: in word_t;
			pc_in        	: in address_t;
            ctrl_alu_b      : in std_logic;
            c, imm          : in word_t;
            ctrl_alu_c      : in std_logic;

			status			: out status_t;
			pc_out			: out address_t;
            alu_res, mdr_out    : out word_t
        );
    end component EX_stage;

    signal clk, rst : std_logic;
    signal ctrl_op : op_t;
    signal imm, b, c, alu_res, mdr_out : word_t;
	signal pc_in, pc_out : address_t;
    signal ctrl_alu_b, ctrl_alu_c : std_logic;
    signal status : status_t;

    constant t_clk  : time := 5  ns;
    constant t_wait : time := 20 ns;

begin

    uut : component EX_stage port map (clk        => clk,
                                       rst        => rst,
                                       ctrl_op    => ctrl_op,
                                       imm        => imm,
                                       b          => b,
                                       c          => c,
                                       pc_in      => pc_in,
                                       pc_out     => pc_out,
                                       alu_res    => alu_res,
                                       status     => status,
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
        pc_in <= (others => '0');

        imm <= X"00000002";
        b   <= X"00000004";
        c   <= X"00000003";
        ctrl_op    <= ADD_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000007" report "Error ADD_OP";
        wait for t_wait;


        ctrl_op    <= ADDI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000006" report "Error ADDI_OP";
        wait for t_wait;

        ctrl_op    <= SUB_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000001" report "Error SUB_OP";
        wait for t_wait;

        ctrl_op    <= SUBI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000002" report "Error SUBI_OP";
        wait for t_wait;

        c <= X"00000004";

        ctrl_op    <= NEG_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"FFFFFFFC" report "Error NEG_OP";
        wait for t_wait;

        ctrl_op <= NOT_OP;
        wait for t_wait;
        assert alu_res = X"FFFFFFFB" report "Error NOT_OP";
        wait for t_wait;

        b <= X"00000004";
        c <= X"00000003";

        ctrl_op <= AND_OP;
        wait for t_wait;
        assert alu_res = X"00000000" report "Error AND_OP_1";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000003";
        ctrl_op <= AND_OP;
        wait for t_wait;
        assert alu_res = X"00000002" report "ERROR AND_OP_2";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000003";
        ctrl_op <= ANDI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000002" report "ERROR ANDI_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000003";
        ctrl_op <= OR_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000007" report "ERROR OR_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000003";
        ctrl_op <= ORI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000006" report "ERROR ORI_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHR_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000003" report "ERROR SHR_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHRI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000001" report "ERROR SHRI_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHL_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"0000000C" report "ERROR SHL_OP";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHLI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000018" report "ERROR SHLI_OP";
        wait for t_wait;

        -- Test aritmetic shifts with negative values too. First positive (b=6, c=1, imm=2)

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHRA_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000003" report "ERROR SHRA_OP_1";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHRAI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000001" report "ERROR SHRAI_OP_1";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHC_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"00000003" report "ERROR SHC_OP_1";
        wait for t_wait;

        b <= X"00000006";
        c <= X"00000001";
        ctrl_op <= SHCI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"80000001" report "ERROR SHCI_OP_1";
        wait for t_wait;

        b <= X"85CF190A"; -- First bit is 1 so its negative
        c <= X"00000001";
        ctrl_op <= SHRA_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"C2E78C85" report "ERROR SHRA_OP_2";
        wait for t_wait;

        ctrl_op <= SHRAI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"E173C642" report "ERROR SHRAI_OP_2";
        wait for t_wait;
          
          -- ROUND 2: test with more complicated values:
          
        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= ADD_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"FFFFFFF2" report "Error ADD_OP_N"; -- (-14) in c2
        wait for t_wait;


        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= ADDI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"FFFFFFF6" report "Error ADDI_OP_N"; -- (-10) in c2
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= SUB_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"FFFFFFF6" report "Error SUB_OP_N"; -- (-10)
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= SUBI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"FFFFFFF2" report "Error SUBI_OP_N"; -- (-14)
        wait for t_wait;
          
        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFF4"; -- (-12)
        imm <= X"00000002";
        ctrl_op <= NEG_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"0000000C" report "Error NEG_OP_N"; -- (12)
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFF4"; -- (-12)
        ctrl_op <= NOT_OP;
        wait for t_wait;
        assert alu_res = X"0000000B" report "Error NOT_OP_N";
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= AND_OP;
        wait for t_wait;
        assert alu_res = X"FFFFFFF4" report "Error AND_OP_N";
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= ANDI_OP;
        ctrl_alu_c <= '1';
        wait for t_wait;
        assert alu_res = X"00000000" report "ERROR ANDI_OP_N";
        wait for t_wait;

        b <= X"FFFFFFF4"; -- (-12) in c2
        c <= X"FFFFFFFE"; -- (-2) in c2
        imm <= X"00000002";
        ctrl_op <= OR_OP;
        ctrl_alu_c <= '0';
        wait for t_wait;
        assert alu_res = X"FFFFFFFE" report "ERROR OR_OP_N";
        wait for t_wait;

        wait;
    end process stimulus;
    
end architecture beh;
