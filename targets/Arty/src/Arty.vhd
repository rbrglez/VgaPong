---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file Arty.vhd
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
library UNISIM;
use UNISIM.VComponents.all;

entity Arty is
   generic (
      TPD_G           : time     := 1 ns;
      DEBOUNCE_TIME_G : positive := 5000000 --50 ms debounce time
   );
   port (
      CLK100MHZ : in sl;
      ck_rst    : in sl;

      -- RGB LEDs
      led0_b : out sl;
      led0_g : out sl;
      led0_r : out sl;
      led1_b : out sl;
      led1_g : out sl;
      led1_r : out sl;
      led2_b : out sl;
      led2_g : out sl;
      led2_r : out sl;
      led3_b : out sl;
      led3_g : out sl;
      led3_r : out sl;

      -- white LEDs
      led : out slv(3 downto 0);

      -- buttons
      btn : in slv(3 downto 0);

      -- switches
      sw : in slv(3 downto 0)

   );
end Arty;
---------------------------------------------------------------------------------------------------    
architecture rtl of Arty is

   signal Manager_rgbLeds : slv(12 - 1 downto 0);
   signal Io_rgbLeds      : slv(12 - 1 downto 0);

   signal Manager_leds : slv(led'range);
   signal Io_leds      : slv(led'range);

   signal Io_btn : slv(btn'range);
   signal Io_sw  : slv(sw'range);

   signal clk  : sl;
   signal rst  : sl;
   signal rstn : sl;

   attribute mark_debug                    : string;
   attribute mark_debug of clk             : signal is TOP_C;
   attribute mark_debug of rst             : signal is TOP_C;
   attribute mark_debug of rstn            : signal is TOP_C;
   attribute mark_debug of Io_btn          : signal is TOP_C;
   attribute mark_debug of Io_sw           : signal is TOP_C;
   attribute mark_debug of Manager_leds    : signal is TOP_C;
   attribute mark_debug of Io_leds         : signal is TOP_C;
   attribute mark_debug of Manager_rgbLeds : signal is TOP_C;
   attribute mark_debug of Io_rgbLeds      : signal is TOP_C;

---------------------------------------------------------------------------------------------------
begin

   -- clock and reset signals
   clk <= CLK100MHZ;
   rst <= not(rstn);

   -- if BUF isn't included there are errors
   u_BUF : entity work.BUF
      port map (
         O => rstn,
         I => ck_rst
      );

   u_Manager : entity work.Manager
      generic map (
         TPD_G => TPD_G
      )
      port map (
         clk_i     => clk,
         rst_i     => rst,
         leds_o    => Manager_leds,
         rgbLeds_o => Manager_rgbLeds,
         btns_i    => Io_btn,
         switch_i  => Io_sw
      );

   u_Io : entity work.Io
      generic map (
         TPD_G           => TPD_G,
         DEBOUNCE_TIME_G => DEBOUNCE_TIME_G
      )
      port map (
         clk_i     => clk,
         rst_i     => rst,
         rgbLeds_o => Io_rgbLeds,
         rgbLeds_i => Manager_rgbLeds,
         leds_o    => Io_leds,
         leds_i    => Manager_leds,
         switch_i  => sw,
         switch_o  => Io_sw,
         btns_i    => btn,
         btns_o    => Io_btn
      );

   led3_r <= Io_rgbLeds(11);
   led3_g <= Io_rgbLeds(10);
   led3_b <= Io_rgbLeds(9);

   led2_r <= Io_rgbLeds(8);
   led2_g <= Io_rgbLeds(7);
   led2_b <= Io_rgbLeds(6);

   led1_r <= Io_rgbLeds(5);
   led1_g <= Io_rgbLeds(4);
   led1_b <= Io_rgbLeds(3);

   led0_r <= Io_rgbLeds(2);
   led0_g <= Io_rgbLeds(1);
   led0_b <= Io_rgbLeds(0);

   led <= Io_leds;

end rtl;
---------------------------------------------------------------------------------------------------