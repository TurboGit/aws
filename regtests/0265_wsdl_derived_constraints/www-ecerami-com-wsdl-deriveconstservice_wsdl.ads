
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
package www.ecerami.com.wsdl.DeriveconstService_wsdl is
   pragma Style_Checks (Off);
   Name_Space : constant SOAP.Name_Space.Object :=
                  SOAP.Name_Space.Create ("tns", "http://www.ecerami.com/wsdl/DeriveconstService.wsdl");
end www.ecerami.com.wsdl.DeriveconstService_wsdl;
