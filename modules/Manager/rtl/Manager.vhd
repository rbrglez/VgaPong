---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file Manager.vhd
--!
--! Copyright (c) 2020 Cosylab d.d.
--! This software is distributed under the terms found
--! in file LICENSE.txt that is included with this distribution.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

use work.MarkDebugPkg.all;

entity Manager is
   generic (
      TPD_G : time := 1 ns
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      leds_o    : out slv(4-1 downto 0);
      rgbLeds_o : out slv(12-1 downto 0);

      btns_i   : in slv(4-1 downto 0);
      switch_i : in slv(4-1 downto 0)
   );
end Manager;
---------------------------------------------------------------------------------------------------
architecture rtl of Manager is

   signal enRgbLeds : slv(4-1 downto 0);

---------------------------------------------------------------------------------------------------
begin

   u_BtnController : entity work.BtnController
      generic map (
         TPD_G            => TPD_G,
         BTN_WIDTH_G      => btns_i'length,
         POSITIVE_LOGIC_G => true
      )
      port map (
         clk_i       => clk_i,
         rst_i       => rst_i,
         btns_i      => btns_i,
         btnsState_o => enRgbLeds
      );

   rgbLeds_o(2 downto 0)  <= (others => enRgbLeds(0));
   rgbLeds_o(5 downto 3)  <= (others => enRgbLeds(1));
   rgbLeds_o(8 downto 6)  <= (others => enRgbLeds(2));
   rgbLeds_o(11 downto 9) <= (others => enRgbLeds(3));

   -- enable leds with switch
   leds_o <= switch_i;

end rtl;
---------------------------------------------------------------------------------------------------