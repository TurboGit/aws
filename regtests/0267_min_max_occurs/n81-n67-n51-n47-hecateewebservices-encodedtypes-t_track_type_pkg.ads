--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Strings.Unbounded;

with SOAP.Parameters;
with SOAP.Types;
with SOAP.Utils;

with n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
with www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg;


package n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg is

   use n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
   use www.w3.org.n2001.XMLSchema.string_Set_Type_Pkg;

   pragma Warnings (Off, Ada.Strings.Unbounded);
   pragma Warnings (Off, SOAP.Types);
   pragma Warnings (Off, SOAP.Utils);

   pragma Style_Checks (Off);

   use Ada.Strings.Unbounded;

   function "+"
     (Str : String)
      return Unbounded_String
      renames To_Unbounded_String;
   function "-"
     (Str : Unbounded_String)
      return String
      renames To_String;

   Q_Type_Name : constant String := "s0:T_Track";

   type T_Track_Type is record
      p_battleDimension : s0_T_Battle_Dimension_Type;
      p_tag             : s_string_Set_Type;
   end record
   ;

   subtype s0_T_Track_Type is T_Track_Type;

   function To_T_Track_Type
     (O : SOAP.Types.Object'Class)
      return T_Track_Type;
   function To_s0_T_Track_Type
     (O : SOAP.Types.Object'Class)
      return T_Track_Type
      renames To_T_Track_Type;

   function To_T_Track_Type
     (P_List : SOAP.Parameters.List)
      return T_Track_Type;
   function To_s0_T_Track_Type
     (P_List : SOAP.Parameters.List)
      return T_Track_Type
      renames To_T_Track_Type;

   function To_T_Track_Type_W
     (R : SOAP.Parameters.List)
      return T_Track_Type
      is (To_T_Track_Type (SOAP.Parameters.Argument (R, 1)));
   function To_s0_T_Track_Type_W
     (R : SOAP.Parameters.List)
      return T_Track_Type
      renames To_T_Track_Type_W;

   function To_SOAP_Object
     (R         : T_Track_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Record;

   function To_Parameter_List
     (R  : T_Track_Type;
      NS : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Parameters.List;

end n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg;
