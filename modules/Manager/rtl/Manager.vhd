---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file Manager.vhd
--!
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

      btns_i   : in slv(4 - 1 downto 0);
      switch_i : in slv(4 - 1 downto 0);

      leds_o      : out slv(4 - 1 downto 0);
      redLeds_o   : out slv(4 - 1 downto 0);
      greenLeds_o : out slv(4 - 1 downto 0);
      blueLeds_o  : out slv(4 - 1 downto 0)
   );
end Manager;
---------------------------------------------------------------------------------------------------
architecture rtl of Manager is

   signal btnsState : slv(btns_i'range);

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
         btnsState_o => btnsState
      );

   redLeds_o   <= btnsState;
   greenLeds_o <= not(btnsState);
   blueLeds_o  <= btnsState;

   -- enable leds with switch
   leds_o <= switch_i;

end rtl;
---------------------------------------------------------------------------------------------------