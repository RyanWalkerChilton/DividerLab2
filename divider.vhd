library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use IEEE.numeric_std.all;
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
DATA_WIDTH : natural := 16
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


signal divid :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0) := dividend;
--signal dividtemp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0) ;
signal divis :std_logic_vector (DIVISOR_WIDTH - 1 downto 0) := divisor;
signal remain :std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
signal quot :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal flag :std_logic;
signal concatdividend : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal newconcatdividend : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
constant ZERO : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (others => '0');
begin
--dividtemp<=shift_right(dividend,DIVIDEND_WIDTH-1);
newconcatdividend<= ZERO(DIVIDEND_WIDTH-1 downto 1) & divid(DIVIDEND_WIDTH-1);

G1: FOR i in 0 to (DIVIDEND_WIDTH-1) GENERATE    ---DIVISOR_WIDTH+1-1

Condition_First: if i = 0 GENERATE begin

	First: comparator
   port map(
		DINL=> newconcatdividend,   
	        DINR=>divis,     --(DIVISOR_WIDTH-1 downto 0),
                DOUT=>remain,     --(DIVISOR_WIDTH - 1 downto 0)
                isGreaterEq => quot(DIVIDEND_WIDTH-1)
			);
	end GENERATE;


Condition_Middle: if i > 0 AND i<=(DIVIDEND_WIDTH-1) GENERATE begin
concatdividend <= remain & divid(DIVIDEND_WIDTH-1-i);
     Middle: comparator
   port map(
                DINL=> concatdividend,     
	        DINR=> divis,
                DOUT=> remain,
                isGreaterEq => quot(DIVIDEND_WIDTH-1-i)
			);
	end GENERATE;

		
		
--Condition_Last: if i = (DIVIDEND_WIDTH-DIVISOR_WIDTH) GENERATE begin
--		Last: comparator
--    port map(
-- );
	--end GENERATE;

quotient<=quot;
remainder<=remain;

END generate;

end architecture structural_combinational;