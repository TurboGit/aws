--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Ada_2022;
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Calendar;
with System.Assertions;
with AWS.Status;
with AWS.Response;
with SOAP.Message.Payload;
with SOAP.Types;

with OccursServices.Types;


package OccursServices.Server is

   use OccursServices.Types;

   Port : constant := 80;

   generic
      with procedure displayTrack
        (pa_track : s0_T_Track_Type;
         values   : s0_ArrayOfFloat_Type)
         ;
   function displayTrack_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data;


end OccursServices.Server;
