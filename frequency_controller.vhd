library ieee;
use ieee.std_logic_1164.all;

entity frequency_controller is

	generic 
	(
		FREQUENCY_IN : natural := 50_000_000;
		FREQUENCY_OUT_BUTTON : natural := 1_000;
		FREQUENCY_OUT_BUFFER : natural := 1_000_000;
		FREQUENCY_OUT_MAIN : natural := 1_000_000;
		FREQUENCY_OUT_SHIM : natural := 1_000_000
		
	);
	port(
		clk        : in  std_logic;
		clk_button  : out  std_logic;
		clk_buffer : out std_logic;
		clk_main : out std_logic;
		clk_shim : out std_logic
	);

end frequency_controller;

architecture rtl of frequency_controller is
	component frequency_manager is

	generic 
	(
		FREQUENCY_IN : natural := 50_000_000;
		FREQUENCY_OUT : natural := 1_000_000
		
	);
	port(
		clk	        : in  std_logic;
		clk_out       : out std_logic
	);

end component frequency_manager;
	
begin
	l1: frequency_manager generic map(FREQUENCY_IN,FREQUENCY_OUT_BUTTON)
	port map(
	clk => clk,
	clk_out => clk_button
	);
	l2: frequency_manager generic map(FREQUENCY_IN,FREQUENCY_OUT_BUFFER)
	port map(
	clk => clk,
	clk_out => clk_buffer
	);
	l3: frequency_manager generic map(FREQUENCY_IN,FREQUENCY_OUT_MAIN)
	port map(
	clk => clk,
	clk_out => clk_main
	);
	l4: frequency_manager generic map(FREQUENCY_IN,FREQUENCY_OUT_SHIM)
	port map(
	clk => clk,
	clk_out => clk_shim
	);
end rtl;
