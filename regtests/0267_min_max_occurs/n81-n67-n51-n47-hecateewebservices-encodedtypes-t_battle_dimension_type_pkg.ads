--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with SOAP.Parameters;
with SOAP.Types;


package n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg is

   Q_Type_Name : constant String := "s0:T_Battle_Dimension";

   type T_Battle_Dimension_Type is
     (SPACE, AIR, GROUND, SEA_SURFACE, SEA_SUBSURFACE, SOF);

   subtype s0_T_Battle_Dimension_Type is T_Battle_Dimension_Type;

   function To_T_Battle_Dimension_Type
     (D : T_Battle_Dimension_Type) return T_Battle_Dimension_Type is (D);
   function To_s0_T_Battle_Dimension_Type
     (D : T_Battle_Dimension_Type)
      return T_Battle_Dimension_Type
      renames To_T_Battle_Dimension_Type;

   function From_T_Battle_Dimension_Type
     (D : T_Battle_Dimension_Type) return T_Battle_Dimension_Type is (D);
   function From_s0_T_Battle_Dimension_Type
     (D : T_Battle_Dimension_Type)
      return T_Battle_Dimension_Type
      renames From_T_Battle_Dimension_Type;

   function Image (E : T_Battle_Dimension_Type) return String;
   function Value (S : String) return T_Battle_Dimension_Type;

   function To_String_Type
     (D : T_Battle_Dimension_Type)
      return String is (Image (D));

   function From_String_Type
     (D : String)
      return T_Battle_Dimension_Type is (Value (D));

   function To_T_Battle_Dimension_Type
     (O : SOAP.Types.Object'Class)
      return T_Battle_Dimension_Type is
        (From_String_Type (SOAP.Types.V (SOAP.Types.SOAP_Enumeration (O))));
   function To_s0_T_Battle_Dimension_Type
     (O : SOAP.Types.Object'Class)
      return T_Battle_Dimension_Type
      renames To_T_Battle_Dimension_Type;

   function To_T_Battle_Dimension_Type
     (L : SOAP.Parameters.List)
      return T_Battle_Dimension_Type
      is (To_T_Battle_Dimension_Type (SOAP.Parameters.Argument (L, 1)));
   function To_s0_T_Battle_Dimension_Type
     (L : SOAP.Parameters.List)
      return T_Battle_Dimension_Type
      renames To_T_Battle_Dimension_Type;

   function To_SOAP_Object
     (D         : T_Battle_Dimension_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Enumeration is
        (SOAP.Types.E (Image (D), Type_Name, Name, NS));

end n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
