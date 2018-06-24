library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity controller_tb is
end entity controller_tb;

architecture Behavioural of controller_tb is
    component controller is
        port
        (
            rst, clk : in std_logic;
            instr    : in word_t;

            -- IF stage control signals
            pc_in_mux : out std_logic; -- PC input selection mux control signal

            -- OF stage control signals
            imm_out     : out immediate_t; -- immediate constant from instruction
            reg_b_adr : out reg_address_t; -- register b address
            reg_c_adr : out reg_address_t; -- register c address

            -- EX stage control signals
            alu_b_mux, alu_c_mux : out std_logic;
            alu_op       : out op_t;

            -- MEM stage control signals
            wait_data, wait_instr : in std_logic;
            mem_en, rw            : out std_logic;

            -- WB stage control signals
            reg_a_we  : out std_logic; -- register a write enable signal
            reg_a_adr : out reg_address_t; -- register a address
            wb_mux    : out std_logic
        );
    end component controller;

    signal rst, clk : std_logic := '0';
    signal instr : word_t;
    signal imm_out : immediate_t;
    signal pc_in_mux, alu_b_mux, alu_c_mux, reg_a_we, wb_mux : std_logic;
    signal reg_a_adr, reg_b_adr, reg_c_adr : reg_address_t;
    signal alu_op : op_t;

    constant t_clk : time := 10 ns;
    constant t_wait : time := 20 ns;

begin
    uut: component controller port map (rst        => rst,
                                        clk        => clk,
                                        instr      => instr,
                                        pc_in_mux  => pc_in_mux,
                                        imm_out    => imm_out,
                                        reg_b_adr  => reg_b_adr,
                                        reg_c_adr  => reg_c_adr,
                                        alu_b_mux  => alu_b_mux,
                                        alu_c_mux  => alu_c_mux,
                                        alu_op     => alu_op,
                                        wait_data  => '0',
                                        wait_instr => '0',
                                        mem_en     => open,
                                        rw         => open,
                                        reg_a_we   => reg_a_we,
                                        reg_a_adr  => reg_a_adr,
                                        wb_mux     => wb_mux
                                       );

    clk <= not clk after t_clk / 2;

    stimulus: process is

        variable addr_a : std_logic_vector(4  downto 0);
        variable addr_b : std_logic_vector(4  downto 0);
        variable addr_c : std_logic_vector(4  downto 0);
        variable imm12  : std_logic_vector(11 downto 0);
        variable imm17  : std_logic_vector(16 downto 0);

        variable NOP_instr : word_t := NOP_OP & "---------------------------";

    begin
        rst <= '1';
        wait for t_wait;
        rst <= '0';

        -- Sequential testing arithmetical and logical operations

        -- NOP
        instr <= NOP_OP & "---------------------------";

        -- test OF stage
        wait until clk = '1';

        -- test EX stage
        wait until clk = '1';

        -- test MEM stage
        wait until clk = '1';
        assert pc_in_mux = '0' report "NOP MEM";

        -- test WB stage
        wait until clk = '1';
        assert reg_a_we = '0' report "NOP WB";
        

        -- ADD_OP
        
        addr_a := "00000";
        addr_b := "00001";
        addr_c := "00010";
        imm12  := "101010101010";
        imm17  := addr_c & imm12;
        instr <= ADD_OP & addr_a & addr_b & addr_c & imm12;

        -- test OF stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert reg_b_adr = addr_b and
               reg_c_adr = addr_c and 
               imm_out   = imm17
            report "ADD OF";


        -- test EX stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert alu_op = ADD_OP and
               alu_b_mux = '0' and
               alu_c_mux = '0'
            report "ADD EX";

        -- test MEM stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert pc_in_mux = '0'
            report "ADD MEM";

        -- test WB stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert wb_mux = '0'       and
               reg_a_we = '1'     and
               reg_a_adr = addr_a
            report "ADD WB";


        -- ADDI_OP
        
        addr_a := "00100";
        addr_b := "00101";
        addr_c := "00110";
        imm12  := "010101010101";
        imm17  := addr_c & imm12;
        instr <= ADDI_OP & addr_a & addr_b & addr_c & imm12;

        -- test OF stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert reg_b_adr = addr_b and
               reg_c_adr = addr_c and 
               imm_out   = imm17
            report "ADDI OF";


        -- test EX stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert alu_op = ADDI_OP and
               alu_b_mux = '0' and
               alu_c_mux = '1'
            report "ADDI EX";

        -- test MEM stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert pc_in_mux = '0'
            report "ADDI MEM";

        -- test WB stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert wb_mux = '0'       and
               reg_a_we = '1'     and
               reg_a_adr = addr_a
            report "ADDI WB";


        -- SUB_OP
        
        addr_a := "10000";
        addr_b := "10001";
        addr_c := "10010";
        imm12  := "111010101010";
        imm17  := addr_c & imm12;
        instr <= SUB_OP & addr_a & addr_b & addr_c & imm12;

        -- test OF stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert reg_b_adr = addr_b and
               reg_c_adr = addr_c and 
               imm_out   = imm17
            report "SUB OF";


        -- test EX stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert alu_op = SUB_OP and
               alu_b_mux = '0' and
               alu_c_mux = '0'
            report "SUB EX";

        -- test MEM stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert pc_in_mux = '0'
            report "SUB MEM";

        -- test WB stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert wb_mux = '0'       and
               reg_a_we = '1'     and
               reg_a_adr = addr_a
            report "SUB WB";


        -- SUBI_OP
        
        addr_a := "01100";
        addr_b := "01101";
        addr_c := "01110";
        imm12  := "010111010101";
        imm17  := addr_c & imm12;
        instr <= SUBI_OP & addr_a & addr_b & addr_c & imm12;

        -- test OF stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert reg_b_adr = addr_b and
               reg_c_adr = addr_c and 
               imm_out   = imm17
            report "SUBI OF";


        -- test EX stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert alu_op = SUBI_OP and
               alu_b_mux = '0' and
               alu_c_mux = '1'
            report "SUBI EX";

        -- test MEM stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert pc_in_mux = '0'
            report "SUBI MEM";

        -- test WB stage
        wait until clk = '1';
        instr <= NOP_instr;
        wait until clk = '0';
        assert wb_mux = '0'       and
               reg_a_we = '1'     and
               reg_a_adr = addr_a
            report "SUBI WB";


        wait;
    end process stimulus;

end architecture Behavioural;
