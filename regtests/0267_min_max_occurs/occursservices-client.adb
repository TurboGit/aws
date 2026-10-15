--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Exceptions;

with SOAP.Client;
with SOAP.Message.Payload;
with SOAP.Message.Response;
with SOAP.Message.XML;
with SOAP.Name_Space;
with SOAP.Parameters;
with SOAP.Utils;



package body OccursServices.Client is

   use Ada.Exceptions;

   use SOAP.Types;
   use SOAP.Parameters;


   --
   -- displayTrack
   --

   procedure displayTrack
     (Connection : AWS.Client.HTTP_Connection;
      pa_track : s0_T_Track_Type;
      values   : s0_ArrayOfFloat_Type)
   is
      P_Set   : SOAP.Parameters.List;
      Payload : SOAP.Message.Payload.Object;
   begin
      --  Set Parameters
      P_Set := P_Set
        & To_SOAP_Object (pa_track, "pa_track");
      P_Set := P_Set
        & To_SOAP_Object (values, "values");

      Payload := SOAP.Message.Payload.Build
                   ("displayTrack",
                    P_Set,
                    SOAP.Name_Space.Create ("tns", "http://81.67.51.47/HECATEEWebServices/"));

      declare
         Response : constant SOAP.Message.Response.Object'Class :=
                      SOAP.Client.Call
                        (Connection, "displayTrack",
                         Payload, Schema => Schema);
         R_Param  : constant SOAP.Parameters.List :=
                      SOAP.Message.Parameters (Response);
      begin
         if SOAP.Message.Response.Is_Error (Response) then
            raise SOAP.SOAP_Error with
               SOAP.Parameters.Get (R_Param, "faultstring");
         end if;
      end;
   end displayTrack;

   procedure displayTrack
     (pa_track : s0_T_Track_Type;
      values   : s0_ArrayOfFloat_Type;
      Endpoint : String := OccursServices.URL;
      Timeouts : AWS.Client.Timeouts_Values := OccursServices.Timeouts)
   is
      Connection : AWS.Client.HTTP_Connection;
   begin
      AWS.Client.Create
        (Connection, Endpoint,
         Persistent => False,
         Timeouts   => Timeouts);
      Client.displayTrack (Connection, pa_track, values);
      AWS.Client.Close (Connection);
   exception
      when others =>
         AWS.Client.Close (Connection);
         raise;
   end displayTrack;

end OccursServices.Client;
