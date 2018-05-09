library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity regset is
    port (
			clk : in std_logic; -- Clock
			we  : in std_logic; -- Write enable for input port C
			a   : in std_logic_vector(4 downto 0); -- Address for output port A
			b   : in std_logic_vector(4 downto 0); -- Address for output port B
			c   : in std_logic_vector(4 downto 0); -- Address for input port C
			doa  : out std_logic_vector(31 downto 0); -- Data output for port A
			dob  : out std_logic_vector(31 downto 0); -- Data output for port B
			dic  : in std_logic_vector(31 downto 0) -- Data input for port C
		);
end regset;

architecture rtl of regset is
    type ram_type is array (31 downto 0) of std_logic_vector (31 downto 0);
    signal RAM : ram_type;
begin
	
	-- data input process
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                RAM(to_integer(unsigned(c))) <= dic;
            end if;
        end if;
    end process;
	 
	 -- Data outputs
    doa <= RAM(to_integer(unsigned(a)));
    dob <= RAM(to_integer(unsigned(b)));

end rtl;
