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
signal sigdivisor: std_logic_vector(DIVISOR_WIDTH-1 downto 0); 
signal sigdividend: std_logic_vector(DIVIDEND_WIDTH -1 downto 0); 


function get_msb_pos(signal data: std_logic_vector) 
return integer is 
variable count : integer range 0 to 31 := 0; 

begin
for i in data'low to data'high loop
if (data(31-i) ='1') then
count:=31-i; 
exit ; 
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
	  sigdivisor <= divisor;
          sigdividend <= dividend; 
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




end architecture; 


