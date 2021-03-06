--  This package is intended to set up and tear down  the test environment.
--  Once created by GNATtest, this package will never be overwritten
--  automatically. Contents of this package can be modified in any way
--  except for sections surrounded by a 'read only' marker.

with AUnit.Test_Fixtures;

with Ada.Exceptions;
with Ada.Strings.Unbounded;

with DOM.Core.Documents;

with Muxml.Utils;
with Mutools.XML_Utils;
with Mucfgcheck.Files;

package Pack.Pre_Checks.Test_Data is

--  begin read only
   type Test is new AUnit.Test_Fixtures.Test_Fixture
--  end read only
   with null record;

   procedure Set_Up (Gnattest_T : in out Test);
   procedure Tear_Down (Gnattest_T : in out Test);

   Test_Counter : Natural := 0;

   procedure Inc_Counter (Data : Muxml.XML_Data_Type);

end Pack.Pre_Checks.Test_Data;
