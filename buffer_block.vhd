library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buffer_block is

	generic 
	(
		DATA_WIDTH : natural := 24;
		ADDR_WIDTH : natural := 2
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of buffer_block is

	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(0 to 2**ADDR_WIDTH-1) of word_t;
	signal rom : memory_t := (
		x"000000", --black
		x"FF0000", --red
		x"00FF00", --green
		x"0000FF" --blue
	);

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		q <= rom(addr);
	end if;
	end process;

end rtl;
