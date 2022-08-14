---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncCtrlTb.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaSyncCtrlTb is
end VgaSyncCtrlTb;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncCtrlTb is

   constant T_C         : time := 10 ns;
   constant TPD_C       : time := 1 ns;
   constant RST_DELAY_C : time := 100 ns;
   constant RST_HOLD_C  : time := 100 ns;

   constant VGA_TYPE_C : VgaType := VESA_640x480_AT_75HZ_C;

   signal clk : sl;
   signal rst : sl;

   signal hsync_o  : sl;
   signal vsync_o  : sl;
   signal column_o : slv(bitSize(VGA_TYPE_C.horizontalTiming.whole) - 1 downto 0);
   signal row_o    : slv(bitSize(VGA_TYPE_C.verticalTiming.whole) - 1 downto 0);

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Unit Under Test
   -----------------------------------------------------------------------------
   uut_VgaSyncCtrl : entity work.VgaSyncCtrl
      generic map (
         TPD_G      => TPD_C,
         VGA_TYPE_G => VGA_TYPE_C
      )
      port map (
         clk_i    => clk,
         rst_i    => rst,
         hsync_o  => hsync_o,
         vsync_o  => vsync_o,
         column_o => column_o,
         row_o    => row_o
      );

   -----------------------------------------------------------------------------
   -- Clock and reset
   ----------------------------------------------------------------------------- 
   u_ClkRst : entity surf.ClkRst
      generic map (
         CLK_PERIOD_G      => T_C,
         RST_START_DELAY_G => RST_DELAY_C,
         RST_HOLD_TIME_G   => RST_HOLD_C
      )
      port map (
         clkP => clk,
         rst  => rst
      );

end rtl;
---------------------------------------------------------------------------------------------------