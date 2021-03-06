--  This package is intended to set up and tear down  the test environment.
--  Once created by GNATtest, this package will never be overwritten
--  automatically. Contents of this package can be modified in any way
--  except for sections surrounded by a 'read only' marker.

with AUnit.Test_Fixtures;

with Ada.Exceptions;

with DOM.Core.Nodes;
with DOM.Core.Elements;
with DOM.Core.Documents;
with DOM.Core.Append_Node;

with McKae.XML.XPath.XIA;

with Muxml.Utils;

package Mucfgcheck.Test_Data is

--  begin read only
   type Test is new AUnit.Test_Fixtures.Test_Fixture
--  end read only
   with null record;

   procedure Set_Up (Gnattest_T : in out Test);
   procedure Tear_Down (Gnattest_T : in out Test);

   --  Create new memory node with given attributes.
   function Create_Mem_Node
     (Doc     : DOM.Core.Document;
      Name    : String;
      Address : String;
      Size    : String)
      return DOM.Core.Node;

   --  Returns True if the name attribute of Left and Right is equal.
   function Match_Name (Left, Right : DOM.Core.Node) return Boolean;

end Mucfgcheck.Test_Data;
