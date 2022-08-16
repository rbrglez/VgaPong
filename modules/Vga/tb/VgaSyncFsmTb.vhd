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

   constant CNT_WIDTH_C : natural := 32;


   signal clk_i : sl;
   signal rst_i : sl;

   signal updVga_i      : sl;
   signal vgaSettings_i : VgaSettingsType;

   signal hcntEn_i   : sl;
   signal hcntEn_o   : sl;
   signal hcnt_o     : slv(CNT_WIDTH_C - 1 downto 0);
   signal hvisible_o : sl;
   signal hsync_o    : sl;

   signal vcntEn_i   : sl;
   signal vcntEn_o   : sl;
   signal vcnt_o     : slv(CNT_WIDTH_C - 1 downto 0);
   signal vvisible_o : sl;
   signal vsync_o    : sl;


---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Unit Under Test
   -----------------------------------------------------------------------------
   uut_HorizontalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G       => TPD_C,
         CNT_WIDTH_G => CNT_WIDTH_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         updVga_i    => updVga_i,
         vgaTiming_i => vgaSettings_i.horizontalTiming,

         cntEn_i => hcntEn_i,
         cntEn_o => hcntEn_o,

         cnt_o     => hcnt_o,
         visible_o => hvisible_o,
         sync_o    => hsync_o
      );

   vcntEn_i <= hcntEn_o;

   uut_VerticlaSync : entity work.VgaSyncFsm
      generic map (
         TPD_G       => TPD_C,
         CNT_WIDTH_G => CNT_WIDTH_C
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         updVga_i    => updVga_i,
         vgaTiming_i => vgaSettings_i.horizontalTiming,

         cntEn_i => vcntEn_i,
         cntEn_o => vcntEn_o,

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

      updVga_i      <= '0';
      vgaSettings_i <= VESA_640x480_AT_75HZ_C;
      hcntEn_i      <= '0';

      wait until rst_i = '1';
      wait until rst_i = '0';

      wait for 10 * T_C;
      wait for TPD_C;

      updVga_i      <= '1';
      vgaSettings_i <= VESA_640x480_AT_75HZ_C;

      wait for T_C;
      wait for TPD_C;

      updVga_i <= '0';

      hcntEn_i <= '0';
      wait for 1_000 * T_C;
      hcntEn_i <= '1';


      wait until vsync_o = '0';
      wait until vsync_o = '1';

      wait until vsync_o = '0';
      wait until vsync_o = '1';

      updVga_i      <= '1';
      vgaSettings_i <= VESA_640x350_AT_85HZ_C;

      wait for T_C;
      wait for TPD_C;

      updVga_i <= '0';


      wait until vsync_o = '0';
      wait until vsync_o = '1';

      wait until vsync_o = '0';
      wait until vsync_o = '1';

      wait until vsync_o = '0';
      wait until vsync_o = '1';

      assert false report "Simulation Passed!" severity failure;

   end process p_Sim;

end rtl;
---------------------------------------------------------------------------------------------------