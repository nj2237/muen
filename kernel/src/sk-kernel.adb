with SK.KC;
with SK.Version;
with SK.Interrupts;
with SK.System_State;
with SK.VMX;
with SK.Scheduler;
with SK.Apic;
with SK.CPU;
with SK.MP;
with SK.Locks;

package body SK.Kernel
is

   -------------------------------------------------------------------------

   procedure Main
   is
      Success, Is_Bsp : Boolean;
   begin
      MP.Increment_CPU_Count;

      Is_Bsp := Apic.Is_BSP;
      if Is_Bsp then
         pragma Debug (KC.Init);
         pragma Debug (KC.Put_Line
           (Item => "Booting Separation Kernel ("
            & SK.Version.Version_String & ") ..."));
         null;
      else
         Apic.Enable;
         Locks.Spin_Lock;
         pragma Debug (KC.Put_Line
                       (Item => "AP online -> hlt"));
         Locks.Unlock;
         CPU.Hlt;
      end if;

      --  Setup IDT.

      Interrupts.Init;
      Interrupts.Load;

      Success := System_State.Is_Valid;
      if Success then

         pragma Debug (KC.Put_Line (Item => "Starting AP processors"));
         Apic.Enable;
         Apic.Start_AP_Processors;
         MP.Wait_For_AP_Processors;

         pragma Debug (KC.Put_Byte (Item => MP.Get_CPU_Count));
         pragma Debug (KC.Put_Line (Item => " processors online"));

         VMX.Enable;
         Scheduler.Schedule;
      else
         pragma Debug (KC.Put_Line (Item => "System initialisation error"));
         null;
      end if;

      pragma Debug (KC.Put_Line (Item => "Terminating"));
   end Main;

end SK.Kernel;
