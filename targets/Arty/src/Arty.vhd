---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file Arty.vhd
--!
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

   signal Manager_leds : slv(led'range);

   signal ArtyBoardIo_btn : slv(btn'range);
   signal ArtyBoardIo_sw  : slv(sw'range);

   signal Manager_rgbLeds : slv(12 - 1 downto 0);

   signal redLeds   : slv(4 - 1 downto 0);
   signal greenLeds : slv(4 - 1 downto 0);
   signal blueLeds  : slv(4 - 1 downto 0);

   signal clk  : sl;
   signal rst  : sl;
   signal rstn : sl;

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
         btns_i    => ArtyBoardIo_btn,
         switch_i  => ArtyBoardIo_sw
      );


   u_ArtyBoardIo : entity work.ArtyBoardIo
      generic map (
         TPD_G             => TPD_G,
         CLK_FREQ_G        => 100.0E+6,
         DEBOUNCE_PERIOD_G => 50.0E-3
      )
      port map (
         clk_i => clk,
         rst_i => rst,

         -- FW inputs
         fwLeds_i      => Manager_leds,
         fwRedLeds_i   => Manager_rgbLeds(4 - 1 downto 0),
         fwGreenLeds_i => Manager_rgbLeds(8 - 1 downto 4),
         fwBlueLeds_i  => Manager_rgbLeds(12 - 1 downto 8),
         fwJa_i        => (others => '0'),
         fwJb_i        => (others => '0'),
         fwJc_i        => (others => '0'),
         fwJd_i        => (others => '0'),

         -- HW outputs
         hwLeds_o      => led,
         hwRedLeds_o   => redLeds,
         hwGreenLeds_o => greenLeds,
         hwBlueLeds_o  => blueLeds,
         hwJa_o        => open,
         hwJb_o        => open,
         hwJc_o        => open,
         hwJd_o        => open,

         -- HW inputs
         hwSwitch_i => sw,
         hwBtns_i   => btn,

         -- FW outputs
         fwSwitch_o => ArtyBoardIo_sw,
         fwBtns_o   => ArtyBoardIo_btn
      );

   led3_r <= redLeds(3);
   led3_g <= greenLeds(3);
   led3_b <= blueLeds(3);

   led2_r <= redLeds(2);
   led2_g <= greenLeds(2);
   led2_b <= blueLeds(2);

   led1_r <= redLeds(1);
   led1_g <= greenLeds(1);
   led1_b <= blueLeds(1);

   led0_r <= redLeds(0);
   led0_g <= greenLeds(0);
   led0_b <= blueLeds(0);

end rtl;
---------------------------------------------------------------------------------------------------