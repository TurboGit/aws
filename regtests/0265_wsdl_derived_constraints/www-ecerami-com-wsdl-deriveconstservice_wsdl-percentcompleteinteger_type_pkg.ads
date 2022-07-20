
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;


with Ada.Calendar;
with Ada.Strings.Unbounded;

with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

package www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg is

   pragma Warnings (Off, Ada.Calendar);
   pragma Warnings (Off, Ada.Strings.Unbounded);
   pragma Warnings (Off, SOAP.Types);
   pragma Warnings (Off, SOAP.Utils);
   pragma Warnings (Off, GNAT.Regexp);

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

   Q_Type_Name : constant String := "tns:PercentCompleteInteger";

   type tns_PercentCompleteInteger_Type is new tns_NonNegativeInt_Type
     range 0 .. 100;

   function To_tns_NonNegativeInt_Type
     (D : tns_PercentCompleteInteger_Type)
      return tns_NonNegativeInt_Type is
       (tns_NonNegativeInt_Type (D));

   function From_tns_NonNegativeInt_Type
     (D : tns_NonNegativeInt_Type)
      return tns_PercentCompleteInteger_Type is
       (tns_PercentCompleteInteger_Type (D));

   function To_tns_PercentCompleteInteger_Type
     (D : tns_NonNegativeInt_Type)
      return tns_PercentCompleteInteger_Type renames From_tns_NonNegativeInt_Type;

   function To_tns_PercentCompleteInteger_Type
     (O : SOAP.Types.Object'Class)
      return tns_PercentCompleteInteger_Type is
       (From_tns_NonNegativeInt_Type (From_int_Type (SOAP.Types.V (SOAP.Types.XSD_Integer (O)))));

   function To_SOAP_Object
     (D         : tns_PercentCompleteInteger_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.XSD_Integer is
        (SOAP.Types.I (To_int_Type (To_tns_NonNegativeInt_Type (D)), Name, Type_Name, NS));

end www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg;
