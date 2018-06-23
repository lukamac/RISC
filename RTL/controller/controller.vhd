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
        reg_b_adr : out reg_address_t; -- register b address
        reg_c_adr : out reg_address_t; -- register c address

        -- EX stage control signals
        alu_b, alu_c : out std_logic;
        alu_op       : out op_t;

        -- MEM stage control signals
        wait_data, wait_instr : in std_logic;
        mem_en, rw            : out std_logic;

        -- WB stage control signals
        reg_a_we  : out std_logic; -- register a write enable signal
        reg_a_adr : out reg_address_t; -- register a address
        wb_mux    : out std_logic
    );
end entity controller;


architecture RTL of controller is

    type instr_array is array (natural range <>) of word_t;
    signal past_instr_reg, past_instr_next : instr_array(3 downto 0);

    constant OF_stage : natural := 0;
    constant EX_stage : natural := 1;
    constant ME_stage : natural := 2;
    constant WE_stage : natural := 3;

begin

    process (clk) is
        variable init_word : word_t := (others => '0');
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                past_instr_reg <= (others => init_word);
            else
                past_instr_reg <= past_instr_next;
            end if;
        end if;
    end process;

    past_instr_next(3 downto 1) <= past_instr_reg(2 downto 0);
    past_instr_next(0) <= instr;
    
    
    OF_st: process(past_instr_reg(OF_stage)) is
        variable OF_instr : word_t        := past_instr_reg(OF_stage);
        variable op       : op_t          := OF_instr(31 downto 27);
        variable b_adr    : reg_address_t := OF_instr(21 downto 17);
        variable c_adr    : reg_address_t := OF_instr(16 downto 12);
    begin
        case op is
                -- TODO
            when others =>
                null;
        end case;
    end process OF_st;


    EX: process (past_instr_reg(EX_stage)) is
        variable EX_instr : word_t := past_instr_reg(EX_stage);
        variable op : op_t := EX_instr(31 downto 27);
    begin
        alu_op <= op;

        alu_b <= '0';
        alu_c <= '0';
        case op is
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP  | SHLI_OP | SHRAI_OP | SHCI_OP =>
                alu_c <= '1';
            when others =>
                null;
        end case;
    end process EX;


    MEM: process (past_instr_reg(ME_stage)) is
        variable MEM_instr : word_t := past_instr_reg(ME_stage);
        variable op : op_t := MEM_instr(31 downto 27);
    begin
        mem_en <= '0';
        rw <= '0';
        case op is
            --TODO When we add memory commands
            when others =>
                null;
        end case;
    end process MEM;


    WB: process (past_instr_reg(WE_stage)) is
        variable WB_instr : word_t := past_instr_reg(WE_stage);
        variable op : op_t := WB_instr(31 downto 27);
        variable a_addr : reg_address_t := WB_instr(26 downto 22);
    begin
        wb_mux    <= '0';
        reg_a_we  <= '0';
        reg_a_adr <= a_addr;
        case op is
            --TODO when we add memory commands
            when ADDI_OP  | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP  | SHLI_OP | SHRAI_OP | SHCI_OP |
                 ADD_OP   | SUB_OP  | OR_OP    | AND_OP  |
                 SHR_OP   | SHL_OP  | SHRA_OP  | SHC_OP  |
                 NEG_OP   | NOT_OP  =>
                     reg_a_we <= '1';
            when NOP_OP =>
                reg_a_we <= '0';
            when others =>
                null;
        end case;
    end process WB;

end architecture RTL;
