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
            data_en     : out std_logic;
            rw          : out std_logic;
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
    
    component MEM_stage is
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
    end component MEM_stage;
    
    component WB_stage is
        port (
            rst, clk   : in std_logic;

            ctrl_wb_mux: in std_logic;

            alu_res_in : in word_t;
            mdr_in     : in word_t;

            data_out   : out word_t
        );
    end component WB_stage;
    
    component controller is
        port (
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
    
    -- Signals coming out of controller
    signal ctrl_pc_in_mux : std_logic;
    signal ctrl_reg_a_we : std_logic;
    signal ctrl_17imm : immediate_t;
    signal ctrl_a_adr, ctrl_b_adr, ctrl_c_adr : reg_address_t;
    signal ctrl_alu_op : op_t;
    signal ctrl_alu_b_mux, ctrl_alu_c_mux : std_logic;
    signal ctrl_wb_mux : std_logic;
    
    -- Signals coming out of IF stage
    signal if_ir_out : word_t;
    signal if_pc_out : address_t;
    
    -- Signals coming out of OF stage
    signal of_pc_out : address_t;
    signal of_32imm_out : word_t;
    signal of_a_in, of_b_out, of_c_out : word_t;
    
    -- Signals coming out of EX stage
    signal ex_alu_res, ex_mdr_out : word_t;
    
    -- Signals coming out of MEM stage
    signal mem_alu_res : word_t;
    
    -- Signals coming out of WB stage
    signal wb_mdr_in : word_t;
    

begin

    if_inst: IF_stage port map(
            clk => clk,
            rst => rst,
            instr_addr => instr_addr,
            instr_data => instr_data,
            pc_alu_res_in => mem_alu_res,
            ctrl_pc_in_mux => ctrl_pc_in_mux,
            pc_out => if_pc_out,
            ir_out => if_ir_out
            );
            
    of_inst: OF_stage port map(
            clk => clk,
            rst => rst,
            ctrl_imm => ctrl_17imm,
            imm_out => of_32imm_out,
            pc_in => if_pc_out,
            pc_out => of_pc_out,
            a => of_a_in,
            b => of_b_out,
            c => of_c_out,
            ctrl_we => ctrl_reg_a_we,
            ctrl_a_adr => ctrl_a_adr,
            ctrl_b_adr => ctrl_b_adr,
            ctrl_c_adr => ctrl_c_adr
            );
            
    ex_inst: EX_stage port map(
            clk => clk,
            rst => rst,
            ctrl_op => ctrl_alu_op,
            b => of_b_out,
            pc => of_pc_out,
            ctrl_alu_b => ctrl_alu_b_mux,
            c => of_c_out,
            imm => of_32imm_out,
            ctrl_alu_c => ctrl_alu_c_mux,
            alu_res => ex_alu_res,
            mdr_out => ex_mdr_out
            );
            
    mem_inst: MEM_stage port map(
            clk => clk,
            rst => rst,
            alu_res_in => ex_alu_res,
            mdr_out => ex_mdr_out, 
            data_in => data_in,
            mem_addr => data_addr,
            alu_res_out => mem_alu_res,
            data_out => data_out,
            mdr_in => wb_mdr_in
            );
            
    wb_inst: WB_stage port map(
            clk => clk,
            rst => rst,
            ctrl_wb_mux => ctrl_wb_mux,
            alu_res_in => mem_alu_res,
            mdr_in => wb_mdr_in,
            data_out => of_a_in
            );
            
    ctrl_inst: controller port map(
            rst => rst,
            clk => clk,
            instr => if_ir_out,
            pc_in_mux => ctrl_pc_in_mux,
            imm_out => ctrl_17imm,
            reg_b_adr => ctrl_b_adr,
            reg_c_adr => ctrl_c_adr,
            alu_b_mux => ctrl_alu_b_mux, 
            alu_c_mux => ctrl_alu_c_mux,
            alu_op => ctrl_alu_op,
            wait_data => wait_data,
            wait_instr => wait_instr,
            mem_en => data_en,
            rw => rw,
            reg_a_we => ctrl_reg_a_we,
            reg_a_adr => ctrl_a_adr,
            wb_mux => ctrl_wb_mux
            );
        
end rtl;