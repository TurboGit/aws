
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with Ada.Tags;

package body www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg is

   use Ada.Tags;
   use SOAP.Types;

   ---------------------
   -- Record big_Type --
   ---------------------

   function To_big_Type
     (O : SOAP.Types.Object'Class)
      return big_Type
   is
      R : constant SOAP.Types.SOAP_Record := SOAP.Types.SOAP_Record (O);
      id : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "id");
      one : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "one");
      two : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "two");
      three : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "three");
      four : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "four");
      five : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "five");
      six : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "six");
      seven : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "seven");
      eight : constant SOAP.Types.Object'Class := SOAP.Types.V (R, "eight");
   begin
      return (SOAP.Types.Get (id),
              From_tns_NonNegativeInt_Type (From_int_Type (SOAP.Types.V (SOAP.Types.XSD_Integer (one)))),
              From_int_Type (SOAP.Types.V (SOAP.Types.XSD_Integer (two))),
              From_double_Type (SOAP.Types.V (SOAP.Types.XSD_Double (three))),
              From_string_Type (SOAP.Types.V (SOAP.Types.XSD_String (four))),
              +To_ArrayOfName_Type (SOAP.Types.V (SOAP.Types.SOAP_Array (five))),
              From_string_Type (SOAP.Types.V (SOAP.Types.XSD_String (six))),
              From_string_Type (SOAP.Types.V (SOAP.Types.XSD_String (seven))),
              From_string_Type (SOAP.Types.V (SOAP.Types.XSD_String (eight))));
   exception
      when Constraint_Error =>
         if id'Tag /= SOAP.Types.XSD_Integer'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".id expected SOAP.Types.XSD_Integer, "
                  & "found " & External_Tag (id'Tag);
         end if;
         if one'Tag /= SOAP.Types.XSD_Integer'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".one expected SOAP.Types.XSD_Integer, "
                  & "found " & External_Tag (one'Tag);
         end if;
         if two'Tag /= SOAP.Types.XSD_Integer'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".two expected SOAP.Types.XSD_Integer, "
                  & "found " & External_Tag (two'Tag);
         end if;
         if three'Tag /= SOAP.Types.XSD_Double'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".three expected SOAP.Types.XSD_Double, "
                  & "found " & External_Tag (three'Tag);
         end if;
         if four'Tag /= SOAP.Types.XSD_String'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".four expected SOAP.Types.XSD_String, "
                  & "found " & External_Tag (four'Tag);
         end if;
         if five'Tag /= SOAP.Types.SOAP_Array'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".five expected SOAP.Types.SOAP_Array, "
                  & "found " & External_Tag (five'Tag);
         end if;
         if six'Tag /= SOAP.Types.XSD_String'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".six expected SOAP.Types.XSD_String, "
                  & "found " & External_Tag (six'Tag);
         end if;
         if seven'Tag /= SOAP.Types.XSD_String'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".seven expected SOAP.Types.XSD_String, "
                  & "found " & External_Tag (seven'Tag);
         end if;
         if eight'Tag /= SOAP.Types.XSD_String'Tag then
            raise SOAP.SOAP_Error
               with SOAP.Types.Name (R)
                  & ".eight expected SOAP.Types.XSD_String, "
                  & "found " & External_Tag (eight'Tag);
         end if;
         raise SOAP.SOAP_Error
            with "Record " & SOAP.Types.Name (R) & " not well formed";
   end To_big_Type;

   function To_SOAP_Object
     (R         : big_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Record
   is
      Result : SOAP.Types.SOAP_Record;
   begin
      Result := SOAP.Types.R
        ((+SOAP.Types.I (R.id, "id", "xs:int", NS => NS),
          +SOAP.Types.I (To_int_Type (To_tns_NonNegativeInt_Type (R.one)), "one", "tns:PercentCompleteInteger", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP.Types.I (To_int_Type (R.two), "two", "tns:NonNegativeInt", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP.Types.D (To_double_Type (R.three), "three", "tns:NonNegativeFloat", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP.Types.S (To_string_Type (R.four), "four", "tns:Name", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP_Array'(SOAP.Types.A (To_Object_Set (R.five.Item.all, NS => www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space), "five", "", NS => www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space)),
          +SOAP.Types.S (To_string_Type (R.six), "six", "tns:Address", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP.Types.S (To_string_Type (R.seven), "seven", "tns:Code1", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space),
          +SOAP.Types.S (To_string_Type (R.eight), "eight", "tns:Code2", www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space)),
         Name, Q_Type_Name, NS => NS);
      return Result;
   end To_SOAP_Object;

end www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg;
