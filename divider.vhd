library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use work.divider_const.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here

entity divider is
port(
--Inputs
clk : in std_logic;
reset: in std_logic; 
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


------------------------------------------------------------------------
------------------------------------------------------------------------
architecture FSMbehavior of divider is 
signal a: std_logic_vector(DIVISOR_WIDTH-1 downto 0); 
signal b: std_logic_vector(DIVIDEND_WIDTH-1 downto 0); 
signal state: std_logic_vector(2 downto 0) := "000";
signal next_state: std_logic_vector(2 downto 0) := "000";
signal p: integer;
signal c: std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal q: std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal sign: std_logic;

function get_msb_pos(signal data: std_logic_vector) 
return integer is 
variable count : integer range 0 to 31 := 0; 

begin
for i in data'low to data'high loop
if (data(31-i) ='1') then
count:=31-i; 
exit; 
end if;
end loop; 

return(count);
end function get_msb_pos;


begin 


p1: process (clk, start) is 
begin
   if (rising_edge(clk)) then
       if start = '1' then
          overflow<='0';
			 a <= abs(divisor);
          b <= abs(dividend); 
        else 
          overflow<='1';         
	  end if;
     end if;
end process;

p2: process (sigdivisor) is
begin
if (to_integer(unsigned(sigdivisor)) /= 0) then
overflow <= '0';
else
overflow <= '1';
end if;
end process;

statelogic: process (state) is
begin
case state is
	when "000" =>
	if (b /= 0 and b < a) then
		next_state <= "001";
	else
		next_state <= "100";
	end if;
	when "001" =>
	p <= get_msb_pos(a) - get_msb_pos(b);
	c <= b sll p;
	if (c>a) then
		next_state <= "010";
	else
		next_state <= "011";
	end if;
	when "010" => 
	p <= p-1;
	c <= b sll p;
	next_state <= "011";
	when "011" =>
	q <= q+(1 sll p);
	a <= a - (b sll p);
	next_state <= "000";
	when "100" =>
	sign <= (dividend sra (DIVIDEND_WIDTH-1)) xor (divisor sra (DIVISOR_WIDTH-1));
	if sign = 1 then
	quotient <= q;
	else
	quotient <= -q;
	end if;
	if (dividend sra (DIVIDEND_WIDTH-1)) = 1 then
	remainder <= -a;
	else
	remainder <= a;
	end if;
end case;
end process statelogic;

Statereg: process (clk, reset) is
begin
if rising_edge(clk) then
	state <= next_state;
elsif (reset = 1) then
	state <= "000";
	next_state <= "000";
end if;
end process Statereg;



end architecture; 


