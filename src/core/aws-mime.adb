------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                     Copyright (C) 2000-2024, AdaCore                     --
--                                                                          --
--  This library is free software;  you can redistribute it and/or modify   --
--  it under terms of the  GNU General Public License  as published by the  --
--  Free Software  Foundation;  either version 3,  or (at your  option) any --
--  later version. This library is distributed in the hope that it will be  --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    --
--                                                                          --
--  As a special exception under Section 7 of GPL version 3, you are        --
--  granted additional permissions described in the GCC Runtime Library     --
--  Exception, version 3.1, as published by the Free Software Foundation.   --
--                                                                          --
--  You should have received a copy of the GNU General Public License and   --
--  a copy of the GCC Runtime Library Exception along with this program;    --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see   --
--  <http://www.gnu.org/licenses/>.                                         --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

with Ada.Characters.Handling;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Strings.Hash_Case_Insensitive;
with Ada.Strings.Maps;
with Ada.Strings.Unbounded;

with GNAT.Regexp;

with AWS.Config;
with AWS.Resources.Files;
with AWS.Utils;

package body AWS.MIME is

   use Ada;
   use Ada.Strings.Unbounded;
   use GNAT;

   Default_Content_Type : constant String := Application_Octet_Stream;
   --  Default MIME Content Type used if nothing matches

   --  Table regexp components

   type R_MIME_Type is record
      Regexp    : GNAT.Regexp.Regexp; -- Filename Regexp
      MIME_Type : Unbounded_String;   -- Associated content type
   end record;

   type Node;
   type Node_Access is access Node;

   type Node is record
      Item : R_MIME_Type;
      Next : Node_Access;
   end record;

   function Equivalent_Keys (Left, Right : String) return Boolean;

   package Key_Value is new Ada.Containers.Indefinite_Hashed_Maps
     (String, String, Ada.Strings.Hash_Case_Insensitive, Equivalent_Keys, "=");

   --  Protected Set to access tables handling MIME types

   protected Set is

      function Get (Filename : String; Default : String) return String;
      --  Returns Filename's MIME content type

      function Extension (Content_Type : String) return String;
      --  Returns the best guess of the extension to use for the Content Type

      procedure Add_Extension (Ext : String; MIME_Type : String);
      --  Add Ext to the set of known content type extensions

      procedure Add_Regexp
        (Filename  : Regexp.Regexp;
         MIME_Type : String);
      --  Add Filename to the set of known content type regular expressions

   private
      Ext_Set : Key_Value.Map :=
                  [ --  Text

                    "css"     => Text_CSS,
                    "html"    => Text_HTML,
                    "htm"     => Text_HTML,
                    "txt"     => Text_Plain,
                    "ada"     => Text_Plain,
                    "ads"     => Text_Plain,
                    "adb"     => Text_Plain,
                    "c"       => Text_Plain,
                    "h"       => Text_Plain,
                    "xml"     => Text_XML,
                    "sgml"    => Text_X_SGML,
                    "sgm"     => Text_X_SGML,
                    "js"      => Text_Javascript,

                    --  Image

                    "gif"     => Image_Gif,
                    "jpg"     => Image_Jpeg,
                    "jpeg"    => Image_Jpeg,
                    "jpe"     => Image_Jpeg,
                    "png"     => Image_Png,
                    "tiff"    => Image_Tiff,
                    "svg"     => Image_SVG,
                    "tif"     => Image_Tiff,
                    "pnm"     => Image_X_Portable_Anymap,
                    "pbm"     => Image_X_Portable_Bitmap,
                    "pgm"     => Image_X_Portable_Graymap,
                    "ppm"     => Image_X_Portable_Pixmap,
                    "rgb"     => Image_X_RGB,
                    "xbm"     => Image_X_Xbitmap,
                    "xpm"     => Image_X_Xpixmap,
                    "xwd"     => Image_X_Xwindowdump,

                    --  Application

                    "ps"      => Application_Postscript,
                    "eps"     => Application_Postscript,
                    "ai"      => Application_Postscript,
                    "pdf"     => Application_Pdf,
                    "zip"     => Application_Zip,
                    "iso"     => Application_Octet_Stream,
                    "exe"     => Application_Octet_Stream,
                    "hqx"     => Application_Mac_Binhex40,
                    "doc"     => Application_Msword,
                    "ppt"     => Application_Powerpoint,
                    "rtf"     => Application_Rtf,
                    "Z"       => Application_X_Compress,
                    "gtar"    => Application_X_GTar,
                    "gz"      => Application_X_GZip,
                    "latex"   => Application_X_Latex,
                    "sh"      => Application_X_Sh,
                    "shar"    => Application_X_Shar,
                    "tar"     => Application_X_Tar,
                    "tgz"     => Application_X_GZip,
                    "tcl"     => Application_X_Tcl,
                    "tex"     => Application_X_Tex,
                    "texinfo" => Application_X_Texinfo,
                    "texi"    => Application_X_Texinfo,
                    "t"       => Application_X_Troff,
                    "tr"      => Application_X_Troff,
                    "roff"    => Application_X_Troff,
                    "man"     => Application_X_Troff_Man,

                    --  Audio

                    "au"      => Audio_Basic,
                    "snd"     => Audio_Basic,
                    "mpga"    => Audio_Mpeg,
                    "mp2"     => Audio_Mpeg,
                    "mp3"     => Audio_Mpeg,
                    "wav"     => Audio_X_Wav,
                    "ram"     => Audio_X_Pn_Realaudio,
                    "rpm"     => Audio_X_Pn_Realaudio_Plugin,
                    "ra"      => Audio_X_Realaudio,

                    --  Video

                    "mpeg"    => Video_Mpeg,
                    "mpg"     => Video_Mpeg,
                    "mpe"     => Video_Mpeg,
                    "qt"      => Video_Quicktime,
                    "mov"     => Video_Quicktime,
                    "avi"     => Video_X_Msvideo ];

      R_Table : Node_Access;
      Last    : Node_Access;
   end Set;

   function To_Lower (Item : String)
     return String
     renames Ada.Characters.Handling.To_Lower;

   procedure Initialize;
   --  Initialize MIME table

   function Is_Type
     (MIME_Type : String;
      Type_Name : String) return Boolean with Inline;
   --  Returns True if MIME_Type is of Type_Name type. The type name is the
   --  first part of the MIME Type (the part before the /).

   -------------------
   -- Add_Extension --
   -------------------

   procedure Add_Extension (Ext : String; MIME_Type : String) is
   begin
      Set.Add_Extension (Ext, MIME_Type);
   end Add_Extension;

   ----------------
   -- Add_Regexp --
   ----------------

   procedure Add_Regexp (Filename : String; MIME_Type : String) is
      R_Filename : Regexp.Regexp;
   begin
      R_Filename := Regexp.Compile (Filename);
      Set.Add_Regexp (R_Filename, MIME_Type);
   exception
      when Regexp.Error_In_Regexp =>
         raise Constraint_Error
           with "Regexp " & Filename & " can't be compiled";
   end Add_Regexp;

   ------------------
   -- Content_Type --
   ------------------

   function Content_Type
     (Filename : String;
      Default  : String := Application_Octet_Stream) return String is
   begin
      return Set.Get (Filename, Default => Default);
   end Content_Type;

   ---------------------
   -- Equivalent_Keys --
   ---------------------

   function Equivalent_Keys (Left, Right : String) return Boolean is
   begin
      return To_Lower (Left) = To_Lower (Right);
   end Equivalent_Keys;

   ---------------
   -- Extension --
   ---------------

   function Extension (Content_Type : String) return String is
   begin
      return Set.Extension (Content_Type);
   end Extension;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is

      Cnf     : constant Config.Object := Config.Get_Current with Unreferenced;
      --  Declared to initialize the configuration object and then reading the
      --  .ini file if any.

      AWS_MIME : constant String := Config.MIME_Types;

   begin
      --  Check if there is a aws.mime file to read

      if Utils.Is_Regular_File (AWS_MIME) then
         Load (MIME_File => AWS_MIME);
      end if;
   end Initialize;

   --------------------
   -- Is_Application --
   --------------------

   function Is_Application (MIME_Type : String) return Boolean is
   begin
      return Is_Type (MIME_Type, "application/");
   end Is_Application;

   --------------
   -- Is_Audio --
   --------------

   function Is_Audio (MIME_Type : String) return Boolean is
   begin
      return Is_Type (MIME_Type, "audio/");
   end Is_Audio;

   --------------
   -- Is_Image --
   --------------

   function Is_Image (MIME_Type : String) return Boolean is
   begin
      return Is_Type (MIME_Type, "image/");
   end Is_Image;

   -------------
   -- Is_Text --
   -------------

   function Is_Text (MIME_Type : String) return Boolean is
   begin
      return Is_Type (MIME_Type, "text/");
   end Is_Text;

   -------------
   -- Is_Type --
   -------------

   function Is_Type
     (MIME_Type : String;
      Type_Name : String) return Boolean is
   begin
      return MIME_Type'Length > Type_Name'Length
          and then
        To_Lower
          (MIME_Type
             (MIME_Type'First .. MIME_Type'First + Type_Name'Length - 1))
        = Type_Name;
   end Is_Type;

   --------------
   -- Is_Video --
   --------------

   function Is_Video (MIME_Type : String) return Boolean is
   begin
      return Is_Type (MIME_Type, "video/");
   end Is_Video;

   ----------
   -- Load --
   ----------

   procedure Load (MIME_File : String) is
      use type Strings.Maps.Character_Set;

      MIME_Set : constant Strings.Maps.Character_Set :=
                   not Strings.Maps.To_Set (" " & ASCII.HT);
      --  The token would be any characters sequence
      --  other then space an tab.

      File     : Resources.File_Type;

      Buffer   : String (1 .. 1_024);
      Last     : Natural;

      --  MIME type slice (M_First .. M_Last)

      M_First  : Positive;
      M_Last   : Natural;

      --  Extension slice (E_First .. E_Last)

      E_First  : Positive;
      E_Last   : Natural;

   begin
      Resources.Files.Open (File, MIME_File);

      while not Resources.End_Of_File (File) loop
         Resources.Get_Line (File, Buffer, Last);

         --  Look for the MIME type

         Strings.Fixed.Find_Token
           (Buffer (Buffer'First .. Last),
            MIME_Set, Strings.Inside, M_First, M_Last);

         E_First := M_Last + 1;

         Read_Extension : loop
            Strings.Fixed.Find_Token
              (Buffer (E_First .. Last),
               MIME_Set, Strings.Inside, E_First, E_Last);

            exit Read_Extension when E_Last = 0;

            if Buffer (E_First) = '/' and then Buffer (E_Last) = '/' then
               --  Regular expression is inside slashes
               Add_Regexp
                 (Buffer (E_First + 1 .. E_Last - 1),
                  Buffer (M_First .. M_Last));
            else
               Set.Add_Extension
                 (Buffer (E_First .. E_Last),
                  Buffer (M_First .. M_Last));
            end if;

            E_First := E_Last + 1;
         end loop Read_Extension;
      end loop;

      Resources.Close (File);
   end Load;

   ---------
   -- Set --
   ---------

   protected body Set is

      -------------------
      -- Add_Extension --
      -------------------

      procedure Add_Extension (Ext : String; MIME_Type : String) is
      begin
         Key_Value.Include (Ext_Set, Ext, MIME_Type);
      end Add_Extension;

      ----------------
      -- Add_Regexp --
      ----------------

      procedure Add_Regexp
        (Filename  : Regexp.Regexp;
         MIME_Type : String)
      is
         Item : constant R_MIME_Type
           := (Filename, To_Unbounded_String (MIME_Type));
      begin
         if R_Table = null then
            R_Table := new Node'(Item, null);
            Last    := R_Table;
         else
            Last.Next := new Node'(Item, null);
            Last      := Last.Next;
         end if;
      end Add_Regexp;

      ---------------
      -- Extension --
      ---------------

      function Extension (Content_Type : String) return String is
      begin
         if Content_Type = Default_Content_Type then
            null; -- We don't want to give unknown data the exe extension

         elsif Content_Type = Text_Plain then
            return "txt";

         else
            declare
               Position : Key_Value.Cursor := Ext_Set.First;
            begin
               while Key_Value.Has_Element (Position) loop
                  if Key_Value.Element (Position) = Content_Type then
                     return Key_Value.Key (Position);
                  end if;
                  Key_Value.Next (Position);
               end loop;
            end;
         end if;

         return "";
      end Extension;

      ---------
      -- Get --
      ---------

      function Get (Filename : String; Default : String) return String is
         Ext    : constant String := Directories.Extension (Filename);
         Cursor : Key_Value.Cursor;
      begin
         Cursor := Key_Value.Find (Ext_Set, Ext);

         if Key_Value.Has_Element (Cursor) then
            return Key_Value.Element (Cursor);

         else
            --  Check now in regexp list

            declare
               N : Node_Access := R_Table;
            begin
               while N /= null loop
                  if Regexp.Match (Filename, N.Item.Regexp) then
                     return To_String (N.Item.MIME_Type);
                  end if;

                  N := @.Next;
               end loop;
            end;
         end if;

         return Default;
      end Get;

   end Set;

begin
   Initialize;
end AWS.MIME;
