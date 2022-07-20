
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

pragma Warnings (Off);

with Ada.Calendar;
with System.Assertions;

with AWS.Status;
pragma Elaborate_All (AWS.Status);
with AWS.Response;
pragma Elaborate_All (AWS.Response);

with SOAP.Message.Payload;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Message);
pragma Elaborate_All (SOAP.Message.Payload);
with SOAP.Types;
pragma Elaborate_All (SOAP.Types);

with Deriveconst_Demo.Types;
pragma Elaborate_All (Deriveconst_Demo.Types);


package Deriveconst_Demo.Server is

   use Deriveconst_Demo.Types;

   Port : constant := 9111;

   generic
      with procedure call
        (params   : big_Type);
   function call_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data;

   generic
      with procedure call2
        (params2  : tns_MByte_Type);
   function call2_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data;

end Deriveconst_Demo.Server;
