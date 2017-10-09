library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
--Additional standard or custom libraries go here
entity divider is
port(
--Inputs
-- clk : in std_logic;
--COMMENT OUT clk signal for Part A.
start : in std_logic;
dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
overflow : out std_logic
);
end entity divider;
architecture structural_combinational of divider is
component comparator is
generic(
DATA_WIDTH : natural := 4
);
port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end component comparator;
begin
G1: FOR i in 0 downto ((DIVIDEND_WIDTH-DIVISOR_WIDTH)-1) GENERATE

	Condition_First: if i = 0 GENERATE begin
		First: comparator
			port map(dividend(DIVIDEND_WIDTH-1 downto DIVIDEND_WIDTH-6)<=DINL,divisor(DIVIDEND_WIDTH-1 downto DIVIDEND_WIDTH-5)<=DINR, --Remainder Signal
			)
	end GENERATE;
	
		Condition_Last: if i = ((DIVIDEND_WIDTH-DIVISOR_WIDTH)-1) GENERATE begin
		Last: comparator
			port map()
	end GENERATE;
	
		Condition_Middle: if i > 0 AND i<((DIVIDEND_WIDTH-DIVISOR_WIDTH)-1) GENERATE begin
		Middle: comparator
			port map()
	end GENERATE;



END GENERATE;
end architecture structural_combinational;