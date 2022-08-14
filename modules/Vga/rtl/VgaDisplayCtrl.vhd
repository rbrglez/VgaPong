---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file VgaDisplayCtrl.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library surf;
use surf.StdRtlPkg.all;

use work.VgaPkg.all;

entity VgaDisplayCtrl is
   generic (
      TPD_G : time    := 1 ns;
      VGA_G : VgaType := VESA_640x480_AT_75HZ_C
   );
   port (
      clk_i : in sl;
      rst_i : in sl;
      en_i  : in sl;

      hcnt_i : in slv(bitSize(VGA_G.horizontalTiming.whole) - 1 downto 0);
      vcnt_i : in slv(bitSize(VGA_G.verticalTiming.whole) - 1 downto 0);

      -- TODO: use generics for range
      red_o   : out slv(4 - 1 downto 0);
      green_o : out slv(4 - 1 downto 0);
      blue_o  : out slv(4 - 1 downto 0)

   );
end VgaDisplayCtrl;
---------------------------------------------------------------------------------------------------
architecture rtl of VgaDisplayCtrl is


   type RegType is record
      red   : slv(red_o'range);
      green : slv(green_o'range);
      blue  : slv(blue_o'range);
   end record RegType;

   constant REG_INIT_C : RegType := (
         red   => (others => '0'),
         green => (others => '0'),
         blue  => (others => '0')
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

      if (
            unsigned(hcnt_i) < VGA_G.horizontalTiming.visibleArea and
            unsigned(vcnt_i) < VGA_G.verticalTiming.visibleArea
         ) then

         -- 1 quad
         if(
               unsigned(hcnt_i) < VGA_G.horizontalTiming.visibleArea / 2 and
               unsigned(vcnt_i) < VGA_G.verticalTiming.visibleArea / 2
            ) then
            v.red   := x"F";
            v.green := x"D";
            v.blue  := x"4";

         -- 2 quad
         elsif (
               unsigned(hcnt_i) < VGA_G.horizontalTiming.visibleArea and
               unsigned(vcnt_i) < VGA_G.verticalTiming.visibleArea / 2
            ) then
            v.red   := x"F";
            v.green := x"4";
            v.blue  := x"D";

         -- 3 quad
         elsif (
               unsigned(hcnt_i) < VGA_G.horizontalTiming.visibleArea / 2 and
               unsigned(vcnt_i) < VGA_G.verticalTiming.visibleArea
            ) then
            v.red   := x"4";
            v.green := x"D";
            v.blue  := x"F";

         -- 4 quad
         else
            v.red   := x"D";
            v.green := x"F";
            v.blue  := x"4";
         end if;
      else
         v.red   := (others => '0');
         v.green := (others => '0');
         v.blue  := (others => '0');
      end if;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs     
      red_o   <= r.red;
      green_o <= r.green;
      blue_o  <= r.blue;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;
end rtl;
---------------------------------------------------------------------------------------------------