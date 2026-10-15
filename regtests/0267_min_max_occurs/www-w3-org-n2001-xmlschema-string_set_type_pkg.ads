--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Containers.Vectors;

with Ada.Strings.Unbounded;
with Ada.Tags;
with SOAP.Parameters;
with SOAP.Types;
with SOAP.Utils;



package www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg is


   pragma Warnings (Off, Ada.Strings.Unbounded);
   pragma Warnings (Off, SOAP.Parameters);
   pragma Warnings (Off, SOAP.Types);
   pragma Warnings (Off, SOAP.Utils);

   pragma Style_Checks (Off);

   use Ada.Strings.Unbounded;
   use type Ada.Containers.Count_Type;
   use type Ada.Tags.Tag;
   use type Unbounded_String;


   function "+"
     (Str : String)
      return Unbounded_String
      renames To_Unbounded_String;
   function "-"
     (Str : Unbounded_String)
      return String
      renames To_String;

   Q_Type_Name : constant String := "s:string_Set";
   E_Type_Name : constant String := "s:string";

   package string_Set_Type_Pck is new Ada.Containers.Vectors
     (Positive, Unbounded_String);

   subtype string_Set_Type is string_Set_Type_Pck.Vector;
   subtype s_string_Set_Type is string_Set_Type;

   function "+" (V : string_Set_Type)
     return string_Set_Type is (V);

   function To_string_Set_Type is new SOAP.Utils.To_Vector
     (string_Set_Type_Pck, SOAP.Utils.Get);

   function To_Object_Set is new SOAP.Utils.To_Object_Set_V
     (string_Set_Type_Pck,
      SOAP.Types.XSD_String,
      "",
      E_Type_Name,
      SOAP.Utils.US);


   function To_s_string_Set_Type
     (From : SOAP.Types.Object_Set)
      return string_Set_Type
      renames To_string_Set_Type;

   function To_string_Set_Type (O : SOAP.Types.Object'Class)
     return string_Set_Type
     is (To_string_Set_Type (SOAP.Types.V (SOAP.Types.Composite (O))));
   function To_s_string_Set_Type (O : SOAP.Types.Object'Class)
     return string_Set_Type
     renames To_string_Set_Type;

   function To_string_Set_Type (L : SOAP.Parameters.List)
     return string_Set_Type
     is (To_string_Set_Type (SOAP.Parameters.Argument (L, 1)));
   function To_s_string_Set_Type (L : SOAP.Parameters.List)
     return string_Set_Type
     renames To_string_Set_Type;

   function To_SOAP_Object
     (A         : string_Set_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Array
      is (SOAP.Types.SOAP_Array'
           (SOAP.Types.A (To_Object_Set (A, NS), Name, Type_Name, NS)));

   function To_Optional_SOAP_Object
     (A         : string_Set_Type;
      Name      : String := "item";
      Type_Name : String := E_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.XSD_String
      is (SOAP.Utils.US (A.First_Element, Name, Type_Name, NS))
    with Pre => A.Length = 1;
   --  Use to get an optional argument passed as parameter or in a
   --  record's field.

   function From_Optional_SOAP_Object
     (O : SOAP.Types.Object'Class)
      return string_Set_Type
      is ([SOAP.Utils.Get (O)])
    with Pre  => O'Tag = SOAP.Types.XSD_String'Tag,
         Post => From_Optional_SOAP_Object'Result.Length = 1;
   --  Use to get an optional argument passed as parameter or in a
   --  record's field.

end www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg;
