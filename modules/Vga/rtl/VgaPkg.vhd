---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaPkg.vhd
--!
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

package VgaPkg is

   -- http://tinyvga.com/vga-timing

   type VgaGeneralTimingType is record
      screenRefreshRate : natural;
      verticalRefresh   : natural;
      pixelFreq         : natural;
   end record VgaGeneralTimingType;

   type VgaTimingType is record
      visibleArea : natural;
      frontPorch  : natural;
      syncPulse   : natural;
      backPorch   : natural;
      whole       : natural;
   end record VgaTimingType;

   type VgaType is record
      generalTiming    : VgaGeneralTimingType;
      horizontalTiming : VgaTimingType;
      verticalTiming   : VgaTimingType;
   end record VgaType;


   constant VESA_640x480_AT_75HZ_C : VgaType := (

         generalTiming => (
         screenRefreshRate => 75,
         verticalRefresh   => 37500,
         pixelFreq         => 31500000),

         horizontalTiming => (
         visibleArea => 640,
         frontPorch  => 16,
         syncPulse   => 64,
         backPorch   => 120,
         whole       => 840),

         verticalTiming => (
         visibleArea => 480,
         frontPorch  => 1,
         syncPulse   => 3,
         backPorch   => 16,
         whole       => 500)
      );

end VgaPkg;

package body VgaPkg is
end package body VgaPkg;
