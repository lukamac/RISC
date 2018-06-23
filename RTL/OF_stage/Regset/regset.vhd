library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;

entity regset is
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
end regset;

architecture rtl of regset is
    type ram_type is array (31 downto 0) of word_t;
    signal RAM : ram_type;
begin
	
	-- data input process
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                RAM(to_integer(unsigned(a))) <= dia;
            end if;
        end if;
    end process;
	 
	 -- Data outputs
    dob <= RAM(to_integer(unsigned(b)));
    doc <= RAM(to_integer(unsigned(c)));

end rtl;
