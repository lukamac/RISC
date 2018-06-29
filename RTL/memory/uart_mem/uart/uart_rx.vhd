library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity uart_rx is
generic
(
    W 	: natural := 8
);
port
(
    rx      : in std_logic;
    tick 	: in std_logic;
    clk 	: in std_logic;
    rst 	: in std_logic;
    
    d_out 	: out std_logic_vector(W-1 downto 0);
    rx_done	: out std_logic
);
end uart_rx;

architecture rtl of uart_rx is

	type state_type is (IDLE, START, READ_RX, STOP);
	
	signal state_reg, state_next    : state_type := IDLE;
	signal tc_reg, tc_next          : unsigned(3 downto 0) := (others => '0');
	signal bc_reg, bc_next          : unsigned(integer(ceil(log2(real(W)))) - 1 downto 0) := (others => '0');
	signal shift_reg, shift_next    : std_logic_vector(W-1 downto 0) := (others => '0');

begin

    -- Memory logic
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                state_reg <= IDLE;
                tc_reg <= (others => '0');
                bc_reg <= (others => '0');
                shift_reg <= (others => '0');
            else
                state_reg <= state_next;
                tc_reg <= tc_next;
                bc_reg <= bc_next;
                shift_reg <= shift_next;
            end if;
        end if;
    end process;

    -- Next state + output
    process (state_reg, tick, rx, tc_reg, bc_reg, shift_reg) is
    begin
        tc_next <= tc_reg;
        bc_next <= bc_reg;
        shift_next <= shift_reg;
        rx_done <= '0';
        case state_reg is
            when IDLE =>
                if (rx = '0') then
                    state_next <= START;
                else
                    state_next <= IDLE;
                end if;
            when START =>
                if (tick = '1') then
                    if (tc_reg = 7) then
                        tc_next <= (others => '0');
                        state_next <= READ_RX;
                    else
                        tc_next <= tc_reg + 1;
                        state_next <= START;
                    end if;
                else
                    state_next <= START;
                end if;
            when READ_RX =>
                if (tick = '1') then
                    if (tc_reg = 15) then
                        tc_next <= (others => '0');
                        shift_next <= rx & shift_reg(W - 1 downto 1);
                        if (bc_reg = W - 1) then
                            bc_next <= (others => '0');
                            state_next <= STOP;
                        else
                            bc_next <= bc_reg + 1;
                            state_next <= READ_RX;
                        end if;
                    else
                        tc_next <= tc_reg + 1;
                        state_next <= READ_RX;
                    end if;
                else
                    state_next <= READ_RX;
                end if;
            when STOP =>
                if (tick = '1') then
                    if (tc_reg = 15) then
                        state_next <= IDLE;
                        tc_next <= (others => '0');
                    else
                        state_next <= STOP;
                        tc_next <= tc_reg + 1;
                    end if;
                else
                    state_next <= STOP;
                end if;
                rx_done <= '1';
        end case;
    end process;
    d_out <= shift_reg;
end architecture rtl;
