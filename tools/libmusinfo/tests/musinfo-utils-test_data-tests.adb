--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Musinfo.Utils.Test_Data.

with AUnit.Assertions; use AUnit.Assertions;

package body Musinfo.Utils.Test_Data.Tests is


--  begin read only
   procedure Test_Create_Name (Gnattest_T : in out Test);
   procedure Test_Create_Name_3d4022 (Gnattest_T : in out Test) renames Test_Create_Name;
--  id:2.2/3d402238b556bfe4/Create_Name/1/0/
   procedure Test_Create_Name (Gnattest_T : in out Test) is
   --  musinfo-utils.ads:23:4:Create_Name
--  end read only

      pragma Unreferenced (Gnattest_T);

      Ref_Str  : constant String := "foobar";
      Ref_Name : Name_Type       := Null_Name;
   begin
      Ref_Name.Length := Ref_Str'Length;
      Ref_Name.Data (1 .. Ref_Str'Length) := Name_Data_Type (Ref_Str);

      Assert (Condition => Create_Name (Str => Ref_Str) = Ref_Name,
              Message   => "Name mismatch");
--  begin read only
   end Test_Create_Name;
--  end read only


--  begin read only
   procedure Test_Create_Memregion (Gnattest_T : in out Test);
   procedure Test_Create_Memregion_cd7a3e (Gnattest_T : in out Test) renames Test_Create_Memregion;
--  id:2.2/cd7a3e2cd1f719db/Create_Memregion/1/0/
   procedure Test_Create_Memregion (Gnattest_T : in out Test) is
   --  musinfo-utils.ads:28:4:Create_Memregion
--  end read only

      pragma Unreferenced (Gnattest_T);

      use type Interfaces.Unsigned_64;

      Ref_Addr  : constant Interfaces.Unsigned_64 := 16#8000_cafe_beef_0000#;
      Ref_Size  : constant Interfaces.Unsigned_64 := 16#0020_0000#;
      Memregion : Memregion_Type;
   begin
      Memregion := Create_Memregion
        (Address    => Ref_Addr,
         Size       => Ref_Size,
         Writable   => False,
         Executable => True);

      Assert (Condition => Memregion.Address = Ref_Addr,
              Message   => "Address mismatch");
      Assert (Condition => Memregion.Size = Ref_Size,
              Message   => "Size mismatch");
      Assert (Condition => not Memregion.Flags.Writable,
              Message   => "Writable");
      Assert (Condition => Memregion.Flags.Executable,
              Message   => "not executable");
--  begin read only
   end Test_Create_Memregion;
--  end read only


--  begin read only
   procedure Test_Create_Channel_Info (Gnattest_T : in out Test);
   procedure Test_Create_Channel_Info_825d0f (Gnattest_T : in out Test) renames Test_Create_Channel_Info;
--  id:2.2/825d0f1f0fd8a802/Create_Channel_Info/1/0/
   procedure Test_Create_Channel_Info (Gnattest_T : in out Test) is
   --  musinfo-utils.ads:36:4:Create_Channel_Info
--  end read only

      pragma Unreferenced (Gnattest_T);

      use type Interfaces.Unsigned_64;

      Ref_Event    : constant Event_Number_Range := 234;
      Ref_Vector   : constant Vector_Range       := 123;
      Channel_Info : Channel_Info_Type;
   begin
      Channel_Info := Create_Channel_Info
        (Has_Event  => True,
         Has_Vector => False,
         Event      => Ref_Event,
         Vector     => Ref_Vector);

      Assert (Condition => Channel_Info.Flags.Has_Event,
              Message   => "Has no event");
      Assert (Condition => not Channel_Info.Flags.Has_Vector,
              Message   => "Has vector");
      Assert (Condition => Channel_Info.Event = Ref_Event,
              Message   => "Event mismatch");
      Assert (Condition => Channel_Info.Vector = Ref_Vector,
              Message   => "Vector mismatch");
--  begin read only
   end Test_Create_Channel_Info;
--  end read only


--  begin read only
   procedure Test_Create_Resource (Gnattest_T : in out Test);
   procedure Test_Create_Resource_ed1649 (Gnattest_T : in out Test) renames Test_Create_Resource;
--  id:2.2/ed1649f963c2d696/Create_Resource/1/0/
   procedure Test_Create_Resource (Gnattest_T : in out Test) is
   --  musinfo-utils.ads:44:4:Create_Resource
--  end read only

      pragma Unreferenced (Gnattest_T);

      Ref_Name     : constant Name_Type := Create_Name (Str => "bar");
      Ref_Mem_Idx  : constant Resource_Index_Type := 5;
      Ref_Chan_Idx : constant Resource_Index_Type := 128;
      Resource     : Resource_Type;
   begin
      Resource := Create_Resource
        (Name               => Ref_Name,
         Memregion_Index    => Ref_Mem_Idx,
         Channel_Info_Index => Ref_Chan_Idx);

      Assert (Condition => Resource.Name = Ref_Name,
              Message   => "Name mismatch");
      Assert (Condition => Resource.Memregion_Idx = Ref_Mem_Idx,
              Message   => "Memregion index mismatch");
      Assert (Condition => Resource.Channel_Info_Idx = Ref_Chan_Idx,
              Message   => "Channel info index mismatch");
--  begin read only
   end Test_Create_Resource;
--  end read only


--  begin read only
   procedure Test_Append_Channel (Gnattest_T : in out Test);
   procedure Test_Append_Channel_986bdd (Gnattest_T : in out Test) renames Test_Append_Channel;
--  id:2.2/986bdd786a412b76/Append_Channel/0/0/
   procedure Test_Append_Channel (Gnattest_T : in out Test) is
   --  musinfo-utils.ads:51:4:Append_Channel
--  end read only

      pragma Unreferenced (Gnattest_T);

      use type Interfaces.Unsigned_64;

      Ref_Name   : constant Name_Type := Create_Name (Str => "foo");
      Ref_Addr   : constant Interfaces.Unsigned_64 := 16#8000_cafe_beef_0000#;
      Ref_Size   : constant Interfaces.Unsigned_64 := 16#2000#;
      Ref_Event  : constant Event_Number_Range     := 234;
      Ref_Vector : constant Vector_Range           := 123;

      Info : Subject_Info_Type := Null_Subject_Info;
   begin
      Assert (Condition => Info.Channel_Info_Count = Resource_Count_Type'First,
              Message   => "Channel present");

      Append_Channel (Info    => Info,
                      Name       => Ref_Name,
                      Address    => Ref_Addr,
                      Size       => Ref_Size,
                      Writable   => True,
                      Has_Event  => False,
                      Has_Vector => True,
                      Event      => Ref_Event,
                      Vector     => Ref_Vector);

      Assert (Condition => Info.Channel_Info_Count = 1,
              Message   => "Channel not appended");

      declare
         Channel_Info : constant Channel_Info_Type := Info.Channels_Info (1);
      begin
         Assert (Condition => not Channel_Info.Flags.Has_Event,
                 Message   => "Has event");
         Assert (Condition => Channel_Info.Flags.Has_Vector,
                 Message   => "Has no vector");
         Assert (Condition => Channel_Info.Event = Ref_Event,
                 Message   => "Event mismatch");
         Assert (Condition => Channel_Info.Vector = Ref_Vector,
                 Message   => "Vector mismatch");
      end;

      Append_Channel (Info    => Info,
                      Name       => Ref_Name,
                      Address    => Ref_Addr,
                      Size       => Ref_Size,
                      Writable   => True,
                      Has_Event  => False,
                      Has_Vector => True,
                      Event      => Ref_Event,
                      Vector     => Ref_Vector);
      Assert (Condition => Info.Channel_Info_Count = 2,
              Message   => "Channel not appended (2)");
--  begin read only
   end Test_Append_Channel;
--  end read only

end Musinfo.Utils.Test_Data.Tests;
