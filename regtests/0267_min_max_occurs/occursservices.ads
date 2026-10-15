--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with AWS.Client;
with SOAP.WSDL.Schema;

--  A track display tool

package OccursServices is

   URL      : constant String := "http://81.67.51.47/HECATEEWebSErvices/HECATEEWebServices.asmx";

   Timeouts : constant AWS.Client.Timeouts_Values :=
                AWS.Client.No_Timeout;

   Schema   : SOAP.WSDL.Schema.Definition;


end OccursServices;
