---------------------------------------------------------------------------------------------------
--! @brief Arty development board Input/Output unit.
--!
--! @author Rene Brglez (rene.brglez@cosylab.com)
--!
--! @date August 2022
--! 
--! @version 1.0
--!
--! @file ArtyBoardIo.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

---------------------------------------------------------------------------------------------------
entity ArtyBoardIo is
   generic (
      TPD_G             : time := 1 ns;     -- simulated propagation delay
      CLK_FREQ_G        : real := 100.0E+6; -- units of Hz
      DEBOUNCE_PERIOD_G : real := 50.0E-3   -- units of seconds
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      --------------------------------------------------------------------------
      -- Inputs from firmware
      --------------------------------------------------------------------------
      fwLeds_i : in slv(4 - 1 downto 0);

      fwRedLeds_i   : in slv(4 - 1 downto 0);
      fwGreenLeds_i : in slv(4 - 1 downto 0);
      fwBlueLeds_i  : in Slv(4 - 1 downto 0);

      fwJa_i : in slv(8 - 1 downto 0);
      fwJb_i : in slv(8 - 1 downto 0);
      fwJc_i : in slv(8 - 1 downto 0);
      fwJd_i : in slv(8 - 1 downto 0);

      --------------------------------------------------------------------------
      -- Outputs to hardware (sync)
      --------------------------------------------------------------------------
      hwLeds_o : in slv(4 - 1 downto 0);

      hwRedLeds_o   : in slv(4 - 1 downto 0);
      hwGreenLeds_o : in slv(4 - 1 downto 0);
      hwBlueLeds_o  : in Slv(4 - 1 downto 0);

      hwJa_o : in slv(8 - 1 downto 0);
      hwJb_o : in slv(8 - 1 downto 0);
      hwJc_o : in slv(8 - 1 downto 0);
      hwJd_o : in slv(8 - 1 downto 0);

      --------------------------------------------------------------------------
      -- Inputs from hardware
      --------------------------------------------------------------------------
      hwSwitch_i : in slv(4 - 1 downto 0);
      hwBtns_i   : in slv(4 - 1 downto 0);

      --------------------------------------------------------------------------
      -- Outputs to firmware (sync + debounce)
      --------------------------------------------------------------------------
      fwSwitch_o : out slv(4 - 1 downto 0);
      fwBtns_o   : out slv(4 - 1 downto 0)
   );
end ArtyBoardIo;
---------------------------------------------------------------------------------------------------    
architecture rtl of ArtyBoardIo is

   constant OUTPUTS_SYNC_STAGES_C : natural := 2;
   constant INPUTS_SYNC_STAGES_C  : natural := 3;

   signal switchSync : slv(hwSwitch_i'range);
   signal btnsSync   : slv(hwBtns_i'range);

---------------------------------------------------------------------------------------------------
begin

   -----------------------------------------------------------------------------
   -- Outputs to hardware (sync) 
   -----------------------------------------------------------------------------

   -- leds sync
   u_LedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwLeds_i,
         dataOut => hwLeds_o
      );

   -- red leds sync
   u_RedLedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwRedLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwRedLeds_i,
         dataOut => hwRedLeds_o
      );

   -- green leds sync
   u_GreenLedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwGreenLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwGreenLeds_i,
         dataOut => hwGreenLeds_o
      );

   -- blue leds sync
   u_BlueLedsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwBlueLeds_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwBlueLeds_i,
         dataOut => hwBlueLeds_o
      );

   -- pmod ja sync
   u_JaSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwJa_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwJa_i,
         dataOut => hwJa_o
      );

   -- pmod jb sync
   u_JbSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwJb_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwJb_i,
         dataOut => hwJb_o
      );

   -- pmod jc sync
   u_JcSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwJc_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwJc_i,
         dataOut => hwJc_o
      );

   -- pmod jd sync
   u_JdSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => OUTPUTS_SYNC_STAGES_C,
         WIDTH_G  => fwJd_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fwJd_i,
         dataOut => hwJd_o
      );

   -----------------------------------------------------------------------------
   -- Inputs from hardware (sync + debounce) 
   -----------------------------------------------------------------------------

   -- switch sync
   u_SwitchSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => INPUTS_SYNC_STAGES_C,
         WIDTH_G  => hwSwitch_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => hwSwitch_i,
         dataOut => switchSync
      );

   -- btns sync
   u_BtnsSync : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => INPUTS_SYNC_STAGES_C,
         WIDTH_G  => hwBtns_i'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => hwBtns_i,
         dataOut => btnsSync
      );

   -- debounce switch
   GEN_DEBOUNCE_SWITCH : for I in hwSwitch_i'range generate
      u_Debouncer : entity surf.Debouncer
         generic map (
            TPD_G             => TPD_G,
            CLK_FREQ_G        => CLK_FREQ_G,
            DEBOUNCE_PERIOD_G => DEBOUNCE_PERIOD_G,
            SYNCHRONIZE_G     => false
         )
         port map (
            clk => clk_i,
            rst => rst_i,
            i   => switchSync(I),
            o   => fwSwitch_o(I)
         );
   end generate GEN_DEBOUNCE_SWITCH;

   -- debounce btns
   GEN_DEBOUNCE_BTN : for I in hwBtns_i'range generate
      u_Debouncer : entity surf.Debouncer
         generic map (
            TPD_G             => TPD_G,
            CLK_FREQ_G        => CLK_FREQ_G,
            DEBOUNCE_PERIOD_G => DEBOUNCE_PERIOD_G,
            SYNCHRONIZE_G     => false
         )
         port map (
            clk => clk_i,
            rst => rst_i,
            i   => btnsSync(I),
            o   => fwBtns_o(I)
         );
   end generate GEN_DEBOUNCE_BTN;

end rtl;
---------------------------------------------------------------------------------------------------
