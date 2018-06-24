library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity controller is
    port
    (
        rst, clk : in std_logic;
        instr    : in word_t;

        -- IF stage control signals
        pc_in_mux : out std_logic; -- PC input selection mux control signal
        
        -- OF stage control signals
        imm_out     : out immediate_t; -- immediate constant from instruction
        reg_b_adr   : out reg_address_t; -- register b address
        reg_c_adr   : out reg_address_t; -- register c address

        -- EX stage control signals
        alu_b_mux, alu_c_mux : out std_logic;
        alu_op               : out op_t;
        status               : in status_t; -- status register input

        -- MEM stage control signals
        wait_data, wait_instr : in std_logic;
        mem_en, rw            : out std_logic;
        alu_res_mux           : out std_logic;

        -- WB stage control signals
        reg_a_we  : out std_logic; -- register a write enable signal
        reg_a_adr : out reg_address_t; -- register a address
        wb_mux    : out std_logic
    );
end entity controller;


architecture RTL of controller is

    type instr_array is array (natural range <>) of word_t;
    signal past_instr_reg, past_instr_next : instr_array(3 downto 0);
    signal status_reg : status_t := (others => '0');

    constant OF_stage  : natural := 0;
    constant EX_stage  : natural := 1;
    constant MEM_stage : natural := 2;
    constant WB_stage  : natural := 3;

begin

    process (clk) is
        constant init_word : word_t := (others => '0');
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                past_instr_reg <= (others => (others => '0'));
                status_reg <= (others => '0');
            else
                past_instr_reg <= past_instr_next;
                status_reg <= status;
            end if;
        end if;
    end process;

    past_instr_next(3 downto 1) <= past_instr_reg(2 downto 0);
    past_instr_next(0) <= instr;
    
    
    OF_st: process(past_instr_reg(OF_stage)) is
        alias op    is past_instr_reg(OF_stage)(31 downto 27);
        alias b_adr is past_instr_reg(OF_stage)(21 downto 17);
        alias c_adr is past_instr_reg(OF_stage)(16 downto 12);
        alias imm   is past_instr_reg(OF_stage)(16 downto 0);
    begin
        reg_b_adr <= b_adr;
        reg_c_adr <= c_adr;
        imm_out <= imm;
    end process OF_st;
    

    EX: process (past_instr_reg(EX_stage)) is
        alias op is past_instr_reg(EX_stage)(31 downto 27);
    begin
        alu_op <= op;

        alu_b_mux <= '0';
        alu_c_mux <= '0';
        case op is
            --TODO memory commands
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP | SHLI_OP | SHRAI_OP | SHCI_OP =>
                alu_c_mux <= '1';
            when others =>
                null;
        end case;
    end process EX;


    MEM: process (past_instr_reg(MEM_stage)) is
        alias op is past_instr_reg(MEM_stage)(31 downto 27);
    begin
        mem_en <= '0';
        rw <= '0';
        pc_in_mux <= '0';
        case op is
            --TODO When we add memory commands
            when others =>
                null;
        end case;
    end process MEM;


    WB: process (past_instr_reg(WB_stage)) is
        alias op     is past_instr_reg(WB_stage)(31 downto 27);
        alias a_addr is past_instr_reg(WB_stage)(26 downto 22);
    begin
        wb_mux    <= '0';
        reg_a_we  <= '0';
        reg_a_adr <= a_addr;
        case op is
            --TODO when we add memory commands
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP | SHLI_OP | SHRAI_OP | SHCI_OP |
                 ADD_OP  | SUB_OP  | OR_OP    | AND_OP  |
                 SHR_OP  | SHL_OP  | SHRA_OP  | SHC_OP  |
                 NEG_OP  | NOT_OP  =>
                     reg_a_we <= '1';
            when NOP_OP =>
                reg_a_we <= '0';
            when others =>
                null;
        end case;
    end process WB;

end architecture RTL;
