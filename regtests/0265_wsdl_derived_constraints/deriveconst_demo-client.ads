
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

pragma Warnings (Off);

with Ada.Calendar;

with SOAP.Types;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Types);

with Deriveconst_Demo.Types;


package Deriveconst_Demo.Client is

   use Deriveconst_Demo.Types;

   Connection : constant AWS.Client.HTTP_Connection;

   procedure call
     (params   : big_Type;
      Endpoint : String := Deriveconst_Demo.URL;
      Timeouts : AWS.Client.Timeouts_Values := Deriveconst_Demo.Timeouts);
   procedure call
     (Connection : AWS.Client.HTTP_Connection;
      params     : big_Type);
   --  Raises SOAP.SOAP_Error if the procedure fails

   procedure call2
     (params2  : tns_MByte_Type;
      Endpoint : String := Deriveconst_Demo.URL;
      Timeouts : AWS.Client.Timeouts_Values := Deriveconst_Demo.Timeouts);
   procedure call2
     (Connection : AWS.Client.HTTP_Connection;
      params2    : tns_MByte_Type);
   --  Raises SOAP.SOAP_Error if the procedure fails

private

   Connection : constant AWS.Client.HTTP_Connection :=
                  AWS.Client.Create
                    (URL,
                     Timeouts   => Timeouts);

end Deriveconst_Demo.Client;
