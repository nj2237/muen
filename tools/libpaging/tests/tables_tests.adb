--
--  Copyright (C) 2014  Reto Buerki <reet@codelabs.ch>
--  Copyright (C) 2014  Adrian-Ken Rueegsegger <ken@codelabs.ch>
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

with Ada.Exceptions;

with Interfaces;

with Paging.Entries;
with Paging.Tables;

package body Tables_Tests
is

   use Ahven;
   use Paging;
   use Paging.Tables;

   -------------------------------------------------------------------------

   procedure Add_Duplicate_Table_Entry
   is
      E : constant Entries.PT_Entry_Type := Entries.Create
        (Dst_Offset  => 0,
         Dst_Address => 0,
         Readable    => True,
         Writable    => False,
         Executable  => True,
         Maps_Page   => True,
         Global      => True,
         Caching     => Paging.WB);

      Table : PT.Page_Table_Type := PT.Null_Table;
   begin
      PT.Add_Entry (Table => Table,
                    Index => 0,
                    E     => E);
      PT.Add_Entry (Table => Table,
                    Index => 0,
                    E     => E);
      Fail (Message => "Exception expected");

   exception
      when E : PT.Duplicate_Entry =>
         Assert (Condition => Ada.Exceptions.Exception_Message (X => E)
                 = "Table entry with index 0 already exists",
                 Message   => "Exception mismatch");
   end Add_Duplicate_Table_Entry;

   -------------------------------------------------------------------------

   procedure Add_Table_Entry
   is
      Table : PT.Page_Table_Type := PT.Null_Table;
   begin
      Assert (Condition => PT.Count (Table => Table) = 0,
              Message   => "Table not empty");

      PT.Add_Entry (Table => Table,
                    Index => 42,
                    E     => Entries.Create
                      (Dst_Offset  => 0,
                       Dst_Address => 0,
                       Readable    => True,
                       Writable    => False,
                       Executable  => True,
                       Maps_Page   => True,
                       Global      => True,
                       Caching     => Paging.WB));

      Assert (Condition => PT.Count (Table => Table) = 1,
              Message   => "Entry not added");
      Assert (Condition => PT.Contains (Table => Table,
                                        Index => 42),
              Message   => "Entry not added with correct index");
   end Add_Table_Entry;

   -------------------------------------------------------------------------

   procedure Initialize (T : in out Testcase)
   is
   begin
      T.Set_Name (Name => "Pagetable tests");
      T.Add_Test_Routine
        (Routine => Add_Table_Entry'Access,
         Name    => "Add entry to table");
      T.Add_Test_Routine
        (Routine => Add_Duplicate_Table_Entry'Access,
         Name    => "Add duplicate entry to table");
      T.Add_Test_Routine
        (Routine => Iteration'Access,
         Name    => "Table iteration");
      T.Add_Test_Routine
        (Routine => Nonexistent_Table_Address'Access,
         Name    => "Get table address (nonexistent)");
   end Initialize;

   -------------------------------------------------------------------------

   procedure Iteration
   is
      Ref_Entry : constant Entries.PT_Entry_Type := Entries.Create
        (Dst_Offset  => 12,
         Dst_Address => 16#deadbeef0000#,
         Readable    => True,
         Writable    => True,
         Executable  => False,
         Maps_Page   => True,
         Global      => False,
         Caching     => Paging.UC);

      Table   : PT.Page_Table_Type;
      Counter : Natural := 0;

      --  Increment counter.
      procedure Inc_Counter
        (Index  : Table_Range;
         TEntry : Entries.PT_Entry_Type);

      ----------------------------------------------------------------------

      procedure Inc_Counter
        (Index  : Table_Range;
         TEntry : Entries.PT_Entry_Type)
      is
         use type Entries.PT_Entry_Type;
      begin
         Assert (Condition => Index = 12 or Index = 13,
                 Message   => "Invalid index");
         Assert (Condition => TEntry = Ref_Entry,
                 Message   => "Table entry mismatch");
         Counter := Counter + 1;
      end Inc_Counter;
   begin
      PT.Add_Entry (Table => Table,
                    Index => 12,
                    E     => Ref_Entry);
      PT.Add_Entry (Table => Table,
                    Index => 13,
                    E     => Ref_Entry);

      PT.Iterate (Table   => Table,
                  Process => Inc_Counter'Access);

      Assert (Condition => Counter = 2,
              Message   => "Iteration counter mismatch");
   end Iteration;

   -------------------------------------------------------------------------

   procedure Nonexistent_Table_Address
   is
      Map : Tables.PT.Page_Table_Map;
      Tmp : Interfaces.Unsigned_64;
      pragma Unreferenced (Tmp);
   begin
      Tmp := Tables.PT.Get_Table_Address
        (Map          => Map,
         Table_Number => 0);
      Fail (Message => "Exception expected");

   exception
      when E : Tables.PT.Missing_Table =>
         Assert (Condition => Ada.Exceptions.Exception_Message (X => E)
                 = "Table with number 0 not in map",
                 Message   => "Exception mismatch");
   end Nonexistent_Table_Address;

end Tables_Tests;
