library ieee;
use ieee.std_logic_1164.all;

entity top_level_model is

	port(
		clk 			 : in std_logic;
		button_in 	 : in std_logic;
		rgb_out_R 	 : out std_logic;
		rgb_out_G 	 : out std_logic;
		rgb_out_B 	 : out std_logic
	);

end top_level_model;

architecture rtl of top_level_model is
	component main_block is

		port(
		clk 					 : in std_logic;
		button_contr_in 	 : in std_logic;
		nios_in 		 		 : in std_logic;
		nios_out 	 		 : out std_logic;
		bufer_out 	 		 : out integer range 0 to 3
	);

	end component;
	component frequency_controller is

		port(
			clk        : in  std_logic;
			clk_button : out  std_logic;
			clk_buffer : out std_logic;
			clk_main   : out std_logic;
			clk_shim   : out std_logic
		);

	end component;
	component button_controller is

		port(
			clk        : in  std_logic;
			button_in  : in  std_logic;
			button_out : out std_logic;
			button_buf : out std_logic
		);

	end component;
	component buffer_block is

			generic 
		(
			DATA_WIDTH : natural := 24;
			ADDR_WIDTH : natural := 2
		);

		port 
		(
			clk	: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);

	end component;
	component pwm is
		generic(
			DATA_WIDTH 		  : natural:= 8
		);

		port(
			clk 				  : in std_logic;
			data 		  		  : in std_logic_vector(DATA_WIDTH-1 downto 0);
			pwm_out			  : out std_logic
		);
	end component;
	
	signal button_out 					: std_logic;
	signal clk_button 					: std_logic;
	signal clk_buffer 					: std_logic;
	signal clk_main   					: std_logic;
	signal clk_shim   					: std_logic;
	signal frequency_man_in_main 		: std_logic;
	signal main_out 						: std_logic;
	signal nios_out 						: std_logic;
	signal nios_in 						: std_logic;
	signal shim_out_main 				: std_logic;
	signal buffer_in 						: natural;
	signal bufer_out						: natural;
	signal button_contr_bufer 			: std_logic;
	signal frequency_man_in_buffer 	: std_logic;
	signal frequency_contr_shim 		: std_logic;
	signal data_r 					 		: std_logic_vector(8-1 downto 0);
	signal data_g 					 		: std_logic_vector(8-1 downto 0);
	signal data_b 					 		: std_logic_vector(8-1 downto 0);
	signal main_in_shim 			 		: std_logic;
begin
	
	l_bc : button_controller
		port map(
		   clk        => clk_button,
			button_in  => button_in,
			button_out => button_out,
			button_buf => button_contr_bufer
			);
			
	l_fc : frequency_controller
		port map(
		   clk        => clk,
			clk_button => clk_button,
			clk_buffer => clk_buffer,
			clk_main   => clk_main,
			clk_shim   => clk_shim
			);
	l_mb : main_block
		port map(	
		   clk 				  => clk_main,
			button_contr_in  => button_out,
			nios_in 		 	  => nios_out,
			nios_out 	 	  => nios_in,
			bufer_out 	 	  => buffer_in
			);
	l_bb : buffer_block
		port map(
		   clk 				   => clk_buffer,
			addr				   => bufer_out,
			q(24-1 downto 16) => data_r,
			q(16-1 downto 8)	=> data_g,
			q(8-1 downto 0)	=> data_b
			);
	l_rr : pwm
		port map(
		   clk 				  => clk_shim,
			data   		  	  => data_r,
			pwm_out			  => rgb_out_R
			);
	l_rg : pwm
		port map(
		   clk 				  => clk_shim,
			data   		     => data_g,
			pwm_out			  => rgb_out_G
			);
	l_rb : pwm
		port map(
		   clk 				  => clk_shim,
			data   		     => data_b,
			pwm_out			  => rgb_out_B
			);
end rtl;
