---------------------------------------------------------------------------------------------------
--! @brief  
--! @details 
--!
--! @author 
--!
--! @file BtnController.vhd
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

entity BtnController is
   Generic (
      TPD_G            : time     := 1 ns;
      BTN_WIDTH_G      : positive := 4;
      POSITIVE_LOGIC_G : boolean  := true
   );
   port (
      clk_i : in sl;
      rst_i : in sl;

      btns_i      : in  slv(BTN_WIDTH_G-1 downto 0);
      btnsState_o : out slv(BTN_WIDTH_G-1 downto 0)
   );
end BtnController;
---------------------------------------------------------------------------------------------------
architecture rtl of BtnController is

   type RegType is record
      btns      : slv(btns_i'range);
      btnsState : slv(btnsState_o'range);
   end record RegType;

   constant REG_INIT_C : RegType := (
         btns      => (others => '0'),
         btnsState => (others => '0')
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

      v.btns := btns_i;

      for i in btns_i'range loop
         if(v.btns(i)/=r.btns(i)) then
            if (v.btns(i)='1' and POSITIVE_LOGIC_G) then
               v.btnsState(i) := not(r.btnsState(i));
            elsif (v.btns(i)='0' and not(POSITIVE_LOGIC_G)) then
               v.btnsState(i) := not(r.btnsState(i));
            end if;
         end if;
      end loop;

      -- Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

      -- Outputs        
      btnsState_o <= r.btnsState;

   end process p_Comb;

   p_Seq : process(clk_i)
   begin
      if rising_edge(clk_i) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end rtl;
---------------------------------------------------------------------------------------------------