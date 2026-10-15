--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

with Ada.Tags;

with SOAP.Parameters;

with OccursServices.Types;

package body n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg is

   use Ada.Tags;
   use SOAP.Types;

   --
   -- To_T_Track_Type
   --

   function To_T_Track_Type
     (O : SOAP.Types.Object'Class)
      return T_Track_Type
   is
      R : constant SOAP.Types.SOAP_Record :=
            SOAP.Types.SOAP_Record (O);
      L : constant SOAP.Parameters.List :=
            SOAP.Parameters.To_List (SOAP.Types.V (R));
   begin
      return To_T_Track_Type (L);
   end To_T_Track_Type;

   function To_T_Track_Type
     (P_List : SOAP.Parameters.List)
      return T_Track_Type
   is

      p_battleDimension : constant SOAP.Types.Object'Class :=
        SOAP.Parameters.Argument (P_List, "p_battleDimension");
      p_tag             : constant SOAP.Types.Object_Setx :=
        SOAP.Parameters.Get (P_List, "p_tag");

      ResultT_Track_Type : T_Track_Type;
   begin
      -- p_battleDimension
      ResultT_Track_Type.p_battleDimension := To_T_Battle_Dimension_Type (p_battleDimension);
      -- p_tag
      ResultT_Track_Type.p_tag := +To_string_Set_Type (p_tag);


      return ResultT_Track_Type;
   exception
      when Constraint_Error =>
         if p_battleDimension /= No_Object
            and then p_battleDimension'Tag /= SOAP.Types.SOAP_Enumeration'Tag
         then
            raise SOAP.SOAP_Error
              with "<R>.p_battleDimension expected SOAP.Types.SOAP_Enumeration, "
                 & "found " & External_Tag (p_battleDimension'Tag);
         end if;
         raise;
   end To_T_Track_Type;

   --
   -- To_SOAP_Object
   --

   function To_SOAP_Object
     (R         : T_Track_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Record
   is

      function Get_NS (Is_Ref : Boolean; NS : SOAP.Name_Space.Object)
        return SOAP.Name_Space.Object is (NS);


      ResultT_Track_Type : SOAP.Types.SOAP_Record;
   begin
      ResultT_Track_Type := SOAP.Types.R
        (SOAP.Parameters.Get (To_Parameter_List (R)),
         Name, Q_Type_Name, NS => NS);

      return ResultT_Track_Type;
   end To_SOAP_Object;

   --
   -- To_Parameter_List
   --

   function To_Parameter_List
     (R  : T_Track_Type;
      NS : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Parameters.List
   is
      use type SOAP.Parameters.List;

      function Get_NS
        (Is_Ref : Boolean;
         NS     : SOAP.Name_Space.Object) return SOAP.Name_Space.Object is
        (if Is_Ref or Qualified_Element
         then NS
         else SOAP.Name_Space.No_Name_Space);

      ResultT_Track_Type : SOAP.Parameters.List;
   begin
      --  p_battleDimension
      ResultT_Track_Type := ResultT_Track_Type
        & To_SOAP_Object
            (R.p_battleDimension,
             "p_battleDimension", "s0:T_Battle_Dimension",
             Get_NS (False,
                     SOAP.Name_Space.Create ("s0", "http://81.67.51.47/HECATEEWebServices/encodedTypes")));
      --  p_tag
      ResultT_Track_Type := ResultT_Track_Type
        & SOAP_Set'(SOAP.Types.Set (To_Object_Set
            (R.p_tag,
             SOAP.Name_Space.Create ("s", "http://www.w3.org/2001/XMLSchema")),
             "p_tag", "s:string_Set")
        );

      return ResultT_Track_Type;
   end To_Parameter_List;

end n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Track_Type_Pkg;
