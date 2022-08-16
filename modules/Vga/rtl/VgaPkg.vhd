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

   -----------------------------------------------------------------------------
   constant VGA_GENERAL_TIMING_SLV_WIDTH_C : natural := 32;
   constant VGA_TIMING_SLV_WIDTH_C         : natural := 32;

   type VgaGeneralTimingType is record
      screenRefreshRate : slv(VGA_GENERAL_TIMING_SLV_WIDTH_C - 1 downto 0);
      verticalRefresh   : slv(VGA_GENERAL_TIMING_SLV_WIDTH_C - 1 downto 0);
      pixelFreq         : slv(VGA_GENERAL_TIMING_SLV_WIDTH_C - 1 downto 0);
   end record VgaGeneralTimingType;

   type VgaTimingType is record
      visibleArea : slv(VGA_TIMING_SLV_WIDTH_C - 1 downto 0);
      frontPorch  : slv(VGA_TIMING_SLV_WIDTH_C - 1 downto 0);
      syncPulse   : slv(VGA_TIMING_SLV_WIDTH_C - 1 downto 0);
      backPorch   : slv(VGA_TIMING_SLV_WIDTH_C - 1 downto 0);
      whole       : slv(VGA_TIMING_SLV_WIDTH_C - 1 downto 0);
   end record VgaTimingType;

   type VgaSettingsType is record
      generalTiming    : VgaGeneralTimingType;
      horizontalTiming : VgaTimingType;
      verticalTiming   : VgaTimingType;
   end record VgaSettingsType;

   -----------------------------------------------------------------------------

   constant VESA_640x480_AT_75HZ_C : VgaSettingsType := (

         generalTiming => (
         screenRefreshRate => toSlv(75, VGA_GENERAL_TIMING_SLV_WIDTH_C),
         verticalRefresh   => toSlv(37500, VGA_GENERAL_TIMING_SLV_WIDTH_C),
         pixelFreq         => toSlv(31500000, VGA_GENERAL_TIMING_SLV_WIDTH_C)),

         horizontalTiming => (
         visibleArea => toSlv(640, VGA_TIMING_SLV_WIDTH_C),
         frontPorch  => toSlv(16, VGA_TIMING_SLV_WIDTH_C),
         syncPulse   => toSlv(64, VGA_TIMING_SLV_WIDTH_C),
         backPorch   => toSlv(120, VGA_TIMING_SLV_WIDTH_C),
         whole       => toSlv(840, VGA_TIMING_SLV_WIDTH_C)),

         verticalTiming => (
         visibleArea => toSlv(480, VGA_TIMING_SLV_WIDTH_C),
         frontPorch  => toSlv(1, VGA_TIMING_SLV_WIDTH_C),
         syncPulse   => toSlv(3, VGA_TIMING_SLV_WIDTH_C),
         backPorch   => toSlv(16, VGA_TIMING_SLV_WIDTH_C),
         whole       => toSlv(500, VGA_TIMING_SLV_WIDTH_C))
      );

   constant VESA_640x350_AT_85HZ_C : VgaSettingsType := (

         generalTiming => (
         screenRefreshRate => toSlv(85, VGA_GENERAL_TIMING_SLV_WIDTH_C),
         verticalRefresh   => toSlv(37861, VGA_GENERAL_TIMING_SLV_WIDTH_C),
         pixelFreq         => toSlv(31500000, VGA_GENERAL_TIMING_SLV_WIDTH_C)),

         horizontalTiming => (
         visibleArea => toSlv(640, VGA_TIMING_SLV_WIDTH_C),
         frontPorch  => toSlv(32, VGA_TIMING_SLV_WIDTH_C),
         syncPulse   => toSlv(64, VGA_TIMING_SLV_WIDTH_C),
         backPorch   => toSlv(96, VGA_TIMING_SLV_WIDTH_C),
         whole       => toSlv(832, VGA_TIMING_SLV_WIDTH_C)),

         verticalTiming => (
         visibleArea => toSlv(350, VGA_TIMING_SLV_WIDTH_C),
         frontPorch  => toSlv(32, VGA_TIMING_SLV_WIDTH_C),
         syncPulse   => toSlv(3, VGA_TIMING_SLV_WIDTH_C),
         backPorch   => toSlv(60, VGA_TIMING_SLV_WIDTH_C),
         whole       => toSlv(445, VGA_TIMING_SLV_WIDTH_C))
      );


   constant VGA_TIMING_INIT_C : VgaTimingType := (
         visibleArea => (others => '0'),
         frontPorch  => (others => '0'),
         syncPulse   => (others => '0'),
         backPorch   => (others => '0'),
         whole       => (others => '0')
      );

end VgaPkg;

package body VgaPkg is
end package body VgaPkg;
