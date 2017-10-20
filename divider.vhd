library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here
entity divider is
port(
--Inputs
clk : in std_logic;
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
port(
--Inputs
DINL : in std_logic_vector (DIVISOR_WIDTH downto 0);
DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end component comparator;

--signal remain :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
--signal flag :std_logic;
--signal concatdividend : std_logic_vector(DIVIDEND_WIDTH downto 0);


signal quot :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
type arrayconcat is array (0 to DIVIDEND_WIDTH-1) of std_logic_vector(DIVISOR_WIDTH downto 0);
signal concatdividend: arrayconcat;
type remainarray is array (0 to DIVIDEND_WIDTH) of std_logic_vector(DIVISOR_WIDTH-1 downto 0);
signal remain: remainarray; --:= (others=>'0');

--signal newconcatdividend : std_logic_vector(DIVIDEND_WIDTH downto 0);
--constant ZERO : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (others => '0');

begin
--divid<=dividend when start='1'; 
--newconcatdividend<= ZERO(DIVIDEND_WIDTH-1 downto 0) & divid(DIVIDEND_WIDTH-1);
--divis<= ZERO(DIVISOR_WIDTH-1 downto 0 )&divisor;

remain(0)<= (others=>'0');

G1: FOR i in (DIVIDEND_WIDTH-1) downto 0 GENERATE    
begin
concatdividend(DIVIDEND_WIDTH-1-i) <= (remain(DIVIDEND_WIDTH-1-i)&dividend(i));
C1: comparator 
port map(concatdividend(DIVIDEND_WIDTH-1-i),divisor, remain(DIVIDEND_WIDTH-i), quot(i)
	);
end GENERATE ;

START_PROCESS : process (start)
begin
if start='1' then
if to_integer(unsigned(divisor)) /= 0 then
overflow <= '0';
remainder <= remain(DIVIDEND_WIDTH);
quotient <= quot;
else
overflow <= '1';
remainder <= std_logic_vector(to_unsigned(0, DIVISOR_WIDTH));
quotient <= std_logic_vector(to_unsigned(0, DIVIDEND_WIDTH));
end if;
end if;
end process;
end architecture structural_combinational;




architecture behavioral_sequential of divider is

component comparator is
port(
--Inputs
DINL : in std_logic_vector (DIVISOR_WIDTH downto 0);
DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end component comparator;

signal quot :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
type arrayconcat is array (0 to DIVIDEND_WIDTH-1) of std_logic_vector(DIVISOR_WIDTH downto 0);
signal concatdividend: arrayconcat;
type remainarray is array (0 to DIVIDEND_WIDTH) of std_logic_vector(DIVISOR_WIDTH-1 downto 0);
signal remain: remainarray; --:= (others=>'0');

begin 
remain(0)<= (others=>'0');

G1: FOR i in (DIVIDEND_WIDTH-1) downto 0 GENERATE    
begin
process(clk)
if (rising_edge(clk)) then
concatdividend(DIVIDEND_WIDTH-1-i) <= (remain(DIVIDEND_WIDTH-1-i)&dividend(i));
C1: comparator 
port map(concatdividend(DIVIDEND_WIDTH-1-i),divisor, remain(DIVIDEND_WIDTH-i), quot(i)
	);
end if;
end process;  
end GENERATE ;



end architecture; 
