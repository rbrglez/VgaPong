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

      vPaddlePos_i : in slv(bitSize(VGA_G.verticalTiming.whole) - 1 downto 0);

      vBallPos_i : in slv(bitSize(VGA_G.verticalTiming.whole) - 1 downto 0);
      hBallPos_i : in slv(bitSize(VGA_G.horizontalTiming.whole) - 1 downto 0);

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

   constant BORDER_WIDTH_C : natural := 8;

   constant PADDLE_LEFT_C   : natural := 28;
   constant PADDLE_RIGHT_C  : natural := PADDLE_LEFT_C + 8;
   constant PADDLE_TOP_C    : natural := 100;
   constant PADDLE_BOTTOM_C : natural := PADDLE_TOP_C + 64;

   constant BALL_LEFT_C   : natural := 300;
   constant BALL_RIGHT_C  : natural := BALL_LEFT_C + 8;
   constant BALL_TOP_C    : natural := 300;
   constant BALL_BOTTOM_C : natural := BALL_TOP_C + 8;


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


         -----------------------------------------------------------------------
         -- BORDER
         -----------------------------------------------------------------------
         if (
               unsigned(vcnt_i) < BORDER_WIDTH_C or                                    -- top border
               unsigned(vcnt_i) > VGA_G.verticalTiming.visibleArea - BORDER_WIDTH_C or -- bottom border
               unsigned(hcnt_i) > VGA_G.horizontalTiming.visibleArea - BORDER_WIDTH_C  -- right border
            ) then

            v.red   := x"F";
            v.green := x"D";
            v.blue  := x"4";

         elsif (
               unsigned(hcnt_i) > PADDLE_LEFT_C and           -- left paddle border
               unsigned(hcnt_i) < PADDLE_RIGHT_C and          -- right paddle border
               unsigned(vcnt_i) > unsigned(vPaddlePos_i) and  -- top paddle border
               unsigned(vcnt_i) < unsigned(vPaddlePos_i) + 64 -- bottom paddle border
            ) then
            -- paddle

            v.red   := x"4";
            v.green := x"D";
            v.blue  := x"F";

         elsif (
               unsigned(hcnt_i) > unsigned(hBallPos_i) and     -- left paddle border
               unsigned(hcnt_i) < unsigned(hBallPos_i) + 8 and -- right paddle border
               unsigned(vcnt_i) > unsigned(vBallPos_i) and     -- top paddle border
               unsigned(vcnt_i) < unsigned(vBallPos_i) + 8     -- bottom paddle border
            ) then
            -- ball

            v.red   := x"D";
            v.green := x"F";
            v.blue  := x"4";

         else
            -- background
            v.red   := x"F";
            v.green := x"4";
            v.blue  := x"D";

         end if;


         /*

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
         */

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