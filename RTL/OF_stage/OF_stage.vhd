library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;


entity OF_stage is
    port (
        -- Immediate value buffering and signed extension
        ctrl_imm    : in immediate_t;
        imm_out     : out word_t;

        -- PC buffering
        pc_in       : in address_t;
        pc_out      : out address_t;

        -- data input / output
        a           : in word_t; -- input register data
        b, c        : out word_t; -- output registers (b, c) data
        
        -- control ports
        ctrl_we     : in std_logic; -- write enable signal for register a
        ctrl_a_adr  : in reg_address_t; -- a register address
        ctrl_b_adr  : in reg_address_t; -- b register address
        ctrl_c_adr  : in reg_address_t; -- c register address
        ctrl_wait_mem : in std_logic; -- memory wait signal
        
        -- reset and clock signals
        rst         : in std_logic;
        clk         : in std_logic
    );
end entity OF_stage;


architecture rtl of OF_stage is

    component regset is
        port (
                clk : in std_logic; -- Clock
                we  : in std_logic; -- Write enable for input port C
                a   : in reg_address_t; -- Address for output port A
                b   : in reg_address_t; -- Address for output port B
                c   : in reg_address_t; -- Address for input port C
                dob : out word_t; -- Data output for port B
                doc : out word_t; -- Data output for port C
                dia : in word_t -- Data input for port A
             );
    end component regset;
	
    component sign_extension is
        port (
                d_in  : in  immediate_t;
                d_out : out word_t
              );
	end component sign_extension;	

    signal pc_reg : word_t;

begin

    regs: regset port map (
                clk => clk,
                we  => ctrl_we,
                a   => ctrl_a_adr,
                b   => ctrl_b_adr,
                c   => ctrl_c_adr,
                dob => b,
                doc => c,
                dia => a
    );
    
    extend: sign_extension port map (
                d_in  => ctrl_imm,
                d_out => imm_out
    );
    
    pc_buffer: process (clk) is
        variable reg_en : std_logic;
    begin
        if (rising_edge(clk)) then
            reg_en := not ctrl_wait_mem;
            if (rst = '1') then
                pc_reg <= (others => '0');
            elsif (reg_en = '1') then
                pc_reg <= pc_in;
            end if;
        end if;
    end process pc_buffer;
    
    pc_out <= pc_reg;

end architecture rtl;
