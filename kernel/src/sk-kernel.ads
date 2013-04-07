--# inherit
--#    X86_64,
--#    SK.Apic,
--#    SK.Interrupts,
--#    SK.GDT,
--#    SK.Scheduler,
--#    SK.System_State,
--#    SK.Subjects,
--#    SK.VMX,
--#    SK.MP,
--#    SK.CPU,
--#    SK.Locks;
package SK.Kernel
is

   --  Kernel entry point.
   procedure Main;
   --# global
   --#    in out X86_64.State;
   --#    in out Subjects.Descriptors;
   --#    in out MP.CPU_Online_Count;
   --#    in out Locks.State;
   --#    in     Interrupts.ISR_List;
   --#    in     GDT.GDT_Pointer;
   --#    in     Scheduler.State;
   --#    in     VMX.State;
   --#       out Interrupts.IDT;
   --#       out Interrupts.IDT_Pointer;
   --# derives
   --#    Interrupts.IDT, Interrupts.IDT_Pointer from Interrupts.ISR_List &
   --#    MP.CPU_Online_Count                    from *                   &
   --#    Locks.State                            from *, X86_64.State     &
   --#    Subjects.Descriptors from
   --#       *,
   --#       X86_64.State,
   --#       Scheduler.State &
   --#    X86_64.State from
   --#       *,
   --#       Interrupts.ISR_List,
   --#       GDT.GDT_Pointer,
   --#       Subjects.Descriptors,
   --#       Scheduler.State,
   --#       VMX.State;
   pragma Export (C, Main, "kmain");

end SK.Kernel;
