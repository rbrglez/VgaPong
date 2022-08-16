---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaSyncFsm.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaSyncFsm is
   generic (
      TPD_G       : time    := 1 ns;
      CNT_WIDTH_G : natural := 32
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      updVga_i    : in sl;
      vgaTiming_i : in VgaTimingType;

      cntEn_i : in  sl;
      cntEn_o : out sl;

      cnt_o     : out slv(CNT_WIDTH_G - 1 downto 0);
      visible_o : out sl;
      sync_o    : out sl
   );
end VgaSyncFsm;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncFsm is

   --! FSM state record
   type StateType is (
         VISIBLE_S,
         FRONT_PORCH_S,
         SYNC_S,
         BACK_PORCH_S
      );

   type RegType is record
      cnt       : unsigned(cnt_o'range);
      sync      : sl;
      cntEnOut  : sl;
      visible   : sl;
      updVga    : sl;
      vgaTiming : VgaTimingType;
      --
      state : StateType;
   end record RegType;

   constant REG_INIT_C : RegType := (
         cnt       => (others => '0'),
         sync      => '1',
         cntEnOut  => '0',
         visible   => '0',
         updVga    => '0',
         vgaTiming => VGA_TIMING_INIT_C,
         --
         state => VISIBLE_S
      );

   --! Output of registers
   signal r : RegType;

   --! Combinatorial input to registers
   signal rin : RegType;

---------------------------------------------------------------------------------------------------
begin

   p_Comb : process (all) is
      variable v : RegType;
   begin
      -- Latch the current value
      v := r;

      v.updVga := updVga_i;

      -- Rising edge detector
      if (updVga_i = '1' and r.updVga = '0') then
         -- reset FSM
         v := REG_INIT_C;
         -- register new vga settings
         v.vgaTiming := vgaTiming_i;
      end if;

      v.cntEnOut := '0';

      -- NOTE: state machine is active if cntEn_i port is high
      if (cntEn_i = '1') then

         v.cnt := r.cnt + 1;

         -- State Machine
         case r.state is
            ----------------------------------------------------------------------
            when VISIBLE_S =>
               --
               v.visible := '1';

               if (r.cnt = unsigned(r.vgaTiming.visibleArea) - 1) then
                  v.visible := '0';
                  v.sync    := '1';
                  v.state   := FRONT_PORCH_S;
               end if;

            ----------------------------------------------------------------------
            when FRONT_PORCH_S =>

               if (
                     r.cnt =
                     unsigned(r.vgaTiming.visibleArea) +
                     unsigned(r.vgaTiming.frontPorch) - 1
                  ) then
                  v.visible := '0';
                  v.sync    := '0';
                  v.state   := SYNC_S;

               end if;

            ----------------------------------------------------------------------
            when SYNC_S =>

               if (
                     r.cnt =
                     unsigned(r.vgaTiming.visibleArea) +
                     unsigned(r.vgaTiming.frontPorch) +
                     unsigned(r.vgaTiming.syncPulse) - 1
                  ) then
                  v.visible := '0';
                  v.sync    := '1';
                  v.state   := BACK_PORCH_S;

               end if;

            ----------------------------------------------------------------------
            when BACK_PORCH_S =>

               if (
                     r.cnt =
                     unsigned(r.vgaTiming.visibleArea) +
                     unsigned(r.vgaTiming.frontPorch) +
                     unsigned(r.vgaTiming.syncPulse) +
                     unsigned(r.vgaTiming.backPorch) - 1
                  ) then
                  v.visible  := '1';
                  v.cnt      := to_unsigned(0, r.cnt'length);
                  v.sync     := '1';
                  v.state    := VISIBLE_S;
                  v.cntEnOut := '1';

               end if;

            ----------------------------------------------------------------------
            when others =>
               v := REG_INIT_C;
         ----------------------------------------------------------------------
         end case;

      end if;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      sync_o    <= r.sync;
      cnt_o     <= slv(r.cnt);
      visible_o <= r.visible;
      cntEn_o   <= r.cntEnOut;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------