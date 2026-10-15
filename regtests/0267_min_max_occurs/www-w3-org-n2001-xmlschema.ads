--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with SOAP.Name_Space;

package www.w3.org.n2001.XMLSchema is
   Name_Space        : constant SOAP.Name_Space.Object :=
                         SOAP.Name_Space.Create
                           ("s", "http://www.w3.org/2001/XMLSchema");
   Qualified_Element : constant Boolean := False;
end www.w3.org.n2001.XMLSchema;
