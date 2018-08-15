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
        wb_mux    : out std_logic;

        -- Global control signals
        wait_mem  : out std_logic
    );
end entity controller;


architecture RTL of controller is

    type instr_array is array (natural range <>) of word_t;
    signal instr_reg, instr_next : instr_array(3 downto 0);
    signal status_reg, status_next : status_t := (others => '0');
    signal branch     : std_logic;
    signal reg_ce     : std_logic;
    signal wait_mem_i : std_logic;
    signal rst_or_branch : std_logic;

    constant OF_stage  : natural := 0;
    constant EX_stage  : natural := 1;
    constant MEM_stage : natural := 2;
    constant WB_stage  : natural := 3;

begin

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst_or_branch = '1') then
                instr_reg(OF_stage)  <= (others => '0');
                instr_reg(EX_stage)  <= (others => '0');
                instr_reg(MEM_stage) <= (others => '0');
            elsif (reg_ce = '1') then
                instr_reg(OF_stage)  <= instr_next(OF_stage);
                instr_reg(EX_stage)  <= instr_next(EX_stage);
                instr_reg(MEM_stage) <= instr_next(MEM_stage);
            end if;
        end if;
    end process;

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                instr_reg(WB_stage) <= (others => '0');
                status_reg          <= (others => '0');
            elsif (reg_ce = '1') then
                instr_reg(WB_stage) <= instr_next(WB_stage);
                status_reg          <= status_next;
            end if;
        end if;
    end process;

    instr_next(OF_stage)  <= instr;
    instr_next(EX_stage)  <= instr_reg(OF_stage);
    instr_next(MEM_stage) <= instr_reg(EX_stage);
    instr_next(WB_stage)  <= instr_reg(MEM_stage);

    status_next <= status;


    rst_or_branch <= '1' when rst = '1' or branch = '1' else
                     '0';
    wait_mem_i <= '1' when wait_data = '1' or wait_instr = '1' else
                  '0';
    reg_ce     <= not wait_mem_i;
    wait_mem   <= wait_mem_i;

    OF_st: process(instr_reg(OF_stage)) is
        alias op    is instr_reg(OF_stage)(31 downto 27);
        alias a_adr is instr_reg(OF_stage)(26 downto 22);
        alias b_adr is instr_reg(OF_stage)(21 downto 17);
        alias c_adr is instr_reg(OF_stage)(16 downto 12);
        alias imm   is instr_reg(OF_stage)(16 downto 0);
    begin
        imm_out   <= imm;
        reg_b_adr <= b_adr;
        reg_c_adr <= c_adr;

        case op is
            when ST_OP | STI_OP =>
                reg_c_adr <= a_adr;
            when others =>
                null;
        end case;
    end process OF_st;


    EX: process (instr_reg(EX_stage)) is
        alias op is instr_reg(EX_stage)(31 downto 27);
    begin
        alu_op    <= op;
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
            when others =>
                null;
        end case;
    end process EX;


    MEM: process (instr_reg(MEM_stage), status_reg) is
        alias op        is instr_reg(MEM_stage)(31 downto 27);
        alias condition is instr_reg(MEM_stage)(2 downto 0);

        function is_branch(
            condition : std_logic_vector(2 downto 0); 
            status : status_t
        ) return std_logic is
            variable branch : std_logic;
        begin
            branch := '0';
            case condition is
                when AL =>
                    branch := '1';
                when NV =>
                    branch := '0';
                when ZR =>
                    if(status(Z) = '1') then
                        branch := '1';
                    end if;
                when NZ =>
                    if(status(Z) = '0') then
                        branch := '1';
                    end if;
                when PL =>
                    if(status(S) = '0') then
                        branch := '1';
                    end if;
                when MI =>
                    if(status(S) = '1') then
                        branch := '1';
                    end if;
                when others =>
                    null;
            end case;
            return branch;
        end function is_branch;

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
                branch <= is_branch(condition, status_reg);
            when BRL_OP =>
                alu_res_mux <= '1';
                branch <= is_branch(condition, status_reg);
            when others =>
                null;
        end case;
    end process MEM;

    pc_in_mux <= branch;


    WB: process (instr_reg(WB_stage)) is
        alias op     is instr_reg(WB_stage)(31 downto 27);
        alias a_addr is instr_reg(WB_stage)(26 downto 22);
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
            when LA_OP | LAI_OP =>
                reg_a_we <= '1';
            when LD_OP | LDI_OP =>
                reg_a_we <= '1';
                wb_mux   <= '1';
            when ST_OP | STI_OP =>
                reg_a_we <= '0';
            when others =>
                null;
        end case;
    end process WB;

end architecture RTL;
