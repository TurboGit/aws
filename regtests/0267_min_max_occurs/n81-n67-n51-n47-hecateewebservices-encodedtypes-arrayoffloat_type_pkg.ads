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



package n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg is


   pragma Warnings (Off, Ada.Strings.Unbounded);
   pragma Warnings (Off, SOAP.Parameters);
   pragma Warnings (Off, SOAP.Types);
   pragma Warnings (Off, SOAP.Utils);

   pragma Style_Checks (Off);

   use Ada.Strings.Unbounded;
   use type Ada.Containers.Count_Type;
   use type Ada.Tags.Tag;
   use type Float;


   function "+"
     (Str : String)
      return Unbounded_String
      renames To_Unbounded_String;
   function "-"
     (Str : Unbounded_String)
      return String
      renames To_String;

   Q_Type_Name : constant String := "s0:ArrayOfFloat";
   E_Type_Name : constant String := "s:float";

   package ArrayOfFloat_Type_Pck is new Ada.Containers.Vectors
     (Positive, Float);

   subtype ArrayOfFloat_Type is ArrayOfFloat_Type_Pck.Vector;
   subtype s0_ArrayOfFloat_Type is ArrayOfFloat_Type;

   function "+" (V : ArrayOfFloat_Type)
     return ArrayOfFloat_Type is (V);

   function To_ArrayOfFloat_Type is new SOAP.Utils.To_Vector
     (ArrayOfFloat_Type_Pck, SOAP.Types.Get);

   function To_Object_Set is new SOAP.Utils.To_Object_Set_V
     (ArrayOfFloat_Type_Pck,
      SOAP.Types.XSD_Float,
      "item",
      E_Type_Name,
      SOAP.Types.F);


   function To_s0_ArrayOfFloat_Type
     (From : SOAP.Types.Object_Set)
      return ArrayOfFloat_Type
      renames To_ArrayOfFloat_Type;

   function To_ArrayOfFloat_Type (O : SOAP.Types.Object'Class)
     return ArrayOfFloat_Type
     is (To_ArrayOfFloat_Type (SOAP.Types.V (SOAP.Types.Composite (O))));
   function To_s0_ArrayOfFloat_Type (O : SOAP.Types.Object'Class)
     return ArrayOfFloat_Type
     renames To_ArrayOfFloat_Type;

   function To_ArrayOfFloat_Type (L : SOAP.Parameters.List)
     return ArrayOfFloat_Type
     is (To_ArrayOfFloat_Type (SOAP.Parameters.Argument (L, 1)));
   function To_s0_ArrayOfFloat_Type (L : SOAP.Parameters.List)
     return ArrayOfFloat_Type
     renames To_ArrayOfFloat_Type;

   function To_SOAP_Object
     (A         : ArrayOfFloat_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Array
      is (SOAP.Types.SOAP_Array'
           (SOAP.Types.A (To_Object_Set (A, NS), Name, Type_Name, NS)));

   function To_Optional_SOAP_Object
     (A         : ArrayOfFloat_Type;
      Name      : String := "item";
      Type_Name : String := E_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.XSD_Float
      is (SOAP.Types.F (A.First_Element, Name, Type_Name, NS))
    with Pre => A.Length = 1;
   --  Use to get an optional argument passed as parameter or in a
   --  record's field.

   function From_Optional_SOAP_Object
     (O : SOAP.Types.Object'Class)
      return ArrayOfFloat_Type
      is ([SOAP.Types.Get (O)])
    with Pre  => O'Tag = SOAP.Types.XSD_Float'Tag,
         Post => From_Optional_SOAP_Object'Result.Length = 1;
   --  Use to get an optional argument passed as parameter or in a
   --  record's field.

end n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg;
