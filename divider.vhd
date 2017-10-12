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


signal divid :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0); --:= dividend;
--signal dividtemp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0) ;
signal divis :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0); -- := divisor;
--signal remain :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal quot :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal flag :std_logic;
--signal concatdividend : std_logic_vector(DIVIDEND_WIDTH downto 0);

type arrayconcat is array (0 to DIVIDEND_WIDTH) of std_logic_vector(DIVIDEND_WIDTH downto 0);
signal concatdividend: arrayconcat;
type remainarray is array (0 to DIVIDEND_WIDTH-1) of std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal remain: remainarray;

signal newconcatdividend : std_logic_vector(DIVIDEND_WIDTH downto 0);
constant ZERO : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (others => '0');
begin
--dividtemp<=shift_right(dividend,DIVIDEND_WIDTH-1);
divid<=dividend; 
newconcatdividend<= ZERO(DIVIDEND_WIDTH-1 downto 0) & divid(DIVIDEND_WIDTH-1);
divis<= ZERO(DIVISOR_WIDTH-1 downto 0 )&divisor;

G1: FOR i in 0 to (DIVIDEND_WIDTH-1) GENERATE    ---DIVISOR_WIDTH+1-1

Condition_First: if i = 0 GENERATE begin

	First: comparator
generic map (DATA_WIDTH   => 16) -- NO  SEMICOLON
   port map(
		DINL=> newconcatdividend,   
	        DINR=>divis,     --(DIVISOR_WIDTH-1 downto 0),
                DOUT=>remain(i),     --(DIVISOR_WIDTH - 1 downto 0)
                isGreaterEq => quot(DIVIDEND_WIDTH-1)
			);
	end GENERATE;



Condition_Middle: if i > 0 AND i<=(DIVIDEND_WIDTH-1) GENERATE begin
    
 Middle: comparator
generic map (DATA_WIDTH   => 16)
   port map(
                DINL=> concatdividend(i),     
	        DINR=> divis,
                DOUT=> remain(i),
                isGreaterEq => quot(DIVIDEND_WIDTH-1-i)
			);
	end GENERATE;
concatdividend(i+1)<= remain(i) & divid(DIVIDEND_WIDTH-1-i);		
--Condition_Last: if i = (DIVIDEND_WIDTH-DIVISOR_WIDTH) GENERATE begin
--		Last: comparator
--    port map(
-- );
	--end GENERATE;

quotient<=quot;
remainder<=remain(DIVIDEND_WIDTH-1)(DIVISOR_WIDTH-1 downto 0);

END generate;

end architecture structural_combinational;