library ieee;
use ieee.std_logic_1164.all;

entity button_controller is

	port(
		clk        : in  std_logic;
		button_in  : in  std_logic;
		button_out : out std_logic;
		button_buf : out std_logic
	);

end button_controller;

architecture rtl of button_controller is

begin
	strobe : process (clk) is 
		variable counter : integer := 0; 
	begin
		if (rising_edge(clk)) then 
			if (counter > 0) then 
				button_out <= '0'; 
				if (counter < 10) then 
					counter := counter + 1; 
				else
					counter := 0; 
				end if;
			elsif (counter = 0 and button_in = '1') then 
				counter := 1; 
				button_out <= '1'; 
			end if; 
		end if; 
	end process strobe;
end rtl;
