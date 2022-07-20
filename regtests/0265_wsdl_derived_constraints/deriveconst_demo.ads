
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:27
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

--  WSDL File for Deriveconst Demo

with AWS.Client;
pragma Elaborate_All (AWS.Client);
with SOAP.WSDL.Schema;
pragma Elaborate_All (SOAP.WSDL.Schema);

package Deriveconst_Demo is

   URL      : constant String := "http://localhost:9111/deriveconst";
   Timeouts : constant AWS.Client.Timeouts_Values :=
                AWS.Client.No_Timeout;

   Schema   : SOAP.WSDL.Schema.Definition;

end Deriveconst_Demo;
