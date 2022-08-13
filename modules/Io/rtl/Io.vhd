---------------------------------------------------------------------------------------------------
--! @brief Input/Output unit.
--!
--! @author Rene Brglez (rene.brglez@cosylab.com)
--!
--! @date December 2021
--! 
--! @version v0.1
--!
--! @file Io.vhd
--!
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library surf;
use surf.StdRtlPkg.all;

---------------------------------------------------------------------------------------------------
entity Io is
   generic (
      TPD_G           : time     := 1 ns;
      DEBOUNCE_TIME_G : positive := 5000000 --50 ms debounce time
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      --! Io sync and debounce ports
      -- Outputs to hardware (1 FF sync)
      rgbLeds_o : out slv(11 downto 0);
      rgbLeds_i : in  slv(11 downto 0);
      leds_o    : out slv(3 downto 0);
      leds_i    : in  slv(3 downto 0);

      -- Inputs from hardware (sync + debounce)
      switch_i : in  slv(3 downto 0);
      switch_o : out slv(3 downto 0);
      btns_i   : in  slv(3 downto 0);
      btns_o   : out slv(3 downto 0)
   );
end Io;
---------------------------------------------------------------------------------------------------    
architecture rtl of Io is

   -- Outputs to hardware signals
   signal fw2HwSyncI : slv(16-1 downto 0);
   signal fw2HwSyncO : slv(16-1 downto 0);

   -- Inputs from hardware signals
   signal hw2FwSyncI : slv(8-1 downto 0);
   signal hw2FwSyncO : slv(8-1 downto 0);
   signal hw2FwDebI  : slv(8-1 downto 0);
   signal hw2FwDebO  : slv(8-1 downto 0);

   constant HIGH_C : sl := '1';
   constant LOW_C  : sl := '0';

---------------------------------------------------------------------------------------------------
begin
   
   -----------------------------------------------------------------------------
   -- Outputs to hardware (2 FF sync) 
   -----------------------------------------------------------------------------

   fw2HwSyncI(15 downto 4) <= rgbLeds_i;
   fw2HwSyncI(3 downto 0)  <= leds_i;

   u0_SynchronizerVector : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => 2,
         WIDTH_G  => fw2HwSyncI'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => fw2HwSyncI,
         dataOut => fw2HwSyncO
      );

   rgbLeds_o <= fw2HwSyncO(15 downto 4);
   leds_o    <= fw2HwSyncO(3 downto 0);

   -----------------------------------------------------------------------------
   -- Inputs from hardware (3 FF sync + debounce) 
   -----------------------------------------------------------------------------

   hw2FwSyncI(7 downto 4) <= switch_i;
   hw2FwSyncI(3 downto 0) <= btns_i;

   u1_SynchronizerVector : entity surf.SynchronizerVector
      generic map (
         TPD_G    => TPD_G,
         STAGES_G => 3,
         WIDTH_G  => hw2FwSyncI'length
      )
      port map (
         clk     => clk_i,
         rst     => rst_i,
         dataIn  => hw2FwSyncI,
         dataOut => hw2FwSyncO
      );

   hw2FwDebI <= hw2FwSyncO;

   GEN_DEBOUNCE_VECT : for i in 0 to hw2FwDebI'left generate
      u_Debouncer : entity surf.Debouncer
         generic map (
            TPD_G             => TPD_G,
            INPUT_POLARITY_G  => HIGH_C,
            OUTPUT_POLARITY_G => HIGH_C,
            CLK_FREQ_G        => 100.0E+6,
            DEBOUNCE_PERIOD_G => 50.0E-3,
            SYNCHRONIZE_G     => false
         )
         port map (
            clk => clk_i,
            rst => rst_i,
            i   => hw2FwDebI(I),
            o   => hw2FwDebO(I)
         );
   end generate GEN_DEBOUNCE_VECT;

   switch_o <= hw2FwDebO(7 downto 4);
   btns_o   <= hw2FwDebO(3 downto 0);

end rtl;
---------------------------------------------------------------------------------------------------
