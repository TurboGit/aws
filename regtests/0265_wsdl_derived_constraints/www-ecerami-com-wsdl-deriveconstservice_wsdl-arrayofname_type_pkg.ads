
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;

with Ada.Calendar;
with Ada.Strings.Unbounded;

with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

package www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg is

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

   Q_Type_Name : constant String := "tns:ArrayOfName";

   type ArrayOfName_Type is array (Positive range <>) of tns_Name_Type;
   type ArrayOfName_Type_Access is access all ArrayOfName_Type;

   package ArrayOfName_Type_Safe_Pointer is
      new SOAP.Utils.Safe_Pointers
            (ArrayOfName_Type, ArrayOfName_Type_Access);

   subtype ArrayOfName_Type_Safe_Access
      is ArrayOfName_Type_Safe_Pointer.Safe_Pointer;

   function "+"
     (O : ArrayOfName_Type)
      return ArrayOfName_Type_Safe_Access
      renames ArrayOfName_Type_Safe_Pointer.To_Safe_Pointer;
   --  Convert an array to a safe pointer

   function To_ArrayOfName_Type is new SOAP.Utils.To_T_Array
     (tns_Name_Type, ArrayOfName_Type, To_tns_Name_Type);

   function To_Object_Set is new SOAP.Utils.To_Object_Set
     (tns_Name_Type, ArrayOfName_Type,
      SOAP.Types.XSD_String, "item", "tns:Name", To_SOAP_Object);

end www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg;
