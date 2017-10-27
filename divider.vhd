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

signal DividendTemp:std_logic_vector( DIVIDEND_WIDTH-1 downto 0);
signal DivisorTemp: std_logic_vector (DIVISOR_WIDTH-1 downto 0);
signal quotientsingle: std_logic;
signal Count: integer:=DIVIDEND_WIDTH -1;
signal sigdiv : std_logic_vector(DIVISOR_WIDTH downto 0); 
signal remain : std_logic_vector(DIVISOR_WIDTH-1 downto 0); 
signal remainsingle: std_logic_vector(DIVISOR_WIDTH-1 downto 0);
signal quot: std_logic_vector(DIVIDEND_WIDTH downto 0);
signal quotientfull: std_logic_vector(DIVIDEND_WIDTH-1 downto 0);

component comparator is
port(
--Inputs
DINL : in std_logic_vector (DIVISOR_WIDTH downto 0);
DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Output
DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end component comparator;

begin

process(start,dividend,divisor)
begin 
if (start='1') then
DividendTemp<= dividend;
DivisorTemp<= divisor;
end if;
end process;


process (DivisorTemp)
begin
if (to_integer(unsigned(DivisorTemp)) /= 0) then
overflow <= '0';
else
overflow <= '1';
end if;
end process; 
--feed into comparator
--feed results into signals
--update signals

remain <= (others=>'0'); 

Sequential_PROCESS : process (start,clk,count,remainsingle,remain,
DividendTemp,DivisorTemp, quotientsingle, quot, quotientfull)

begin
if (start='1') then 
if (rising_edge(clk) and Count>=DIVIDEND_WIDTH-1) then
--remainsingle<=remain(DIVIDEND_WIDTH-1-Count);
--quotientsingle<=quotientfull(Count);
--concatdividend(DIVIDEND_WIDTH-1-Count) <= (remain(DIVIDEND_WIDTH-1-Count)&DividendTemp(Count));
--concatsingle<=concatdividend(DIVIDEND_WIDTH-1-Count);
sigdiv(0) <= DividendTemp(DIVIDEND_WIDTH - 1);
sigdiv(DIVISOR_WIDTH downto 1) <= remain;
quot(DIVIDEND_WIDTH - 1 downto 0) <= quotientfull;
quot(DIVIDEND_WIDTH) <= quotientsingle;

Count<=Count-1;

elsif(rising_edge(clk) and Count <= DIVIDEND_WIDTH-1 and Count >= 0) then
sigdiv(0) <= dividend(Count);
sigdiv(DIVISOR_WIDTH downto 1) <= remainsingle;
quot(Count + 1) <= quotientsingle;
Count <= Count - 1;
elsif(rising_edge(clk) and Count = -1) then
quot(Count + 1) <= quotientsingle;
end if;
else
Count <= DIVIDEND_WIDTH - 1;
end if;
end process;

C1 : comparator Port Map(
	DINL=>sigdiv,
	DINR=>DivisorTemp,
	DOUT=>remainsingle,
	isGreaterEq=>quotientsingle);


remainder <= remainsingle;
quotient <= quot(DIVIDEND_WIDTH-1 downto 0);

end architecture;

