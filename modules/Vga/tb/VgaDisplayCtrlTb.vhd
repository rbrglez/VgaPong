---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaDisplayCtrlTb.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaDisplayCtrlTb is
end VgaDisplayCtrlTb;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaDisplayCtrlTb is

   constant T_C         : time := 10 ns;
   constant TPD_C       : time := 1 ns;
   constant RST_DELAY_C : time := 100 ns;
   constant RST_HOLD_C  : time := 100 ns;

   constant VGA_C : VgaType := VESA_640x480_AT_75HZ_C;

   signal clk_i : sl;
   signal rst_i : sl;
   signal en_i  : sl;

   signal hcnt : slv(bitSize(VGA_C.horizontalTiming.whole) - 1 downto 0);
   signal vcnt : slv(bitSize(VGA_C.verticalTiming.whole) - 1 downto 0);

   signal red_o   : slv(4 - 1 downto 0);
   signal green_o : slv(4 - 1 downto 0);
   signal blue_o  : slv(4 - 1 downto 0);


   signal hsync_o    : sl;
   signal hvisible_o : sl;

   signal vsync_o    : sl;
   signal vvisible_o : sl;

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Unit Under Test
   -----------------------------------------------------------------------------
   uut_VgaDisplayCtrl : entity work.VgaDisplayCtrl
      generic map (
         TPD_G => TPD_C,
         VGA_G => VGA_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,
         en_i  => en_i,

         hcnt_i => hcnt,
         vcnt_i => vcnt,

         red_o   => red_o,
         green_o => green_o,
         blue_o  => blue_o
      );

   u_VgaSyncCtrl : entity work.VgaSyncCtrl
      generic map (
         TPD_G => TPD_C,
         VGA_G => VGA_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,
         en_i  => en_i,

         hsync_o    => hsync_o,
         hvisible_o => hvisible_o,
         hcnt_o     => hcnt,

         vsync_o    => vsync_o,
         vvisible_o => vvisible_o,
         vcnt_o     => vcnt
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

      en_i <= '0';
      wait for 1_000 * T_C;
      en_i <= '1';

      wait for 3_000_000 * T_C;
      assert false report "Simulation Passed!" severity failure;

   end process p_Sim;

end rtl;
---------------------------------------------------------------------------------------------------