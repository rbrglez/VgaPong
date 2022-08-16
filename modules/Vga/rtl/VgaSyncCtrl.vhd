---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncCtrl.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaSyncCtrl is
   generic (
      TPD_G       : time    := 1 ns;
      CNT_WIDTH_G : natural := 32
   );
   port (
      clk_i : in sl;
      rst_i : in sl;
      en_i  : in sl;
      -- Vga settings
      updVga_i      : in sl;
      vgaSettings_i : in VgaSettingsType;
      -- horizontal
      hsync_o    : out sl;
      hvisible_o : out sl;
      hcnt_o     : out slv(CNT_WIDTH_G - 1 downto 0);
      -- vertical
      vsync_o    : out sl;
      vvisible_o : out sl;
      vcnt_o     : out slv(CNT_WIDTH_G - 1 downto 0)
   );
end VgaSyncCtrl;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncCtrl is

   signal h2vCntEn : sl;

---------------------------------------------------------------------------------------------------
begin

   u_HorizontalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G       => TPD_G,
         CNT_WIDTH_G => CNT_WIDTH_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         updVga_i    => updVga_i,
         vgaTiming_i => vgaSettings_i.horizontalTiming,

         cntEn_i => en_i,
         cntEn_o => h2vCntEn,

         cnt_o     => hcnt_o,
         visible_o => hvisible_o,
         sync_o    => hsync_o
      );

   u_VerticalSync : entity work.VgaSyncFsm
      generic map (
         TPD_G       => TPD_G,
         CNT_WIDTH_G => CNT_WIDTH_G
      )
      port map (
         clk_i => clk_i,
         rst_i => rst_i,

         updVga_i    => updVga_i,
         vgaTiming_i => vgaSettings_i.verticalTiming,

         cntEn_i => h2vCntEn,
         cntEn_o => open,

         cnt_o     => vcnt_o,
         visible_o => vvisible_o,
         sync_o    => vsync_o
      );

end rtl;
---------------------------------------------------------------------------------------------------