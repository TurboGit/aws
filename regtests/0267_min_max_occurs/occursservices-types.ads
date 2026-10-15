--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Calendar;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
with SOAP.Parameters;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Parameters);
with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

with n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
with www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg;
with n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg;
with n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg;


package OccursServices.Types
  with Elaborate_Body
is

   use n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
   use www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg;
   use n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg;
   use n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg;


   use Ada.Strings.Unbounded;

   function "+"
     (Str : String)
      return Unbounded_String
      renames To_Unbounded_String;
   function "-"
     (Str : Unbounded_String)
      return String
      renames To_String;

   
   -- Enumeration T_Battle_Dimension_Type

   subtype s0_T_Battle_Dimension_Type is n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.T_Battle_Dimension_Type;
   subtype T_Battle_Dimension_Type
     is s0_T_Battle_Dimension_Type;

   function Image (E : s0_T_Battle_Dimension_Type)
     return String
     renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.Image;

   function To_T_Battle_Dimension_Type
     (O : SOAP.Types.Object'Class)
      return s0_T_Battle_Dimension_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.To_T_Battle_Dimension_Type;

   function To_T_Battle_Dimension_Type
     (L : SOAP.Parameters.List)
      return s0_T_Battle_Dimension_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.To_T_Battle_Dimension_Type;

   function To_SOAP_Object
     (R         : s0_T_Battle_Dimension_Type;
      Name      : String := "item";
      Type_Name : String := n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.Q_Type_Name;
      NS        : SOAP.Name_Space.Object := n81.n67.n51.n47.HECATEEWebServices.encodedTypes.Name_Space)
      return SOAP.Types.SOAP_Enumeration
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg.To_SOAP_Object;
   
   --  Array string_Set_Type

   s_Name_Space : SOAP.Name_Space.Object
     renames www.w3.org.n2001.XMLSchema.Name_Space;

   package s_string_Set_Type_Pck
     renames  www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.string_Set_Type_Pck;

   subtype s_string_Set_Type
     is s_string_Set_Type_Pck.Vector;

   function "+" (V : s_string_Set_Type)
     return s_string_Set_Type
     renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg."+";
   subtype string_Set_Type
     is s_string_Set_Type;

   function To_string_Set_Type
     (From : SOAP.Types.Object_Set)
      return s_string_Set_Type
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.To_string_Set_Type;

   function To_string_Set_Type
     (L : SOAP.Parameters.List)
      return s_string_Set_Type
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.To_string_Set_Type;

   function To_Object_Set
     (From : s_string_Set_Type;
      NS   : SOAP.Name_Space.Object := SOAP.Name_Space.No_Name_Space)
      return SOAP.Types.Object_Set
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.To_Object_Set;

   function To_SOAP_Object
     (A         : string_Set_Type;
      Name      : String := "item";
      Type_Name : String := www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.Q_Type_Name;
      NS        : SOAP.Name_Space.Object := s_Name_Space)
      return SOAP.Types.SOAP_Array
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.To_SOAP_Object;

   function To_Optional_SOAP_Object
     (A         : string_Set_Type;
      Name      : String := "item";
      Type_Name : String := www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.E_Type_Name;
      NS        : SOAP.Name_Space.Object := s_Name_Space)
      return SOAP.Types.XSD_String
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.To_Optional_SOAP_Object;

   function From_Optional_SOAP_Object
     (O : SOAP.Types.Object'Class)
      return string_Set_Type
      renames www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg.From_Optional_SOAP_Object;
   
   --  Record T_Track_Type

   s0_Name_Space : SOAP.Name_Space.Object
     renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.Name_Space;

   subtype s0_T_Track_Type
     is n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.T_Track_Type;
   subtype T_Track_Type
     is s0_T_Track_Type;

   function To_T_Track_Type
     (O : SOAP.Types.Object'Class)
      return s0_T_Track_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.To_T_Track_Type;

   function To_T_Track_Type
     (P_List : SOAP.Parameters.List)
      return s0_T_Track_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.To_T_Track_Type;

   function To_T_Track_Type_W
     (R : SOAP.Parameters.List)
      return s0_T_Track_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.To_T_Track_Type_W;

   function To_SOAP_Object
     (R         : s0_T_Track_Type;
      Name      : String := "item";
      Type_Name : String := n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.Q_Type_Name;
      NS        : SOAP.Name_Space.Object := s0_Name_Space)
      return SOAP.Types.SOAP_Record
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.To_SOAP_Object;

   function To_Parameter_List
     (R  : s0_T_Track_Type;
      NS : SOAP.Name_Space.Object := s0_Name_Space)
      return SOAP.Parameters.List
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg.To_Parameter_List;


   
   --  Array ArrayOfFloat_Type

   package s0_ArrayOfFloat_Type_Pck
     renames  n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.ArrayOfFloat_Type_Pck;

   subtype s0_ArrayOfFloat_Type
     is s0_ArrayOfFloat_Type_Pck.Vector;

   function "+" (V : s0_ArrayOfFloat_Type)
     return s0_ArrayOfFloat_Type
     renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg."+";
   subtype ArrayOfFloat_Type
     is s0_ArrayOfFloat_Type;

   function To_ArrayOfFloat_Type
     (From : SOAP.Types.Object_Set)
      return s0_ArrayOfFloat_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.To_ArrayOfFloat_Type;

   function To_ArrayOfFloat_Type
     (L : SOAP.Parameters.List)
      return s0_ArrayOfFloat_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.To_ArrayOfFloat_Type;

   function To_Object_Set
     (From : s0_ArrayOfFloat_Type;
      NS   : SOAP.Name_Space.Object := SOAP.Name_Space.No_Name_Space)
      return SOAP.Types.Object_Set
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.To_Object_Set;

   function To_SOAP_Object
     (A         : ArrayOfFloat_Type;
      Name      : String := "item";
      Type_Name : String := n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.Q_Type_Name;
      NS        : SOAP.Name_Space.Object := s0_Name_Space)
      return SOAP.Types.SOAP_Array
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.To_SOAP_Object;

   function To_Optional_SOAP_Object
     (A         : ArrayOfFloat_Type;
      Name      : String := "item";
      Type_Name : String := n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.E_Type_Name;
      NS        : SOAP.Name_Space.Object := s0_Name_Space)
      return SOAP.Types.XSD_Float
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.To_Optional_SOAP_Object;

   function From_Optional_SOAP_Object
     (O : SOAP.Types.Object'Class)
      return ArrayOfFloat_Type
      renames n81.n67.n51.n47.HECATEEWebServices.encodedTypes.ArrayOfFloat_Type_Pkg.From_Optional_SOAP_Object;

end OccursServices.Types;
