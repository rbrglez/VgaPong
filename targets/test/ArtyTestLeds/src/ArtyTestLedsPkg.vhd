---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file ArtyTestLedsPkg.vhd
--!
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;


package ArtyTestLedsPkg is

   -- period = Fclk/Fpwm
   constant LEDS_PERIOD_C      : positive := 10_000; -- 10kHz @ Fclk=100MHz 
   constant LEDS_PERIOD_SIZE_C : positive := bitSize(LEDS_PERIOD_C);

   constant LEDS_PERIOD_SLV_C : slv(LEDS_PERIOD_SIZE_C-1 downto 0) :=
      toSlv(LEDS_PERIOD_C,LEDS_PERIOD_SIZE_C);

   -- period = Fclk/Fpwm
   constant RGB_LEDS_PERIOD_C      : positive := 10_000; -- 10kHz @ Fclk=100MHz 
   constant RGB_LEDS_PERIOD_SIZE_C : positive := bitSize(RGB_LEDS_PERIOD_C);

   constant RGB_LEDS_PERIOD_SLV_C : slv(RGB_LEDS_PERIOD_SIZE_C-1 downto 0) :=
      toSlv(RGB_LEDS_PERIOD_C,RGB_LEDS_PERIOD_SIZE_C);

end ArtyTestLedsPkg;

package body ArtyTestLedsPkg is

end package body ArtyTestLedsPkg;
