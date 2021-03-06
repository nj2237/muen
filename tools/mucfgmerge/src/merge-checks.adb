--
--  Copyright (C) 2016  Reto Buerki <reet@codelabs.ch>
--  Copyright (C) 2016  Adrian-Ken Rueegsegger <ken@codelabs.ch>
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

with Ada.Strings.Unbounded;

with DOM.Core.Elements;
with DOM.Core.Nodes;
with McKae.XML.XPath.XIA;

with Muxml.Utils;
with Mutools.System_Config;
with Mutools.Utils;

package body Merge.Checks
is

   use Ada.Strings.Unbounded;

   --  Returns the name of the expression of which the given node is a part of.
   function Expression_Name (Node : DOM.Core.Node) return String;

   generic
      type Value_Type is (<>);
      Typename : String;
   procedure Check_Type_Values (Policy : Muxml.XML_Data_Type);

   -------------------------------------------------------------------------

   procedure Check_Type_Values (Policy : Muxml.XML_Data_Type)
   is
      Values : constant DOM.Core.Node_List
        := McKae.XML.XPath.XIA.XPath_Query
          (N     => Policy.Doc,
           XPath => "/system/expressions//" & Typename);
   begin
      for I in Natural range 0 .. DOM.Core.Nodes.Length (List => Values) - 1
      loop
         declare
            use type DOM.Core.Node;

            Val_Node : constant DOM.Core.Node
              := DOM.Core.Nodes.Item
                (List  => Values,
                 Index => I);
            Val_Str  : constant String
              := DOM.Core.Elements.Get_Attribute
                (Elem => Val_Node,
                 Name => "value");
         begin
            if Val_Str'Length = 0 then
               raise Validation_Error with Mutools.Utils.Capitalize (Typename)
                 & " without value attribute in expression '" & Expression_Name
                 (Node => Val_Node) & "'";
            end if;

            declare
               Dummy : Value_Type;
            begin
               Dummy := Value_Type'Value (Val_Str);
            exception
               when Constraint_Error =>
                  raise Validation_Error with Mutools.Utils.Capitalize
                    (Typename) & " with invalid value '" & Val_Str
                    & "' in expression '"
                    & Expression_Name (Node => Val_Node) & "'";
            end;
         end;
      end loop;
   end Check_Type_Values;

   -------------------------------------------------------------------------

   procedure Conditional_Config_Var_Refs (Policy : Muxml.XML_Data_Type)
   is
      Refs : constant DOM.Core.Node_List
        := McKae.XML.XPath.XIA.XPath_Query
          (N     => Policy.Doc,
           XPath => "/system//if");
   begin
      for I in Natural range 0 .. DOM.Core.Nodes.Length (List => Refs) - 1 loop
         declare
            Ref : constant DOM.Core.Node
              := DOM.Core.Nodes.Item
                (List  => Refs,
                 Index => I);
            Ref_Name : constant String
              := DOM.Core.Elements.Get_Attribute
                (Elem => Ref,
                 Name => "variable");
         begin
            if Ref_Name'Length = 0 then
               raise Validation_Error with "Conditional without variable "
                 & "attribute";
            end if;

            if not Mutools.System_Config.Has_Value
              (Data => Policy,
               Name => Ref_Name)
            then
               raise Validation_Error with "Config variable '" & Ref_Name
                 & "' referenced by conditional not defined";
            end if;
         end;
      end loop;
   end Conditional_Config_Var_Refs;

   -------------------------------------------------------------------------

   procedure Check_Boolean_Values is new Check_Type_Values
     (Value_Type => Boolean,
      Typename   => "boolean");

   procedure Expression_Boolean_Values
     (Policy : Muxml.XML_Data_Type) renames Check_Boolean_Values;

   -------------------------------------------------------------------------

   procedure Check_Integer_Values is new Check_Type_Values
     (Value_Type => Integer,
      Typename   => "integer");

   procedure Expression_Integer_Values
     (Policy : Muxml.XML_Data_Type) renames Check_Integer_Values;

   -------------------------------------------------------------------------

   procedure Expression_Config_Var_Refs (Policy : Muxml.XML_Data_Type)
   is
      Config_Vars : constant DOM.Core.Node_List
        := McKae.XML.XPath.XIA.XPath_Query
          (N     => Policy.Doc,
           XPath => "/system/config/*");
      Refs : constant DOM.Core.Node_List
        := McKae.XML.XPath.XIA.XPath_Query
          (N     => Policy.Doc,
           XPath => "/system/expressions//variable");
   begin
      for I in Natural range 0 .. DOM.Core.Nodes.Length (List => Refs) - 1 loop
         declare
            use type DOM.Core.Node;

            Ref : constant DOM.Core.Node
              := DOM.Core.Nodes.Item
                (List  => Refs,
                 Index => I);
            Ref_Name : constant String
              := DOM.Core.Elements.Get_Attribute
                (Elem => Ref,
                 Name => "name");
         begin
            if Ref_Name'Length = 0 then
               raise Validation_Error with "Config variable without name "
                 & "attribute in expression '" & Expression_Name (Node => Ref)
                 & "'";
            end if;

            if Muxml.Utils.Get_Element
                (Nodes     => Config_Vars,
                 Ref_Attr  => "name",
                 Ref_Value => Ref_Name) = null
            then
               raise Validation_Error with "Config variable '" & Ref_Name
                 & "' referenced in expression '"
                 & Expression_Name (Node => Ref) & "' not defined";
            end if;
         end;
      end loop;
   end Expression_Config_Var_Refs;

   -------------------------------------------------------------------------

   function Expression_Name (Node : DOM.Core.Node) return String
   is
      use type DOM.Core.Node;

      Cur_Node : DOM.Core.Node;
   begin
      Cur_Node := Node;

      loop
         if DOM.Core.Nodes.Node_Name (N => Cur_Node) = "expression" then
            return DOM.Core.Elements.Get_Attribute
              (Elem => Cur_Node,
               Name => "name");
         end if;

         Cur_Node := DOM.Core.Nodes.Parent_Node (N => Cur_Node);
         exit when Cur_Node = null;
      end loop;

      raise Validation_Error with "Unable to get expression name for '"
        & DOM.Core.Nodes.Node_Name (N => Node) & "'";
   end Expression_Name;

   -------------------------------------------------------------------------

   procedure Required_Config_Values (Policy : Muxml.XML_Data_Type)
   is
      Required_Cfgs : constant array  (1 ..3) of Unbounded_String
        := (1 => To_Unbounded_String (Source => "system"),
            2 => To_Unbounded_String (Source => "hardware"),
            3 => To_Unbounded_String (Source => "platform"));
   begin
      for Cfg of Required_Cfgs loop
         if not Mutools.System_Config.Has_String
           (Data => Policy,
            Name => To_String (Source => Cfg))
         then
            raise Validation_Error with "Required string config value '"
              & To_String (Source => Cfg) & "' missing";
         end if;
      end loop;
   end Required_Config_Values;

end Merge.Checks;
