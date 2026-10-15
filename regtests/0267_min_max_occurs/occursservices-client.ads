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
with SOAP.Types;

with OccursServices.Types;


package OccursServices.Client is

   use OccursServices.Types;

   Connection : constant AWS.Client.HTTP_Connection;

   procedure displayTrack
     (pa_track : s0_T_Track_Type;
      values   : s0_ArrayOfFloat_Type;
      Endpoint           : String := OccursServices.URL;
      Timeouts           : AWS.Client.Timeouts_Values := OccursServices.Timeouts)
    
   ;
   procedure displayTrack
     (Connection : AWS.Client.HTTP_Connection;
      pa_track : s0_T_Track_Type;
      values   : s0_ArrayOfFloat_Type)
    
   ;

   --  Raises SOAP.SOAP_Error if the procedure fails

private

   Connection : constant AWS.Client.HTTP_Connection :=
                  AWS.Client.Create
                    (URL,
                     Timeouts   => Timeouts);

end OccursServices.Client;
