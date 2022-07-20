
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:27
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg;

with www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg;
pragma Elaborate_All (www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg);
use www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg;

with Ada.Calendar;
with Ada.Strings.Unbounded;

with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

with GNAT.Regexp;
pragma Elaborate_All (GNAT.Regexp);

package Deriveconst_Demo.Types is

   pragma Elaborate_Body;
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

   subtype tns_NonNegativeInt_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg.tns_NonNegativeInt_Type;

   function To_int_Type
     (D : tns_NonNegativeInt_Type)
      return Integer
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg.To_int_Type;
   function From_int_Type
     (D : Integer)
      return tns_NonNegativeInt_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg.From_int_Type;

   function To_tns_NonNegativeInt_Type
     (D : Integer)
      return tns_NonNegativeInt_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg.From_int_Type;
   function To_NonNegativeInt_Type
     (D : Integer)
      return tns_NonNegativeInt_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeInt_Type_Pkg.From_int_Type;

   subtype tns_PercentCompleteInteger_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg.tns_PercentCompleteInteger_Type;
   function To_tns_NonNegativeInt_Type (D : tns_PercentCompleteInteger_Type)
     return tns_NonNegativeInt_Type
     renames www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg.To_tns_NonNegativeInt_Type;
   function From_tns_NonNegativeInt_Type (D : tns_NonNegativeInt_Type)
     return tns_PercentCompleteInteger_Type
     renames www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg.From_tns_NonNegativeInt_Type;

   function To_tns_PercentCompleteInteger_Type
     (D : tns_NonNegativeInt_Type)
      return tns_PercentCompleteInteger_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.PercentCompleteInteger_Type_Pkg.From_tns_NonNegativeInt_Type;

   subtype tns_NonNegativeFloat_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg.tns_NonNegativeFloat_Type;

   function To_double_Type
     (D : tns_NonNegativeFloat_Type)
      return Long_Float
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg.To_double_Type;
   function From_double_Type
     (D : Long_Float)
      return tns_NonNegativeFloat_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg.From_double_Type;

   function To_tns_NonNegativeFloat_Type
     (D : Long_Float)
      return tns_NonNegativeFloat_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg.From_double_Type;
   function To_NonNegativeFloat_Type
     (D : Long_Float)
      return tns_NonNegativeFloat_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.NonNegativeFloat_Type_Pkg.From_double_Type;

   subtype tns_Name_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg.tns_Name_Type;

   function To_string_Type
     (D : tns_Name_Type)
      return String
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg.To_string_Type;
   function From_string_Type
     (D : String)
      return tns_Name_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg.From_string_Type;

   function To_tns_Name_Type
     (D : String)
      return tns_Name_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg.From_string_Type;
   function To_Name_Type
     (D : String)
      return tns_Name_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Type_Pkg.From_string_Type;

   ----------------------------
   -- Array ArrayOfName_Type --
   ----------------------------

   subtype ArrayOfName_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.ArrayOfName_Type;

   function "+"
     (O : www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.ArrayOfName_Type)
      return www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.ArrayOfName_Type_Safe_Access
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.ArrayOfName_Type_Safe_Pointer.To_Safe_Pointer;
   --  Convert an array to a safe pointer

   function To_ArrayOfName_Type
     (From : SOAP.Types.Object_Set)
      return ArrayOfName_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.To_ArrayOfName_Type;

   function To_Object_Set
     (From : ArrayOfName_Type;
      NS   : SOAP.Name_Space.Object :=
               SOAP.Name_Space.No_Name_Space)
      return SOAP.Types.Object_Set
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.ArrayOfName_Type_Pkg.To_Object_Set;

   subtype tns_Address_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg.tns_Address_Type;

   function To_string_Type
     (D : tns_Address_Type)
      return Unbounded_String
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg.To_string_Type;
   function From_string_Type
     (D : Unbounded_String)
      return tns_Address_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg.From_string_Type;

   function To_tns_Address_Type
     (D : Unbounded_String)
      return tns_Address_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg.From_string_Type;
   function To_Address_Type
     (D : Unbounded_String)
      return tns_Address_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Address_Type_Pkg.From_string_Type;

   subtype tns_Code1_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg.tns_Code1_Type;

   function To_string_Type
     (D : tns_Code1_Type)
      return Unbounded_String
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg.To_string_Type;
   function From_string_Type
     (D : Unbounded_String)
      return tns_Code1_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg.From_string_Type;

   function To_tns_Code1_Type
     (D : Unbounded_String)
      return tns_Code1_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg.From_string_Type;
   function To_Code1_Type
     (D : Unbounded_String)
      return tns_Code1_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code1_Type_Pkg.From_string_Type;

   subtype tns_Code2_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg.tns_Code2_Type;

   function To_string_Type
     (D : tns_Code2_Type)
      return String
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg.To_string_Type;
   function From_string_Type
     (D : String)
      return tns_Code2_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg.From_string_Type;

   function To_tns_Code2_Type
     (D : String)
      return tns_Code2_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg.From_string_Type;
   function To_Code2_Type
     (D : String)
      return tns_Code2_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Code2_Type_Pkg.From_string_Type;

   ---------------------
   -- Record big_Type --
   ---------------------

   subtype big_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg.big_Type;

   function To_big_Type
     (O : SOAP.Types.Object'Class)
      return big_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg.To_big_Type;

   tns_Name_Space : SOAP.Name_Space.Object 
     renames www.ecerami.com.wsdl.DeriveconstService_wsdl.Name_Space;

   function To_SOAP_Object
     (R         : big_Type;
      Name      : String := "item";
      Type_Name : String := www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg.Q_Type_Name;
      NS        : SOAP.Name_Space.Object := tns_Name_Space)
      return SOAP.Types.SOAP_Record
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.big_Type_Pkg.To_SOAP_Object;

   subtype tns_MByte_Type
     is www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg.tns_MByte_Type;

   function To_unsignedByte_Type
     (D : tns_MByte_Type)
      return SOAP.Types.Unsigned_Byte
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg.To_unsignedByte_Type;
   function From_unsignedByte_Type
     (D : SOAP.Types.Unsigned_Byte)
      return tns_MByte_Type
      renames www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg.From_unsignedByte_Type;

   function To_tns_MByte_Type
     (D : SOAP.Types.Unsigned_Byte)
      return tns_MByte_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg.From_unsignedByte_Type;
   function To_MByte_Type
     (D : SOAP.Types.Unsigned_Byte)
      return tns_MByte_Type renames www.ecerami.com.wsdl.DeriveconstService_wsdl.MByte_Type_Pkg.From_unsignedByte_Type;

end Deriveconst_Demo.Types;
