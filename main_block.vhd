library ieee;
use ieee.std_logic_1164.all;

entity main_block is

	port(
		clk : in std_logic;
		button_contr_in 	 : in std_logic;
		nios_in 		 		 : in std_logic;
		nios_out 	 		 : out std_logic;
		bufer_out 	 		 : out integer range 0 to 3
	);

end main_block;

architecture rtl of main_block is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);

	-- Register to hold the current state
	signal state   : state_type := s0;
	signal counter : integer    := 0;

begin

	-- Logic to advance to the next state
	process (clk)
	begin
		if (rising_edge(clk)) then
			case state is
				when s0=>
					if button_contr_in = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
						state <= s2;
						if counter<3 then
							counter <= counter+1;
						else
							counter <= 0;
						end if;
				when s2=>
					if button_contr_in = '0' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3 =>
						state <= s0;
			end case;
		end if;
	end process;
	bufer_out<=counter;
end rtl;
