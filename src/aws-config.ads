------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                            Copyright (C) 2000                            --
--                      Dmitriy Anisimkov & Pascal Obry                     --
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

--  $Id$

--  This package provide an easy way to handle a configuration file for
--  AWS. Each line in the aws.ini has the following format:
--
--     <option name> <option value>
--
--  This package will initialize itself by parsing aws.ini, each option are
--  descripted below.
--
--  It is then possible to use AWS.Config to initialize the HTTP settings.
--
--  If file aws.ini is not found all functions below will return the default
--  value as declared at the start of the package.

package AWS.Config is


   Default_Server_Name        : constant String := "[no name]";
   Default_Admin_URI          : constant String := "";
   Default_Server_Port        : constant        := 8080;
   Default_Max_Connection     : constant        := 5;
   Default_Log_File_Directory : constant String := "./";
   Default_Upload_Directory   : constant String := "./";

   Eight_Hours : constant := 28_800.0;
   Three_Hours : constant := 10_800.0;

   Default_Cleaner_Wait_For_Client_Timeout : constant Duration := 80.0;
   Default_Cleaner_Client_Header_Timeout   : constant Duration := 20.0;
   Default_Cleaner_Client_Data_Timeout     : constant Duration := Eight_Hours;
   Default_Cleaner_Server_Response_Timeout : constant Duration := Eight_Hours;

   Default_Force_Wait_For_Client_Timeout   : constant Duration :=  2.0;
   Default_Force_Client_Header_Timeout     : constant Duration :=  3.0;
   Default_Force_Client_Data_Timeout       : constant Duration :=  Three_Hours;
   Default_Force_Server_Response_Timeout   : constant Duration :=  Three_Hours;

   Default_Send_Timeout      : constant Duration :=  40.0;
   Default_Receive_Timeout   : constant Duration :=  30.0;

   Default_Status_Page       : constant String := "aws_status.thtml";
   Default_Up_Image          : constant String := "aws_up.png";
   Default_Down_Image        : constant String := "aws_down.png";
   Default_Logo_Image        : constant String := "aws_logo.png";

   function Server_Name return String;
   --  Format: Server_Name <string>
   --  This is the name of the server as set by AWS.Server.Start.

   function Admin_URI return String;
   --  Format: Admin_URI <string>
   --  This is the name of the admin server page as set by AWS.Server.Start.

   function Server_Port return Positive;
   --  Format: Server_Port <positive>
   --  This is the server port as set by the HTTP object declaration.

   function Max_Connection return Positive;
   --  Format: Max_Connection <positive>
   --  This is the max simultaneous connections as set by the HTTP object
   --  declaration.

   function Log_File_Directory return String;
   --  Format: Log_File_Directory <string>
   --  This point to the directory where log files will be written. The
   --  directory returned will end with a directory separator.

   function Upload_Directory return String;
   --  Format: Upload_Directory <string>
   --  This point to the directory where uploaded files will be stored. The
   --  directory returned will end with a directory separator.

   function Cleaner_Wait_For_Client_Timeout return Duration;
   --  Format: Cleaner_Wait_For_Client <duration>
   --  Number of seconds to timout on waiting for a client request.
   --  This is a timeout for regular cleaning task.

   function Cleaner_Client_Header_Timeout   return Duration;
   --  Format: Cleaner_Client_Header <duration>
   --  Number of seconds to timout on waiting for client header.
   --  This is a timeout for regular cleaning task.

   function Cleaner_Client_Data_Timeout     return Duration;
   --  Format: Cleaner_Client_Data  <duration>
   --  Number of seconds to timout on waiting for client message body.
   --  This is a timeout for regular cleaning task.

   function Cleaner_Server_Response_Timeout return Duration;
   --  Format: Cleaner_Server_Response <duration>
   --  Number of seconds to timout on waiting for client to accept answer.
   --  This is a timeout for regular cleaning task.

   function Force_Wait_For_Client_Timeout   return Duration;
   --  Format: Force_Wait_For_Client <duration>
   --  Number of seconds to timout on waiting for a client request.
   --  This is a timeout for urgent request when ressources are missing.

   function Force_Client_Header_Timeout     return Duration;
   --  Format: Force_Client_Header <duration>
   --  Number of seconds to timout on waiting for client header.
   --  This is a timeout for urgent request when ressources are missing.

   function Force_Client_Data_Timeout       return Duration;
   --  Format: Force_Client_Data <duration>
   --  Number of seconds to timout on waiting for client message body.
   --  This is a timeout for urgent request when ressources are missing.

   function Force_Server_Response_Timeout   return Duration;
   --  Format: Force_Server_Response <duration>
   --  Number of seconds to timout on waiting for client to accept answer.
   --  This is a timeout for urgent request when ressources are missing.

   function Send_Timeout return Duration;
   --  Format: Send_Timeout <duration>
   --  Number of seconds to timeout when sending chunck of data.

   function Receive_Timeout   return Duration;
   --  Format: Receive_Timeout <duration>
   --  Number of seconds to timeout when receiving chunck of data.

   function Status_Page return String;
   --  Format: Status_Page <string>
   --  Filename for the status page.

   function Up_Image    return String;
   --  Format: Status_Page <string>
   --  Filename for the up arrow image used in the status page.

   function Down_Image  return String;
   --  Format: Status_Page <string>
   --  Filename for the down arrow image used in the status page.

   function Logo_Image  return String;
   --  Format: Status_Page <string>
   --  Filename for the AWS logo image used in the status page.

end AWS.Config;
