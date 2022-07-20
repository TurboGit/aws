
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with www.w3.org.n2001.XMLSchema;
use www.w3.org.n2001.XMLSchema;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg;

with Ada.Calendar;
with Ada.Strings.Unbounded;

with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

package www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg is

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

   Q_Type_Name : constant String := "tns:big";

   type big_Type is record
      id    : Integer;
      one   : tns_PercentCompleteInteger_Type;
      two   : tns_NonNegativeInt_Type;
      three : tns_NonNegativeFloat_Type;
      four  : tns_Name_Type;
      five  : ArrayOfName_Type_Safe_Access;
      --  Access items with : result.Item (n)
      six   : tns_Address_Type;
      seven : tns_Code1_Type;
      eight : tns_Code2_Type;
   end record;

   function To_big_Type
     (O : SOAP.Types.Object'Class)
      return big_Type;

   function To_SOAP_Object
     (R         : big_Type;
      Name      : String := "item";
      Type_Name : String := Q_Type_Name;
      NS        : SOAP.Name_Space.Object := Name_Space)
      return SOAP.Types.SOAP_Record;

end www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg;
