--
--  Copyright (C) 2013  Reto Buerki <reet@codelabs.ch>
--  Copyright (C) 2013  Adrian-Ken Rueegsegger <ken@codelabs.ch>
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

with SK.CPU_Global;
with SK.Events;
with SK.Interrupts;
with SK.MP;
with SK.Subjects;
with SK.VTd;
with Skp.Scheduling;
with Skp.Subjects;
with X86_64;

use type Skp.CPU_Range;
use type Skp.Dst_Vector_Range;
use type Skp.Scheduling.Minor_Frame_Range;
use type Skp.Subjects.Trap_Entry_Type;
use type Skp.Subjects.Event_Entry_Type;
use type Skp.Subjects.Profile_Kind;

package SK.Scheduler
with
   Abstract_State =>
     (State,
      (Tau0_Kernel_Interface with External => Async_Writers)),
   Initializes    => (State, Tau0_Kernel_Interface)
is

   --  Init scheduler.
   procedure Init
   with
      Global  =>
        (Input  => (Interrupts.State, State),
         In_Out => (CPU_Global.State, Subjects.State, X86_64.State)),
      Depends =>
        (CPU_Global.State =>+ State,
         Subjects.State   =>+ null,
         X86_64.State     =>+ (CPU_Global.State, Interrupts.State, State));

   --  Handle_Vmx_Exit could be private if spark/init.adb did not need access.

   --  VMX exit handler.
   procedure Handle_Vmx_Exit
     (Subject_Registers : in out SK.CPU_Registers_Type)
   with
      Global     =>
        (Input  => Tau0_Kernel_Interface,
         In_Out => (CPU_Global.State, Events.State, MP.Barrier, State,
                    Subjects.State, VTd.State, X86_64.State)),
      Depends    =>
       (CPU_Global.State    =>+ (State, Subject_Registers,
                                 Tau0_Kernel_Interface, X86_64.State),
        (Events.State,
         Subject_Registers) =>+ (CPU_Global.State, State, Subjects.State,
                                 Subject_Registers, Tau0_Kernel_Interface,
                                 X86_64.State),
        MP.Barrier          =>+ (CPU_Global.State, State, X86_64.State),
        State               =>+ (CPU_Global.State, Tau0_Kernel_Interface,
                                 X86_64.State),
       (Subjects.State,
        VTd.State)          =>+ (CPU_Global.State, State, Subjects.State,
                                 Subject_Registers, X86_64.State),
        X86_64.State        =>+ (CPU_Global.State, Events.State, State,
                                 Subjects.State, Subject_Registers,
                                 Tau0_Kernel_Interface)),
      Export,
      Convention => C,
      Link_Name  => "handle_vmx_exit";

end SK.Scheduler;
