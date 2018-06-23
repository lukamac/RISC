library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RISC_const_and_types.all;

entity risc_top is
    port(
            clk         : in std_logic;
            rst         : in std_logic;
        
            -- instruction memory interface
            instr_addr  : out address_t;
            instr_data  : in word_t;
            wait_instr  : in std_logic;
        
            -- data memory interface
            data_addr   : out address_t;
            data_out    : out word_t;
            data_in     : in word_t;
            rw          : out std_logic;
            we          : out std_logic;
            wait_data   : in std_logic
    );

end risc_top;

architecture rtl of risc_top is

    component IF_stage is
        port (
            -- clock and reset
            clk				: in std_logic;
            rst				: in std_logic;
		
            -- Memory interface
            instr_addr 		: out address_t;
            instr_data		: in word_t;
		
            -- PC multiplexer inputs
            pc_alu_res_in  : in word_t;
		
            -- PC multiplexer control signal
            ctrl_pc_in_mux	: in std_logic;
		
            -- IF stage outputs
            pc_out			: out address_t;
            ir_out			: out word_t
        );
    end component IF_stage;
    
    component OF_stage is
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
        
            -- reset and clock signals
            rst         : in std_logic;
            clk         : in std_logic
        );
    end component OF_stage;
            
    component EX_stage is
        port (
            clk, rst            : in std_logic;

            -- Operation code
            ctrl_op             : in op_t;

            -- ALU input B, possible inputs
            b                   : in word_t;
            pc                  : in address_t;

            -- ALU input B, multiplexer control signal
            ctrl_alu_b  : in std_logic;

            -- ALU input C, possible inputs
            c, imm      : in word_t;

            -- ALU input C, multiplexer control signal
            ctrl_alu_c  : in std_logic;

            alu_res, mdr_out    : out word_t
        );
    end component EX_stage;
    
    component ME_stage is
        port (
            clk, rst    : in std_logic;
            alu_res_in  : in word_t;
            mdr_out     : in word_t;
            data_in     : in word_t;

            mem_addr    : out address_t;
            alu_res_out : out word_t;
            data_out    : out word_t;
            mdr_in      : out word_t
        );
    end component ME_stage;
    
    component WE_stage is
        port (
            rst, clk   : in std_logic;

            ctrl_we    : in std_logic;

            alu_res_in : in word_t;
            mdr_in     : in word_t;

            data_out   : out word_t
        );
    end component WE_stage;


begin


end rtl;

