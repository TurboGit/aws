
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

pragma Warnings (Off);

with SOAP.Client;
pragma Elaborate_All (SOAP.Client);
with SOAP.Message.Payload;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Message);
pragma Elaborate_All (SOAP.Message.Payload);
with SOAP.Message.Response;
pragma Elaborate_All (SOAP.Message.Response);
with SOAP.Message.XML;
pragma Elaborate_All (SOAP.Message.XML);
with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
with SOAP.Parameters;
pragma Elaborate_All (SOAP.Parameters);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

package body Deriveconst_Demo.Client is

   use SOAP.Types;
   use type SOAP.Parameters.List;

   pragma Style_Checks (Off);


   ----------
   -- call --
   ----------

   procedure call
     (Connection : AWS.Client.HTTP_Connection;
      params     : big_Type)
   is
      P_Set   : SOAP.Parameters.List;
      Payload : SOAP.Message.Payload.Object;
   begin
      --  Set parameters
      P_Set := +To_SOAP_Object (params, "params");
      Payload := SOAP.Message.Payload.Build
        ("call", P_Set,
         SOAP.Name_Space.Create ("ns1", "urn:examples:deriveconstservice"));

      declare
         Response : constant SOAP.Message.Response.Object'Class
           := SOAP.Client.Call
                (Connection, "call",
                 Payload, Schema => Schema);
         R_Param  : constant SOAP.Parameters.List
           := SOAP.Message.Parameters (Response);
      begin
         if SOAP.Message.Response.Is_Error (Response) then
            raise SOAP.SOAP_Error with
               SOAP.Parameters.Get (R_Param, "faultstring");
         end if;
      end;
   end call;

   procedure call
     (params   : big_Type;
      Endpoint : String := Deriveconst_Demo.URL;
      Timeouts : AWS.Client.Timeouts_Values := Deriveconst_Demo.Timeouts)
   is
      Connection : AWS.Client.HTTP_Connection;
   begin
      AWS.Client.Create
        (Connection, Endpoint,
         Persistent => False,
         Timeouts   => Timeouts);
      Client.call (Connection, params);
      AWS.Client.Close (Connection);
   exception
      when others =>
         AWS.Client.Close (Connection);
         raise;
   end call;

   -----------
   -- call2 --
   -----------

   procedure call2
     (Connection : AWS.Client.HTTP_Connection;
      params2    : tns_MByte_Type)
   is
      P_Set   : SOAP.Parameters.List;
      Payload : SOAP.Message.Payload.Object;
   begin
      --  Set parameters
      P_Set := +SOAP.Types.UB (To_unsignedByte_Type (params2), "params2", "tns:MByte", SOAP.Name_Space.Create ("tns", "http://www.ecerami.com/wsdl/DeriveconstService.wsdl"));
      Payload := SOAP.Message.Payload.Build
        ("call2", P_Set,
         SOAP.Name_Space.Create ("ns1", "urn:examples:deriveconstservice"));

      declare
         Response : constant SOAP.Message.Response.Object'Class
           := SOAP.Client.Call
                (Connection, "call2",
                 Payload, Schema => Schema);
         R_Param  : constant SOAP.Parameters.List
           := SOAP.Message.Parameters (Response);
      begin
         if SOAP.Message.Response.Is_Error (Response) then
            raise SOAP.SOAP_Error with
               SOAP.Parameters.Get (R_Param, "faultstring");
         end if;
      end;
   end call2;

   procedure call2
     (params2  : tns_MByte_Type;
      Endpoint : String := Deriveconst_Demo.URL;
      Timeouts : AWS.Client.Timeouts_Values := Deriveconst_Demo.Timeouts)
   is
      Connection : AWS.Client.HTTP_Connection;
   begin
      AWS.Client.Create
        (Connection, Endpoint,
         Persistent => False,
         Timeouts   => Timeouts);
      Client.call2 (Connection, params2);
      AWS.Client.Close (Connection);
   exception
      when others =>
         AWS.Client.Close (Connection);
         raise;
   end call2;

end Deriveconst_Demo.Client;
