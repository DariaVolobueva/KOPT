library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
	generic(
		DATA_WIDTH 		  : natural:= 6
	);

	port(
		clk 				  : in std_logic;
		data 		  		  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		pwm_out			  : out std_logic
	);

end pwm;

architecture rtl of pwm is
	
	type state_type is (s0, s1);
	-- Register to hold the current state
	signal state   : state_type:=s0;

begin
	-- Logic to advance to the next state
	process (clk)
		variable counter: natural:= 0;
	begin
		if (rising_edge(clk)) then
			case state is
				when s0=>
					if to_unsigned(counter,DATA_WIDTH)<unsigned(data) then
						pwm_out<='1';
						counter:=counter+1;
					else
						state <= s1;
						pwm_out<='0';
						counter:=counter+1;
					end if;
				when s1=>
					if counter<2**DATA_WIDTH then
						state <= s1;
						counter:=counter+1;
					else
						state <= s0;
						counter:=0;
					end if;
			end case;
		end if;
	end process;
end rtl;
