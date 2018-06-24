library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;


entity MEM_stage is
    port
    (
        -- input ports
        clk, rst    : in std_logic;
        alu_res_in  : in word_t;
        pc_in       : in address_t;
        mdr_out     : in word_t;
        data_in     : in word_t;
        b_in        : in word_t;
        
        -- control signals
        ctrl_alu_res_mux : in std_logic;

        -- output ports
        mem_addr    : out address_t;
        alu_res_out : out word_t;
        data_out    : out word_t;
        mdr_in      : out word_t;
        pc_out      : out address_t
    );
end entity MEM_stage;


architecture RTL of MEM_stage is
    signal alu_res_reg, alu_res_next : word_t;
    signal mdr_out_reg, mdr_out_next : word_t;
    signal pc_reg, pc_next : address_t;
    signal b_reg, b_next : word_t;
begin
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                alu_res_reg <= (others => '0');
                mdr_out_reg <= (others => '0');
                pc_reg <= (others => '0');
                b_reg <= (others => '0');
            else
                alu_res_reg <= alu_res_next;
                mdr_out_reg <= mdr_out_next;
                pc_reg <= pc_next;
                b_reg <= b_next;
            end if;
        end if;
    end process;

    alu_res_next <= alu_res_in;
    mdr_out_next <= mdr_out;
    pc_next <= pc_in;
    b_next <= b_in;

    alu_res_out <= alu_res_reg when ctrl_alu_res_mux = '0' else
                   pc_reg;
    data_out    <= mdr_out_reg;
    mdr_in      <= data_in;
    pc_out      <= b_reg;
    mem_addr    <= alu_res_reg;
end architecture RTL;
