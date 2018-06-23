library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;


entity MEM_stage is
    port
    (
        clk, rst    : in std_logic;
        alu_res_in  : in word_t;
        mdr_out     : in word_t;
        data_in     : in word_t;

        mem_addr    : out address_t;
        alu_res_out : out word_t;
        data_out    : out word_t;
        mdr_in      : out word_t
    );
end entity MEM_stage;


architecture RTL of MEM_stage is
    signal alu_res_reg, alu_res_next : word_t;
    signal mdr_out_reg, mdr_out_next : word_t;
begin
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                alu_res_reg <= (others => '0');
                mdr_out_reg <= (others => '0');
            else
                alu_res_reg <= alu_res_next;
                mdr_out_reg <= mdr_out_next;
            end if;
        end if;
    end process;

    alu_res_next <= alu_res_in;
    mdr_out_next <= mdr_out;

    alu_res_out <= alu_res_reg;
    data_out    <= mdr_out_reg;
    mdr_in      <= data_in;
end architecture RTL;
