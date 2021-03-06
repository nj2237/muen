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

with Ada.Containers.Doubly_Linked_Lists;

generic
   --  Parameter passed to processors.
   type Param_Type (<>) is limited private;
package Mutools.Processors
is

   type Process_Procedure is not null access procedure
     (Data : in out Param_Type);

   --  Register policy processor.
   procedure Register (Process : Process_Procedure);

   --  Run all registered policy processors.
   procedure Run (Data : in out Param_Type);

   --  Returns the number of registered processors.
   function Get_Count return Natural;

   --  Clear all registered processors.
   procedure Clear;

private

   package Processor_Package is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Process_Procedure);

   Procs : Processor_Package.List;

end Mutools.Processors;
