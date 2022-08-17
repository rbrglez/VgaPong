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

   signal Manager_redLeds   : slv(4 - 1 downto 0);
   signal Manager_greenLeds : slv(4 - 1 downto 0);
   signal Manager_blueLeds  : slv(4 - 1 downto 0);

   signal ArtyBoardIo_redLeds   : slv(4 - 1 downto 0);
   signal ArtyBoardIo_greenLeds : slv(4 - 1 downto 0);
   signal ArtyBoardIo_blueLeds  : slv(4 - 1 downto 0);

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
         clk_i => clk,
         rst_i => rst,

         btns_i   => ArtyBoardIo_btn,
         switch_i => ArtyBoardIo_sw,

         leds_o      => Manager_leds,
         redLeds_o   => Manager_redLeds,
         greenLeds_o => Manager_greenLeds,
         blueLeds_o  => Manager_blueLeds
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
         fwRedLeds_i   => Manager_redLeds,
         fwGreenLeds_i => Manager_greenLeds,
         fwBlueLeds_i  => Manager_blueLeds,
         fwJa_i        => (others => '0'),
         fwJb_i        => (others => '0'),
         fwJc_i        => (others => '0'),
         fwJd_i        => (others => '0'),

         -- HW outputs
         hwLeds_o      => led,
         hwRedLeds_o   => ArtyBoardIo_redLeds,
         hwGreenLeds_o => ArtyBoardIo_greenLeds,
         hwBlueLeds_o  => ArtyBoardIo_blueLeds,
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

   led3_r <= ArtyBoardIo_redLeds(3);
   led3_g <= ArtyBoardIo_greenLeds(3);
   led3_b <= ArtyBoardIo_blueLeds(3);

   led2_r <= ArtyBoardIo_redLeds(2);
   led2_g <= ArtyBoardIo_greenLeds(2);
   led2_b <= ArtyBoardIo_blueLeds(2);

   led1_r <= ArtyBoardIo_redLeds(1);
   led1_g <= ArtyBoardIo_greenLeds(1);
   led1_b <= ArtyBoardIo_blueLeds(1);

   led0_r <= ArtyBoardIo_redLeds(0);
   led0_g <= ArtyBoardIo_greenLeds(0);
   led0_b <= ArtyBoardIo_blueLeds(0);

end rtl;
---------------------------------------------------------------------------------------------------