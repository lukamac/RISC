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
        pc_inc_en : out std_logic;
        
        -- OF stage control signals
        imm_out       : out immediate_t; -- immediate constant from instruction
        reg_b_adr     : out reg_address_t; -- register b address
        reg_c_adr     : out reg_address_t; -- register c address

        -- EX stage control signals
        alu_b_mux, alu_c_mux : out std_logic;
        alu_op               : out op_t;
        status               : in status_t; -- status register input

        -- MEM stage control signals
        wait_data, wait_instr : in std_logic;
        data_rd, data_wr      : out std_logic;
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
    signal branch : std_logic;

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

    past_instr_next(OF_stage)  <= past_instr_reg(OF_stage) when wait_data = '1' or wait_instr = '1' else
                                  instr when branch = '0' else
                                  (others => '0');
    past_instr_next(EX_stage)  <= past_instr_reg(EX_stage) when wait_data = '1' or wait_instr = '1' else
                                  past_instr_reg(OF_stage) when branch = '0' else
                                  (others => '0');
    past_instr_next(MEM_stage) <= past_instr_reg(MEM_stage) when wait_data = '1' or wait_instr = '1' else
                                  past_instr_reg(EX_stage) when branch = '0' else
                                  (others => '0');
    past_instr_next(WB_stage)  <= past_instr_reg(WB_stage) when wait_data = '1' or wait_instr = '1' else
                                  past_instr_reg(MEM_stage);


    pc_inc_en <= '0' when wait_data = '1' or wait_instr = '1' else
                 '1';

    OF_st: process(past_instr_reg(OF_stage)) is
        alias op    is past_instr_reg(OF_stage)(31 downto 27);
        alias a_adr is past_instr_reg(OF_stage)(26 downto 22);
        alias b_adr is past_instr_reg(OF_stage)(21 downto 17);
        alias c_adr is past_instr_reg(OF_stage)(16 downto 12);
        alias imm   is past_instr_reg(OF_stage)(16 downto 0);
    begin
        imm_out       <= imm;
        reg_b_adr     <= b_adr;
        reg_c_adr     <= c_adr;
        
        case op is
            when ST_OP | STI_OP =>
                reg_c_adr <= a_adr;
            when others =>
                null;
        end case;
    end process OF_st;
    

    EX: process (past_instr_reg(EX_stage)) is
        alias op is past_instr_reg(EX_stage)(31 downto 27);
    begin
        alu_op <= op;
        alu_b_mux <= '0';
        alu_c_mux <= '0';

        case op is
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP | SHLI_OP | SHRAI_OP | SHCI_OP =>
                alu_c_mux <= '1';
            when LAI_OP | LDI_OP | STI_OP =>
                alu_c_mux <= '1';
            when LA_OP | LD_OP | ST_OP =>
                alu_c_mux <= '1';
                alu_op <= ADDI_OP;
            when others =>
                null;
        end case;
    end process EX;


    MEM: process (past_instr_reg(MEM_stage), status_reg) is
        alias op is past_instr_reg(MEM_stage)(31 downto 27);
        alias condition is past_instr_reg(MEM_stage)(2 downto 0);
    begin
        data_rd     <= '0';
        data_wr     <= '0';
        branch      <= '0';
        alu_res_mux <= '0';

        case op is
            when LD_OP | LDI_OP =>
                data_rd <= '1';
            when ST_OP | STI_OP =>
                data_wr <= '1';
            when BR_OP =>
                case condition is
                    when AL =>
                        branch <= '1';
                    when NV =>
                        branch <= '0';
                    when ZR =>
                        if(status_reg(Z) = '1') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when NZ =>
                        if(status_reg(Z) = '0') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when PL =>
                        if(status_reg(S) = '0') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when MI =>
                        if(status_reg(S) = '1') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when others =>
                        null;
                end case;
            when BRL_OP =>
                alu_res_mux <= '1';
                case condition is
                    when AL =>
                        branch <= '1';
                    when NV =>
                        branch <= '0';
                    when ZR =>
                        if(status_reg(Z) = '1') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when NZ =>
                        if(status_reg(Z) = '0') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when PL =>
                        if(status_reg(S) = '0') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when MI =>
                        if(status_reg(S) = '1') then
                            branch <= '1';
                        else
                            branch <= '0';
                        end if;
                    when others =>
                        null;
                end case;
            when others =>
                null;
        end case;
    end process MEM;

    pc_in_mux <= branch;


    WB: process (past_instr_reg(WB_stage)) is
        alias op     is past_instr_reg(WB_stage)(31 downto 27);
        alias a_addr is past_instr_reg(WB_stage)(26 downto 22);
    begin
        wb_mux    <= '0';
        reg_a_we  <= '0';
        reg_a_adr <= a_addr;
        case op is
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP | SHLI_OP | SHRAI_OP | SHCI_OP |
                 ADD_OP  | SUB_OP  | OR_OP    | AND_OP  |
                 SHR_OP  | SHL_OP  | SHRA_OP  | SHC_OP  |
                 NEG_OP  | NOT_OP  =>
                reg_a_we <= '1';
            when NOP_OP =>
                reg_a_we <= '0';
            when BR_OP =>
                reg_a_we <= '0';
            when BRL_OP =>
                reg_a_we <= '1';
            when LA_OP | LD_OP | LDI_OP =>
                reg_a_we <= '1';
                wb_mux   <= '1';
            when ST_OP | STI_OP =>
                reg_a_we <= '0';
            when others =>
                null;
        end case;
    end process WB;

end architecture RTL;
