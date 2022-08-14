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
      TPD_G      : time    := 1 ns;
      VGA_TYPE_G : VgaType := VESA_640x480_AT_75HZ_C
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      hsync_o : out sl;
      vsync_o : out sl;

      column_o : out slv(bitSize(VGA_TYPE_G.horizontalTiming.whole) - 1 downto 0);
      row_o    : out slv(bitSize(VGA_TYPE_G.verticalTiming.whole) - 1 downto 0)
   );
end VgaSyncCtrl;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaSyncCtrl is

   --! FSM state record
   type StateType is (
         HORIZONTAL_S,
         VERTICAL_S
      );

   type RegType is record
      hcnt : unsigned(column_o'range);
      vcnt : unsigned(row_o'range);
      --
      hsync : sl;
      vsync : sl;
      --
      state : StateType;
   end record RegType;

   constant REG_INIT_C : RegType := (
         hcnt => (others => '0'),
         vcnt => (others => '0'),
         --
         hsync => '0',
         vsync => '0',
         --
         state => HORIZONTAL_S
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

      v.hsync := '0';
      v.vsync := '0';

      -- State Machine
      case r.state is
         ----------------------------------------------------------------------
         when HORIZONTAL_S =>
            --
            v.hcnt := r.hcnt + 1;

            if (r.hcnt = VGA_TYPE_G.horizontalTiming.whole - 1) then
               v.hcnt  := to_unsigned(0, r.hcnt'length);
               v.hsync := '1';
               v.state := VERTICAL_S;
            end if;

         ----------------------------------------------------------------------
         when VERTICAL_S =>

            v.vcnt := r.vcnt + 1;

            if (r.vcnt = VGA_TYPE_G.verticalTiming.whole - 1) then
               v.vcnt := to_unsigned(0, r.vcnt'length);
            end if;

            v.vsync := '1';
            v.state := HORIZONTAL_S;

         ----------------------------------------------------------------------
         when others =>
            v := REG_INIT_C;
      ----------------------------------------------------------------------
      end case;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      hsync_o <= r.hsync;
      vsync_o <= r.vsync;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------