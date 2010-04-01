------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                     Copyright (C) 2003-2009, AdaCore                     --
--                                                                          --
--  This library is free software; you can redistribute it and/or modify    --
--  it under the terms of the GNU General Public License as published by    --
--  the Free Software Foundation; either version 2 of the License, or (at   --
--  your option) any later version.                                         --
--                                                                          --
--  This library is distributed in the hope that it will be useful, but     --
--  WITHOUT ANY WARRANTY; without even the implied warranty of              --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       --
--  General Public License for more details.                                --
--                                                                          --
--  You should have received a copy of the GNU General Public License       --
--  along with this library; if not, write to the Free Software Foundation, --
--  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.          --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

with GNAT.Calendar.Time_IO;

with AWS.Config;
with AWS.Hotplug.Get_Status;
with AWS.Session;
with AWS.Utils;

package body AWS.Server.Status is

   use Ada;

   -------------------------
   -- Current_Connections --
   -------------------------

   function Current_Connections (Server : HTTP) return Natural is
   begin
      return Server.Slots.N - Server.Slots.Free_Slots;
   end Current_Connections;

   ---------------------------
   -- Is_Security_Activated --
   ---------------------------

   function Is_Security_Activated (Server : HTTP) return Boolean is
   begin
      return AWS.Config.Security (Server.Properties);
   end Is_Security_Activated;

   --------------------------
   -- Is_Session_Activated --
   --------------------------

   function Is_Session_Activated (Server : HTTP) return Boolean is
   begin
      return AWS.Config.Session (Server.Properties);
   end Is_Session_Activated;

   -----------------
   -- Is_Shutdown --
   -----------------

   function Is_Shutdown (Server : HTTP) return Boolean is
   begin
      return Server.Shutdown;
   end Is_Shutdown;

   ----------
   -- Port --
   ----------

   function Port (Server : HTTP) return Positive is
   begin
      return Net.Get_Port (Net.Acceptors.Server_Socket (Server.Acceptor));
   end Port;

   ----------------------
   -- Resources_Served --
   ----------------------

   function Resources_Served (Server : HTTP) return Natural is
      N : Natural := 0;
   begin
      for K in 1 .. Server.Slots.N loop
         N := N + Server.Slots.Get (K).Slot_Activity_Counter;
      end loop;
      return N;
   end Resources_Served;

   ------------
   -- Socket --
   ------------

   function Socket (Server : HTTP) return Net.Socket_Type'Class is
   begin
      return Net.Acceptors.Server_Socket (Server.Acceptor);
   end Socket;

   ----------------
   -- Start_Time --
   ----------------

   function Start_Time (Server : HTTP) return Ada.Calendar.Time is
   begin
      return Server.Start_Time;
   end Start_Time;

   ------------------
   -- Translations --
   ------------------

   function Translations (Server : HTTP) return Templates.Translate_Set is

      use AWS.Templates;

      function Slot_Table return Translate_Set;
      --  returns the information for each slot

      function Session_Table return Translate_Set;
      --  returns session information

      -------------------
      -- Session_Table --
      -------------------

      function Session_Table return Translate_Set is

         Sessions           : Vector_Tag;
         Sessions_TS        : Vector_Tag;
         Sessions_Terminate : Vector_Tag;
         Keys               : Vector_Tag;
         Values             : Vector_Tag;
         M_Keys             : Matrix_Tag;
         M_Values           : Matrix_Tag;

         procedure For_Each_Key_Value
           (N          : Positive;
            Key, Value : String;
            Quit       : in out Boolean);
         --  add key/value pair to the list

         procedure For_Each_Session
           (N          : Positive;
            SID        : Session.Id;
            Time_Stamp : Calendar.Time;
            Quit       : in out Boolean);
         --  add session SID to the list

         ------------------------
         -- For_Each_Key_Value --
         ------------------------

         procedure For_Each_Key_Value
           (N          : Positive;
            Key, Value : String;
            Quit       : in out Boolean)
         is
            pragma Unreferenced (N, Quit);
         begin
            Keys   := Keys & Key;
            Values := Values & Value;
         end For_Each_Key_Value;

         --------------------------
         -- Build_Key_Value_List --
         --------------------------

         procedure Build_Key_Value_List is
            new Session.For_Every_Session_Data (For_Each_Key_Value);

         ----------------------
         -- For_Each_Session --
         ----------------------

         procedure For_Each_Session
           (N          : Positive;
            SID        : Session.Id;
            Time_Stamp : Calendar.Time;
            Quit       : in out Boolean)
         is
            pragma Unreferenced (N, Quit);
            use type Calendar.Time;
         begin
            Sessions    := Sessions & Session.Image (SID);

            Sessions_TS := Sessions_TS
              & GNAT.Calendar.Time_IO.Image (Time_Stamp, "%a %D %T");

            Sessions_Terminate := Sessions_Terminate
              & GNAT.Calendar.Time_IO.Image
              (Time_Stamp + Session.Get_Lifetime, "%a %D %T");

            Build_Key_Value_List (SID);

            M_Keys   := M_Keys & Keys;
            M_Values := M_Values & Values;

            Clear (Keys);
            Clear (Values);
         end For_Each_Session;

         ------------------------
         -- Build_Session_List --
         ------------------------

         procedure Build_Session_List is
            new Session.For_Every_Session (For_Each_Session);

         Result : Translate_Set;

      begin
         Build_Session_List;

         Insert (Result, Assoc ("SESSIONS_V",           Sessions));
         Insert (Result, Assoc ("SESSIONS_TS_V",        Sessions_TS));
         Insert (Result, Assoc ("SESSIONS_TERMINATE_V", Sessions_Terminate));
         Insert (Result, Assoc ("KEYS_M",               M_Keys));
         Insert (Result, Assoc ("VALUES_M",             M_Values));

         return Result;
      end Session_Table;

      ----------------
      -- Slot_Table --
      ----------------

      function Slot_Table return Translate_Set is

         Sock                  : Vector_Tag;
         Phase                 : Vector_Tag;
         Abortable             : Vector_Tag;
         Activity_Counter      : Vector_Tag;
         Slot_Activity_Counter : Vector_Tag;
         Activity_Time_Stamp   : Vector_Tag;
         Peer_Name             : Vector_Tag;

         --  Avoids : may be referenced before it has a value
         pragma Warnings (Off, Sock);
         pragma Warnings (Off, Phase);
         pragma Warnings (Off, Abortable);
         pragma Warnings (Off, Activity_Counter);
         pragma Warnings (Off, Slot_Activity_Counter);
         pragma Warnings (Off, Activity_Time_Stamp);
         pragma Warnings (Off, Peer_Name);

         Slot_Data             : Slot;
         Result                : Translate_Set;

         Now_Monolit  : constant Real_Time.Time := Real_Time.Clock;
         Now_Calendar : constant Calendar.Time  := Calendar.Clock;

         use type Real_Time.Time;
         use type Calendar.Time;

      begin
         for K in 1 .. CNF.Max_Connection (Server.Properties) loop
            Slot_Data := Server.Slots.Get (Index => K);

            declare
               SD : constant Socket_Data
                 := Server.Slots.Get_Socket_Info (Index => K);
            begin
               Sock      := Sock      & SD.FD;
               Peer_Name := Peer_Name & SD.Peername;
            end;

            Phase     := Phase & Slot_Phase'Image (Slot_Data.Phase);

            Abortable := Abortable
              & Server.Slots.Is_Abortable (Index => K);

            Activity_Counter := Activity_Counter & Slot_Data.Activity_Counter;

            Slot_Activity_Counter := Slot_Activity_Counter
              & Slot_Data.Slot_Activity_Counter;

            Activity_Time_Stamp := Activity_Time_Stamp &
              GNAT.Calendar.Time_IO.Image
                (Now_Calendar - Real_Time.To_Duration
                                  (Now_Monolit - Slot_Data.Phase_Time_Stamp),
                 "%a %D %T");
         end loop;

         Insert (Result, Assoc ("SOCK_V",             Sock));
         Insert (Result, Assoc ("PEER_NAME_V",        Peer_Name));
         Insert (Result, Assoc ("PHASE_V",            Phase));
         Insert (Result, Assoc ("ABORTABLE_V",        Abortable));
         Insert (Result, Assoc ("ACTIVITY_COUNTER_V", Activity_Counter));
         Insert
           (Result, Assoc ("ACTIVITY_TIME_STAMP_V",   Activity_Time_Stamp));
         Insert
           (Result, Assoc ("SLOT_ACTIVITY_COUNTER_V", Slot_Activity_Counter));

         return Result;
      end Slot_Table;

      Admin_URI : constant String := CNF.Admin_URI (Server.Properties);
      Result    : Translate_Set;

   begin
      Insert (Result,
              Assoc ("SERVER_NAME", CNF.Server_Name (Server.Properties)));

      Insert (Result, Assoc ("START_TIME",
                     GNAT.Calendar.Time_IO.Image
                       (Server.Start_Time, "%A %-d %B %Y, %T")));

      Insert (Result, Assoc ("MAX_CONNECTION",
                     CNF.Max_Connection (Server.Properties)));

      Insert (Result, Assoc ("SERVER_PORT",
                     CNF.Server_Port (Server.Properties)));

      Insert (Result, Assoc ("SECURITY",
                     CNF.Security (Server.Properties)));

      Insert (Result, Assoc ("SERVER_SOCK",
                     Integer (Net.Get_FD (Socket (Server)))));

      Insert (Result, Assoc ("ACCEPTOR_LENGTH",
                     Net.Acceptors.Length (Server.Acceptor)));

      Insert (Result, Assoc ("CURRENT_CONNECTIONS",
                     Current_Connections (Server)));

      Insert (Result, Assoc ("VERSION", Version));

      Insert (Result, Assoc ("SESSION", CNF.Session (Server.Properties)));

      Insert
        (Result,
         Assoc ("SESSION_LIFETIME", Utils.Image (Session.Get_Lifetime)));

      Insert (Result, Assoc ("SESSION_CLEANUP_INTERVAL",
                     Utils.Image (CNF.Session_Cleanup_Interval)));

      Insert (Result, Assoc ("CLEANER_WAIT_FOR_CLIENT_TIMEOUT",
                     Utils.Image
                       (CNF.Cleaner_Wait_For_Client_Timeout
                          (Server.Properties))));

      Insert (Result, Assoc ("CLEANER_CLIENT_HEADER_TIMEOUT",
                     Utils.Image
                       (CNF.Cleaner_Client_Header_Timeout
                          (Server.Properties))));

      Insert (Result, Assoc ("CLEANER_CLIENT_DATA_TIMEOUT",
                     Utils.Image
                       (CNF.Cleaner_Client_Data_Timeout (Server.Properties))));

      Insert (Result, Assoc ("CLEANER_SERVER_RESPONSE_TIMEOUT",
                     Utils.Image
                       (CNF.Cleaner_Server_Response_Timeout
                          (Server.Properties))));

      Insert (Result, Assoc ("FORCE_WAIT_FOR_CLIENT_TIMEOUT",
                     Utils.Image
                       (CNF.Force_Wait_For_Client_Timeout
                          (Server.Properties))));

      Insert (Result, Assoc ("FORCE_CLIENT_HEADER_TIMEOUT",
                     Utils.Image
                       (CNF.Force_Client_Header_Timeout (Server.Properties))));

      Insert (Result, Assoc ("FORCE_CLIENT_DATA_TIMEOUT",
                     Utils.Image
                       (CNF.Force_Client_Data_Timeout (Server.Properties))));

      Insert (Result, Assoc ("FORCE_SERVER_RESPONSE_TIMEOUT",
                     Utils.Image
                       (CNF.Force_Server_Response_Timeout
                          (Server.Properties))));

      Insert (Result, Assoc ("SEND_TIMEOUT",
                     Utils.Image (CNF.Send_Timeout (Server.Properties))));

      Insert (Result, Assoc ("RECEIVE_TIMEOUT",
                     Utils.Image (CNF.Receive_Timeout (Server.Properties))));

      Insert (Result, Assoc ("ACCEPT_QUEUE_SIZE",
                     Utils.Image (CNF.Accept_Queue_Size (Server.Properties))));

      Insert
        (Result, Assoc ("STATUS_PAGE", CNF.Status_Page (Server.Properties)));

      Insert (Result, Assoc ("LOGO", Admin_URI & "-logo"));

      Insert (Result, Assoc ("LOG", Log.Is_Active (Server.Log)));

      Insert (Result, Assoc ("LOG_FILE", Log.Filename (Server.Log)));

      Insert
        (Result,
         Assoc ("LOG_MODE", Log.Split_Mode'Image (Log.Mode (Server.Log))));

      Insert (Result, Assoc ("ADMIN", Admin_URI));

      Insert
        (Result,
         Assoc ("UPLOAD_DIRECTORY", CNF.Upload_Directory (Server.Properties)));

      Insert (Result, Slot_Table);
      Insert (Result, Session_Table);
      Insert (Result, Hotplug.Get_Status (Server.Filters));

      return Result;
   end Translations;

   function Translations (Server : HTTP) return Templates.Translate_Table is
      use Templates;

      Set    : constant Translate_Set := Translations (Server);
      Result : Translate_Table (1 .. Size (Set));
      Index  : Positive := Result'First;

      procedure Action (Item : Association; Quit : in out Boolean);

      ------------
      -- Action --
      ------------

      procedure Action (Item : Association; Quit : in out Boolean) is
         pragma Unreferenced (Quit);
      begin
         Result (Index) := Item;
         Index := Index + 1;
      end Action;

      procedure For_Each is new For_Every_Association (Action);

   begin
      For_Each (Set);
      return Result;
   end Translations;

end AWS.Server.Status;