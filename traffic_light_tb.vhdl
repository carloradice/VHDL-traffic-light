library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity traffic_light_tb is 
end entity;

architecture traffic_light_tb_behavior of traffic_light_tb is
	constant ClockFrequencyHz : integer := 100; -- 100 Hz
   	constant ClockPeriod      : time := 1000 ms / ClockFrequencyHz;
	signal Clk		: std_logic := '1';
	signal mode		: std_logic_vector (1 downto 0) := "00";
	signal red		: std_logic := '0';
	signal green	: std_logic := '0';
	signal yellow	: std_logic := '0';
    signal nRst		: std_logic := '1';
    signal milliseconds : integer := 0;
    signal seconds		: integer := 0;
	signal enable		: std_logic := '1';
	signal nRstTimer	: std_logic := '0';
	signal mod_Maintenance : std_logic_vector (1 downto 0) := "11";
begin
 
    -- The Device Under Test (DUT)
    i_Timer : entity work.counter
    generic map(ClockFrequencyHz => ClockFrequencyHz)
    port map (
        Clk     => Clk,
        nRst    => nRst,
        milliseconds => milliseconds,
        seconds => seconds,
		nRstTimer => nRstTimer);
 
	i_traffic_light_behavior : entity work.traffic_light
	port map (
		Clk     => Clk,
		mode	=> mode,
		red		=> red,
		green	=> green,
		yellow	=> yellow,
        nRst    => nRst,
        milliseconds => milliseconds,
        seconds => seconds,
		enable => enable,
		nRstTimer => nRstTimer,
		mod_Maintenance => mod_Maintenance);

    -- Process for generating the clock
    Clk <= not Clk after ClockPeriod / 2;
 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(Clk);
        wait;
    end process;
 
end architecture;