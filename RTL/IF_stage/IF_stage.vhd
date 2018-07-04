library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;


entity IF_stage is
    port
    (
        -- clock and reset
        clk             : in std_logic;
        rst             : in std_logic;

        -- Memory interface
        instr_addr      : out address_t;
        instr_data      : in word_t;

        -- PC multiplexer inputs
        b_in            : in word_t;

        -- Control signals
        ctrl_pc_in_mux  : in std_logic;
        ctrl_wait_mem   : in std_logic;

        -- IF stage outputs
        pc_out          : out address_t;
        ir_out          : out word_t
    );
end IF_stage;

architecture rtl of IF_stage is

    signal pc_reg   : address_t := (others => '0'); -- Program counter register
    signal pc_add_4 : unsigned(address_t'range)  := (others => '0');
    signal pc_next  : address_t := (others => '0'); -- Next value for program counter register
    signal pc_reg_en : std_logic;

begin

    -- PC register process
    pc_reg_proc: process(clk) is
    begin
        if (rising_edge(clk)) then
            if(rst = '1') then
                pc_reg <= (others => '0');
            elsif(pc_reg_en = '1') then
                pc_reg <= pc_next;
            end if;
        end if;
    end process pc_reg_proc;

    pc_reg_en <= not ctrl_wait_mem;

    -- PC incrementer
    pc_add_4 <= unsigned(pc_reg) + 4;

    -- PC input mux
    with ctrl_pc_in_mux select
        pc_next <=  std_logic_vector(pc_add_4) when '0',
                    b_in when others;

    -- IR output
    ir_out <= instr_data;

    -- Instruction address output
    instr_addr <= pc_reg;

    -- PC output
    pc_out <= std_logic_vector(pc_add_4);

end rtl;
