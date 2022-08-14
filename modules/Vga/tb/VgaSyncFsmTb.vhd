---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncFsmTb.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaSyncFsmTb is
end VgaSyncFsmTb;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncFsmTb is

   constant T_C         : time := 10 ns;
   constant TPD_C       : time := 1 ns;
   constant RST_DELAY_C : time := 100 ns;
   constant RST_HOLD_C  : time := 100 ns;

   constant VGA_TYPE_C : VgaType := VESA_640x480_AT_75HZ_C;

   signal clk_i : sl;
   signal rst_i : sl;

   signal hinc_i     : sl;
   signal hinc_o     : sl;
   signal hcnt_o     : slv(bitsize(VGA_TYPE_C.horizontalTiming.whole) - 1 downto 0);
   signal hvisible_o : sl;
   signal hsync_o    : sl;

   signal vinc_i     : sl;
   signal vinc_o     : sl;
   signal vcnt_o     : slv(bitsize(VGA_TYPE_C.verticalTiming.whole) - 1 downto 0);
   signal vvisible_o : sl;
   signal vsync_o    : sl;


---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Unit Under Test
   -----------------------------------------------------------------------------
   uut_HorizontalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G        => TPD_C,
         VGA_TIMING_G => VGA_TYPE_C.horizontalTiming
      )
      port map (
         clk_i     => clk_i,
         rst_i     => rst_i,
         inc_i     => hinc_i,
         inc_o     => hinc_o,
         cnt_o     => hcnt_o,
         visible_o => hvisible_o,
         sync_o    => hsync_o
      );

   vinc_i <= hinc_o;

   uut_VerticlaSync : entity work.VgaSyncFsm
      generic map (
         TPD_G        => TPD_C,
         VGA_TIMING_G => VGA_TYPE_C.verticalTiming
      )
      port map (
         clk_i     => clk_i,
         rst_i     => rst_i,
         inc_i     => vinc_i,
         inc_o     => vinc_o,
         cnt_o     => vcnt_o,
         visible_o => vvisible_o,
         sync_o    => vsync_o
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
         clkP => clk_i,
         rst  => rst_i
      );

   -----------------------------------------------------------------------------
   -- Simulation process
   -----------------------------------------------------------------------------
   p_Sim : process
   begin

      hinc_i <= '0';
      wait for 1_000 * T_C;
      hinc_i <= '1';

      wait for 10_000_000 * T_C;
      assert false report "Simulation Passed!" severity failure;

   end process p_Sim;

end rtl;
---------------------------------------------------------------------------------------------------