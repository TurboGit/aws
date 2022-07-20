
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
package www.w3.org.n2001.XMLSchema is
   pragma Style_Checks (Off);
   Name_Space : constant SOAP.Name_Space.Object :=
                  SOAP.Name_Space.Create ("xs", "http://www.w3.org/2001/XMLSchema");
end www.w3.org.n2001.XMLSchema;
