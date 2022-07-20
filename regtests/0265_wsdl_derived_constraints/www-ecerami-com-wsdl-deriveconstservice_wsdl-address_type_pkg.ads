
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with www.w3.org.n2001.XMLSchema;
use www.w3.org.n2001.XMLSchema;


with Ada.Calendar;
with Ada.Strings.Unbounded;

with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

package www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg is

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

   Q_Type_Name : constant String := "tns:Address";

   type tns_Address_Type is new Unbounded_String
     with Dynamic_Predicate => 
       Length (Unbounded_String (tns_Address_Type)) >= 5
       and then Length (Unbounded_String (tns_Address_Type)) <= 8;

   function To_string_Type
     (D : tns_Address_Type)
      return Unbounded_String is
       (Unbounded_String (D));

   function From_string_Type
     (D : Unbounded_String)
      return tns_Address_Type is
       (tns_Address_Type (D));

   function To_tns_Address_Type
     (D : Unbounded_String)
      return tns_Address_Type renames From_string_Type;

   function To_tns_Address_Type
     (O : SOAP.Types.Object'Class)
      return tns_Address_Type is
       (From_string_Type (SOAP.Types.V (SOAP.Types.XSD_String (O))));

   function To_SOAP_Object
     (D         : tns_Address_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.XSD_String is
        (SOAP.Types.S (To_string_Type (D), Name, Type_Name, NS));

end www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg;
