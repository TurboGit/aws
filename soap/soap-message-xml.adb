------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                         Copyright (C) 2000-2004                          --
--                                ACT-Europe                                --
--                                                                          --
--  Authors: Dmitriy Anisimkov - Pascal Obry                                --
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

with Ada.Calendar;
with Ada.Characters.Handling;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Exceptions;

with AWS.Client.XML.Input_Sources;

with Input_Sources.Strings;
with Unicode.CES.Utf8;
with DOM.Core.Nodes;
with Sax.Readers;

with SOAP.Message.Reader;
with SOAP.Message.Response.Error;
with SOAP.Types;
with SOAP.Utils;
with SOAP.XML;

package body SOAP.Message.XML is

   use Ada;
   use DOM.Core.Nodes;
   use SOAP.Message.Reader;

   NL : constant String := ASCII.CR & ASCII.LF;

   Max_Object_Size : constant := 2_048;
   --  This is the maximum number of items in a record or an array supported
   --  by this implementation.

   XML_Header : constant String := "<?xml version='1.0' encoding='UTF-8'?>";

   URL_Enc    : constant String := "http://schemas.xmlsoap.org/soap/encoding/";
   URL_Env    : constant String := "http://schemas.xmlsoap.org/soap/envelope/";
   URL_xsd    : constant String := "http://www.w3.org/1999/XMLSchema";
   URL_xsd_01 : constant String := "http://www.w3.org/2001/XMLSchema";
   URL_xsi    : constant String := "http://www.w3.org/1999/XMLSchema-instance";
   URL_xsi_01 : constant String := "http://www.w3.org/2001/XMLSchema-instance";

   Start_Env  : constant String := "<SOAP-ENV:Envelope";
   End_Env    : constant String := "</SOAP-ENV:Envelope>";

   Header     : constant String
     := Start_Env & ' '
     & "SOAP-ENV:encodingStyle=""" & URL_Enc & """ "
     & "xmlns:SOAP-ENC=""" & URL_Enc & """ "
     & "xmlns:SOAP-ENV=""" & URL_Env & """ "
     & "xmlns:xsd=""" & URL_xsd & """ "
     & "xmlns:xsi=""" & URL_xsi & """>";

   Start_Body : constant String := "<SOAP-ENV:Body>";
   End_Body   : constant String := "</SOAP-ENV:Body>";

   type Type_State is
     (Void, T_Undefined,
      T_Int, T_Float, T_Double, T_Long,
      T_String, T_Boolean, T_Time_Instant, T_Base64);

   type Namespaces is record
      --  ??? we will probably have to support more namespaces here
      xsd : Unbounded_String;
      xsi : Unbounded_String;
      enc : Unbounded_String;
   end record;

   type State is record
      Name_Space   : Unbounded_String; -- Wrapper routine namespace
      Wrapper_Name : Unbounded_String;
      Parameters   : SOAP.Parameters.List;
      A_State      : Type_State := Void;
      NS           : Namespaces;
   end record;

   function "-"
     (Str : in Unbounded_String)
      return String
      renames To_String;

   function To_Type
     (Type_Name : in String;
      NS        : in Namespaces)
      return Type_State;
   --  Given the Type_Name and the namespaces return the proper type

   procedure Parse_Namespaces
     (N  : in     DOM.Core.Node;
      NS : in out Namespaces);
   --  Read namespaces from node and set NS accordingly

   procedure Parse_Document
     (N : in     DOM.Core.Node;
      S : in out State);

   procedure Parse_Envelope
     (N : in     DOM.Core.Node;
      S : in out State);

   procedure Parse_Header
     (N : in     DOM.Core.Node;
      S : in out State);

   procedure Parse_Body
     (N : in     DOM.Core.Node;
      S : in out State);

   procedure Parse_Wrapper
     (N : in     DOM.Core.Node;
      S : in out State);

   function Parse_Int
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Long
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Float
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Double
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_String
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Boolean
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Base64
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Time_Instant
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   function Parse_Param
     (N : in DOM.Core.Node;
      S : in State)
      return Types.Object'Class;

   function Parse_Array
     (Name : in String;
      N    : in DOM.Core.Node;
      S    : in State)
      return Types.Object'Class;

   function Parse_Record
     (Name : in String;
      N : in DOM.Core.Node;
      S : in State)
      return Types.Object'Class;

   function Parse_Enumeration
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class;

   procedure Error (Node : in DOM.Core.Node; Message : in String);
   pragma No_Return (Error);
   --  Raises SOAP_Error with the Message as exception message

   type Parse_Type is access
     function (Name : in String;
               N    : in DOM.Core.Node)
               return Types.Object'Class;

   type Type_Name_Access is access constant String;

   type Type_Handler is record
      Name    : Type_Name_Access;
      Handler : Parse_Type;
      Encoded : Boolean; --  True if based on soap-enc namespaces
   end record;

   Handlers : constant array (Type_State) of Type_Handler
     := (Void           =>
           (null, null, False),
         T_Undefined    =>
           (Types.XML_Undefined'Access, null, False),
         T_Int          =>
           (Types.XML_Int'Access, Parse_Int'Access, False),
         T_Float        =>
           (Types.XML_Float'Access, Parse_Float'Access, False),
         T_Double       =>
           (Types.XML_Double'Access, Parse_Double'Access, False),
         T_Long         =>
           (Types.XML_Long'Access, Parse_Long'Access, False),
         T_String       =>
           (Types.XML_String'Access, Parse_String'Access, False),
         T_Boolean      =>
           (Types.XML_Boolean'Access, Parse_Boolean'Access, False),
         T_Base64       =>
           (Types.XML_Base64'Access, Parse_Base64'Access, True),
         T_Time_Instant =>
           (Types.XML_Time_Instant'Access, Parse_Time_Instant'Access, False));

   -----------
   -- Error --
   -----------

   procedure Error (Node : in DOM.Core.Node; Message : in String) is
      Name : constant String := Local_Name (Node);
   begin
      Exceptions.Raise_Exception (SOAP_Error'Identity, Name & " - " & Message);
   end Error;

   -----------
   -- Image --
   -----------

   function Image (O : in Object'Class) return String is
   begin
      return To_String (XML.Image (O));
   end Image;

   -----------
   -- Image --
   -----------

   function Image (O : in Object'Class) return Unbounded_String is
      Message_Body : Unbounded_String;
   begin
      --  Header

      Append (Message_Body, XML_Header & NL);
      Append (Message_Body, Header & NL);

      --  Body

      Append (Message_Body, Start_Body & NL);

      --  Wrapper

      Append (Message_Body, Message.XML_Image (O));

      --  End of Body and Envelope

      Append (Message_Body, End_Body & NL);
      Append (Message_Body, End_Env & NL);

      return Message_Body;
   end Image;

   ------------------
   -- Load_Payload --
   ------------------

   function Load_Payload (XML : in String) return Message.Payload.Object is
      use Input_Sources.Strings;

      Str    : aliased String := XML;

      Source : String_Input;
      Reader : Tree_Reader;
      S      : State;
      Doc    : DOM.Core.Document;

   begin
      Open (Str'Unchecked_Access,
            Unicode.CES.Utf8.Utf8_Encoding,
            Source);

      --  If True, xmlns:* attributes will be reported in Start_Element
      Set_Feature (Reader, Sax.Readers.Namespace_Prefixes_Feature, True);
      Set_Feature (Reader, Sax.Readers.Validation_Feature, False);

      Parse (Reader, Source);
      Close (Source);

      Doc := Get_Tree (Reader);

      Parse_Document (Doc, S);

      Free (Doc);

      return Message.Payload.Build
        (To_String (S.Wrapper_Name), S.Parameters, To_String (S.Name_Space));
   end Load_Payload;

   -------------------
   -- Load_Response --
   -------------------

   function Load_Response
     (Connection : in AWS.Client.HTTP_Connection)
      return Message.Response.Object'Class
   is
      use AWS.Client.XML.Input_Sources;

      Source : HTTP_Input;
      Reader : Tree_Reader;
      S      : State;
      Doc    : DOM.Core.Document;

   begin
      Create (Connection, Source);

      --  If True, xmlns:* attributes will be reported in Start_Element
      Set_Feature (Reader, Sax.Readers.Namespace_Prefixes_Feature, True);
      Set_Feature (Reader, Sax.Readers.Validation_Feature, False);

      Parse (Reader, Source);
      Close (Source);

      Doc := Get_Tree (Reader);

      Parse_Document (Doc, S);

      Free (Doc);

      if SOAP.Parameters.Exist (S.Parameters, "faultcode") then
         return Message.Response.Error.Build
           (Faultcode   =>
              Message.Response.Error.Faultcode
               (String'(SOAP.Parameters.Get (S.Parameters, "faultcode"))),
            Faultstring => SOAP.Parameters.Get (S.Parameters, "faultstring"));
      else
         return Message.Response.Object'
           (S.Name_Space, S.Wrapper_Name, S.Parameters);
      end if;

   exception
      when E : others =>
         return Message.Response.Error.Build
           (Faultcode   => Message.Response.Error.Client,
            Faultstring => Exceptions.Exception_Message (E));
   end Load_Response;

   function Load_Response
     (XML : in String)
      return Message.Response.Object'Class
   is
      use Input_Sources.Strings;

      Source : String_Input;
      Reader : Tree_Reader;
      S      : State;
      Doc    : DOM.Core.Document;

   begin
      Open (XML'Unrestricted_Access,
            Unicode.CES.Utf8.Utf8_Encoding,
            Source);

      --  If True, xmlns:* attributes will be reported in Start_Element
      Set_Feature (Reader, Sax.Readers.Namespace_Prefixes_Feature, True);
      Set_Feature (Reader, Sax.Readers.Validation_Feature, False);

      Parse (Reader, Source);
      Close (Source);

      Doc := Get_Tree (Reader);

      Parse_Document (Doc, S);

      Free (Doc);

      if SOAP.Parameters.Exist (S.Parameters, "faultcode") then
         return Message.Response.Error.Build
           (Faultcode   =>
              Message.Response.Error.Faultcode
               (String'(SOAP.Parameters.Get (S.Parameters, "faultcode"))),
            Faultstring => SOAP.Parameters.Get (S.Parameters, "faultstring"));
      else
         return Message.Response.Object'
           (S.Name_Space, S.Wrapper_Name, S.Parameters);
      end if;

   exception
      when E : others =>
         return Message.Response.Error.Build
           (Faultcode   => Message.Response.Error.Client,
            Faultstring => Exceptions.Exception_Message (E));
   end Load_Response;

   function Load_Response
     (XML : in Unbounded_String)
      return Message.Response.Object'Class
   is
      S : String_Access := new String (1 .. Length (XML));
   begin
      --  Copy XML content to local S string
      for I in 1 .. Length (XML) loop
         S (I) := Element (XML, I);
      end loop;

      declare
         Result : constant Message.Response.Object'Class
           := Load_Response (S.all);
      begin
         Free (S);
         return Result;
      end;
   end Load_Response;

   -----------------
   -- Parse_Array --
   -----------------

   function Parse_Array
     (Name : in String;
      N    : in DOM.Core.Node;
      S    : in State)
      return Types.Object'Class
   is
      use type DOM.Core.Node;
      use SOAP.Types;

      function Item_Type (Name : in String) return String;
      pragma Inline (Item_Type);
      --  Returns the array's item type, remove [] if present

      LS : State := S;

      ---------------
      -- Item_Type --
      ---------------

      function Item_Type (Name : in String) return String is
         N : constant Positive := Strings.Fixed.Index (Name, "[");
      begin
         return Name (Name'First .. N - 1);
      end Item_Type;

      OS    : Types.Object_Set (1 .. Max_Object_Size);
      K     : Natural := 0;

      Field : DOM.Core.Node;

      Atts  : constant DOM.Core.Named_Node_Map := Attributes (N);

   begin
      Parse_Namespaces (N, LS.NS);

      declare
         A_Name    : constant String := -LS.NS.enc & ":arrayType";
         --  Attribute name

         Type_Name : constant String
           := Item_Type (Node_Value (Get_Named_Item (Atts, A_Name)));

         A_Type    : constant Type_State := To_Type (Type_Name, LS.NS);
      begin
         Field := SOAP.XML.First_Child (N);

         while Field /= null loop
            K := K + 1;

            OS (K) := +Parse_Param
              (Field,
               (S.Name_Space, S.Wrapper_Name, S.Parameters, A_Type, S.NS));

            Field := Next_Sibling (Field);
         end loop;

         return Types.A
           (OS (1 .. K), Name, Utils.With_NS ("awsns", Type_Name));
      end;
   end Parse_Array;

   ------------------
   -- Parse_Base64 --
   ------------------

   function Parse_Base64
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      use type DOM.Core.Node;

      Value : DOM.Core.Node;
   begin
      Normalize (N);
      Value := First_Child (N);

      if Value = null then
         --  No node found, this is an empty Base64 content
         return Types.B64 ("", Name);

      else
         return Types.B64 (Node_Value (Value), Name);
      end if;
   end Parse_Base64;

   ----------------
   -- Parse_Body --
   ----------------

   procedure Parse_Body (N : in DOM.Core.Node; S : in out State) is
   begin
      Parse_Wrapper (SOAP.XML.First_Child (N), S);
   end Parse_Body;

   -------------------
   -- Parse_Boolean --
   -------------------

   function Parse_Boolean
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      Value : constant DOM.Core.Node := First_Child (N);
   begin
      if Node_Value (Value) = "1"
        or else Node_Value (Value) = "true"
        or else Node_Value (Value) = "TRUE"
      then
         return Types.B (True, Name);
      else
         --  ??? we should check for wrong boolean value
         return Types.B (False, Name);
      end if;
   end Parse_Boolean;

   --------------------
   -- Parse_Document --
   --------------------

   procedure Parse_Document (N : in DOM.Core.Node; S : in out State) is
      NL : constant DOM.Core.Node_List := Child_Nodes (N);
   begin
      if Length (NL) = 1 then
         Parse_Envelope (SOAP.XML.First_Child (N), S);
      else
         Error (N, "Document must have a single node, found "
                & Natural'Image (Length (NL)));
      end if;
   end Parse_Document;

   ------------------
   -- Parse_Double --
   ------------------

   function Parse_Double
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      Value : constant DOM.Core.Node := First_Child (N);
   begin
      return Types.D (Long_Long_Float'Value (Node_Value (Value)), Name);
   end Parse_Double;

   -----------------------
   -- Parse_Enumeration --
   -----------------------

   function Parse_Enumeration
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class is
   begin
      return Types.E
        (Node_Value (First_Child (N)),
         Utils.No_NS (SOAP.XML.Get_Attr_Value (N, "type")),
         Name);
   end Parse_Enumeration;

   --------------------
   -- Parse_Envelope --
   --------------------

   procedure Parse_Envelope (N : in DOM.Core.Node; S : in out State) is
      NL : constant DOM.Core.Node_List := Child_Nodes (N);
      LS : State := S;
   begin
      Parse_Namespaces (N, LS.NS);

      if Length (NL) = 1 then
         --  This must be the body
         Parse_Body (SOAP.XML.First_Child (N), LS);

      elsif Length (NL) = 2 then
         --  The first child must the header tag
         Parse_Header (SOAP.XML.First_Child (N), LS);

         --  The second child must be the body
         Parse_Body (SOAP.XML.Next_Sibling (First_Child (N)), LS);
      else
         Error (N, "Envelope must have at most two nodes, found "
                & Natural'Image (Length (NL)));
      end if;

      S := LS;
   end Parse_Envelope;

   -----------------
   -- Parse_Float --
   -----------------

   function Parse_Float
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      Value : constant DOM.Core.Node := First_Child (N);
   begin
      return Types.F (Long_Float'Value (Node_Value (Value)), Name);
   end Parse_Float;

   ------------------
   -- Parse_Header --
   ------------------

   procedure Parse_Header (N : in DOM.Core.Node; S : in out State) is
      pragma Unreferenced (S);
      Name : constant String := Local_Name (N);
   begin
      if Ada.Characters.Handling.To_Lower (Name) /= "header" then
         Error (N, "Header node expected, found " & Name);
      end if;
   end Parse_Header;

   ---------------
   -- Parse_Int --
   ---------------

   function Parse_Int
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      Value : constant DOM.Core.Node := First_Child (N);
   begin
      return Types.I (Integer'Value (Node_Value (Value)), Name);
   end Parse_Int;

   ----------------
   -- Parse_Long --
   ----------------

   function Parse_Long
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      Value : constant DOM.Core.Node := First_Child (N);
   begin
      return Types.L (Types.Long'Value (Node_Value (Value)), Name);
   end Parse_Long;

   ----------------------
   -- Parse_Namespaces --
   ----------------------

   procedure Parse_Namespaces
     (N  : in     DOM.Core.Node;
      NS : in out Namespaces)
   is
      Atts : constant DOM.Core.Named_Node_Map := Attributes (N);
   begin
      for K in 0 .. Length (Atts) - 1 loop
         declare
            N     : constant DOM.Core.Node := Item (Atts, K);
            Name  : constant String        := Node_Name (N);
            Value : constant String        := Node_Value (N);
         begin
            if Utils.NS (Name) = "xmlns" then
               if Value = URL_xsd or else Value = URL_xsd_01 then
                  NS.xsd := To_Unbounded_String (Utils.No_NS (Name));
               elsif Value = URL_xsi or else Value = URL_xsi_01 then
                  NS.xsi := To_Unbounded_String (Utils.No_NS (Name));
               elsif Value = URL_Enc then
                  NS.enc := To_Unbounded_String (Utils.No_NS (Name));
               end if;
            end if;
         end;
      end loop;
   end Parse_Namespaces;

   -----------------
   -- Parse_Param --
   -----------------

   function Parse_Param
     (N : in DOM.Core.Node;
      S : in State)
      return Types.Object'Class
   is
      use type DOM.Core.Node;
      use type DOM.Core.Node_Types;

      function Is_Array return Boolean;
      --  Returns True if N is an array node

      Name : constant String                  := Local_Name (N);

      Ref  : constant DOM.Core.Node           := SOAP.XML.Get_Ref (N);
      Atts : constant DOM.Core.Named_Node_Map := Attributes (Ref);
      LS   : State := S;

      --------------
      -- Is_Array --
      --------------

      function Is_Array return Boolean is
         XSI_Type : constant DOM.Core.Node
           := Get_Named_Item (Atts, -(LS.NS.xsi) & ":type");
         xsd : constant String := Node_Value (XSI_Type);
      begin
         --  ???
         return Utils.No_NS (xsd) = "Array"
           and then Get_Named_Item
                      (Atts, Utils.NS (xsd) & ":arrayType") /= null;
      end Is_Array;

      S_Type   : constant DOM.Core.Node := Get_Named_Item (Atts, "type");
      XSI_Type : DOM.Core.Node;

   begin
      Parse_Namespaces (Ref, LS.NS);

      XSI_Type := Get_Named_Item (Atts, To_String (LS.NS.xsi) & ":type");

      if To_String (S.Wrapper_Name) = "Fault" then
         return Parse_String (Name, Ref);

      else
         if XSI_Type = null and then S.A_State in Void .. T_Undefined then
            --  No xsi:type attribute found

            if Get_Named_Item (Atts, -LS.NS.xsi & ":null") /= null then
               return Types.N (Name);

            elsif S_Type /= null
              and then First_Child (Ref).Node_Type = DOM.Core.Text_Node
            then
               --  Not xsi:type but a type information, the child being a text
               --  node, this is an enumeration.

               return Parse_Enumeration (Name, Ref);

            elsif First_Child (Ref) /= null
              and then First_Child (Ref).Node_Type = DOM.Core.Text_Node
            then
               --  No xsi:type and no type information.
               --  Children are some kind of text data, so this is a data node
               --  with no type information. Note that this code is to
               --  workaround an interoperability problem with Microsoft SOAP
               --  implementation based on WSDL were the type information is
               --  not provided into the payload but only on the WSDL file. As
               --  AWS/SOAP is not WSDL compliant at this point we treat
               --  undefined type as string values, it is up to the developper
               --  to convert the string to the right type. Note that this
               --  code is only there to parse data received from a SOAP
               --  server. AWS/SOAP always send type information into the
               --  payload.
               --  ??? If payload xsi:type information becomes mandatory this
               --  conditional section should be removed.

               return Parse_String (Name, Ref);

            else
               --  This is a type defined in a schema, either a SOAP record
               --  or an enumeration, enumerations will be checked into
               --  Parse record.
               --  This is a SOAP record, we have no attribute and no
               --  type defined. We have a single tag "<name>" which can
               --  only be the start or a record.

               return Parse_Record (Name, Ref, LS);
            end if;

         else
            if S.A_State in Void .. T_Undefined then
               --  No array type state

               declare
                  xsd    : constant String     := Node_Value (XSI_Type);
                  S_Type : constant Type_State := To_Type (xsd, LS.NS);
               begin
                  if S_Type = T_Undefined then
                     if Is_Array then
                        return Parse_Array (Name, Ref, LS);

                     else
                        --  Not a known basic type, let's try to parse a
                        --  record object. This implemtation does not
                        --  support schema so there is no way to check
                        --  for the real type here.

                        return Parse_Record (Name, Ref, LS);
                     end if;

                  else
                     return Handlers (S_Type).Handler (Name, Ref);
                  end if;
               end;

            else
               return Handlers (S.A_State).Handler (Name, Ref);
            end if;
         end if;
      end if;
   end Parse_Param;

   ------------------
   -- Parse_Record --
   ------------------

   function Parse_Record
     (Name : in String;
      N    : in DOM.Core.Node;
      S    : in State)
      return Types.Object'Class
   is
      use type DOM.Core.Node;
      use type DOM.Core.Node_Types;
      use SOAP.Types;

      OS : Types.Object_Set (1 .. Max_Object_Size);
      K  : Natural := 0;

      Field : DOM.Core.Node := SOAP.XML.Get_Ref (N);
   begin
      if Name /= Local_Name (N)
        and then First_Child (Field).Node_Type = DOM.Core.Text_Node
      then
         --  This is not a record after all, it is an enumeration with an href
         --  A record can't have a text child node.
         return Types.E
           (Node_Value (First_Child (Field)),
            Utils.No_NS (SOAP.XML.Get_Attr_Value (Field, -S.NS.xsi & ":type")),
            Name);

      else
         Field := SOAP.XML.First_Child (Field);

         while Field /= null loop
            K := K + 1;
            OS (K) := +Parse_Param (Field, S);

            Field := Next_Sibling (Field);
         end loop;

         return Types.R (OS (1 .. K), Name);
      end if;
   end Parse_Record;

   ------------------
   -- Parse_String --
   ------------------

   function Parse_String
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      use type DOM.Core.Node;
      use type DOM.Core.Node_Types;

      L : constant DOM.Core.Node_List := Child_Nodes (N);
      S : Unbounded_String;
      P : DOM.Core.Node;
   begin
      for I in 0 .. Length (L) - 1 loop
         P := Item (L, I);
         if P.Node_Type = DOM.Core.Text_Node then
            Append (S, Node_Value (P));
         end if;
      end loop;

      return Types.S (S, Name);
   end Parse_String;

   ------------------------
   -- Parse_Time_Instant --
   ------------------------

   function Parse_Time_Instant
     (Name : in String;
      N    : in DOM.Core.Node)
      return Types.Object'Class
   is
      use Ada.Calendar;

      Value : constant DOM.Core.Node := First_Child (N);
      TI    : constant String        := Node_Value (Value);

      T     : Time;
   begin
      --  timeInstant format is CCYY-MM-DDThh:mm:ss[[+|-]hh:mm | Z]

      T := Time_Of (Year    => Year_Number'Value (TI (1 .. 4)),
                    Month   => Month_Number'Value (TI (6 .. 7)),
                    Day     => Day_Number'Value (TI (9 .. 10)),
                    Seconds => Duration (Natural'Value (TI (12 .. 13)) * 3600
                                           + Natural'Value (TI (15 .. 16)) * 60
                                           + Natural'Value (TI (18 .. 19))));

      if TI'Last = 19                           -- No timezone
        or else
          (TI'Last = 20 and then TI (20) = 'Z') -- GMT timezone
        or else
          TI'Last < 22                          -- No enough timezone data
      then
         return Types.T (T, Name);
      else
         return Types.T (T, Name, Types.TZ'Value (TI (20 .. 22)));
      end if;
   end Parse_Time_Instant;

   -------------------
   -- Parse_Wrapper --
   -------------------

   procedure Parse_Wrapper (N : in DOM.Core.Node; S : in out State) is
      use type SOAP.Parameters.List;
      use type DOM.Core.Node_Types;

      function Prefix return String;
      --  Returns node prefix (with a ':' in front) if a prefix is used for
      --  the node N.

      NL   : constant DOM.Core.Node_List      := Child_Nodes (N);
      Name : constant String                  := Local_Name (N);
      Atts : constant DOM.Core.Named_Node_Map := Attributes (N);
      LS   : State := S;

      ------------
      -- Prefix --
      ------------

      function Prefix return String is
         Prefix : constant String := DOM.Core.Nodes.Prefix (N);
      begin
         if Prefix = "" then
            return "";
         else
            return ':' & Prefix;
         end if;
      end Prefix;

   begin
      Parse_Namespaces (N, LS.NS);

      if Length (Atts) /= 0 then
         declare
            use type DOM.Core.Node;

            xmlns : constant DOM.Core.Node
              := Get_Named_Item (Atts, "xmlns" & Prefix);
         begin
            if xmlns /= null then
               S.Name_Space := To_Unbounded_String (Node_Value (xmlns));
            end if;
         end;
      end if;

      S.Wrapper_Name := To_Unbounded_String (Name);

      for K in 0 .. Length (NL) - 1 loop
         if Item (NL, K).Node_Type /= DOM.Core.Text_Node then
            S.Parameters := S.Parameters & Parse_Param (Item (NL, K), LS);
         end if;
      end loop;
   end Parse_Wrapper;

   -------------
   -- To_Type --
   -------------

   function To_Type
     (Type_Name : in String;
      NS        : in Namespaces)
      return Type_State
   is
      function Is_A
        (T1_Name, T2_Name : in String;
         NS               : in Unbounded_String) return Boolean;
      pragma Inline (Is_A);
      --  Returns True if T1_Name is equal to T2_Name based on namespace

      ----------
      -- Is_A --
      ----------

      function Is_A
        (T1_Name, T2_Name : in String;
         NS               : in Unbounded_String) return Boolean is
      begin
         return T1_Name = Utils.With_NS (-NS, T2_Name);
      end Is_A;

   begin
      for K in Handlers'Range loop
         if Handlers (K).Name /= null
           and then
             ((Handlers (K).Encoded
               and then Is_A (Type_Name, Handlers (K).Name.all, NS.enc))
              or else Is_A (Type_Name, Handlers (K).Name.all, NS.xsd))
         then
            return K;
         end if;
      end loop;

      return T_Undefined;
   end To_Type;

end SOAP.Message.XML;
