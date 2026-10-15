--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl
--
pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Exceptions;
with Ada.Strings.Unbounded;
with SOAP.Message.Response.Error;
with SOAP.Name_Space;
with SOAP.Parameters;
with SOAP.Utils;


package body OccursServices.Server is

   use Ada.Exceptions;
   use Ada.Strings.Unbounded;
   use SOAP.Types;
   use SOAP.Parameters;



   --
   -- displayTrack_CB
   --

   function displayTrack_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data
   is
      Proc_Name : constant String :=
                    SOAP.Message.Payload.Procedure_Name (Payload);
      Params    : constant SOAP.Parameters.List :=
                    SOAP.Message.Parameters (Payload);
      Response  : SOAP.Message.Response.Object;
      R_Params  : SOAP.Parameters.List;
   begin
      if SOAPAction /= "displayTrack" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "SOAPAction " & SOAPAction & " in displayTrack, "
               & "displayTrack expected."));
      end if;

      if Proc_Name /= "displayTrack" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Found procedure " & Proc_Name & " in displayTrack_CB, "
               & "displayTrack expected."));
      end if;

      Response := SOAP.Message.Response.From (Payload);

      declare
         pa_track_T_Track_Record : constant SOAP.Types.SOAP_Record :=
            SOAP.Parameters.Get (Params, "pa_track");
         values_ArrayOfFloat_Array : constant SOAP.Types.SOAP_Array :=
            SOAP.Parameters.Get (Params, "values");
         --  Parameters:
         --  pa_track
         pa_track : constant s0_T_Track_Type :=
           To_T_Track_Type (pa_track_T_Track_Record);
         --  values
         values   : constant s0_ArrayOfFloat_Type :=
           To_ArrayOfFloat_Type (V (values_ArrayOfFloat_Array));
      begin
         displayTrack (pa_track, values);
      exception
         when E : others =>
            --  return a SOAP error
            return SOAP.Message.Response.Build
              (SOAP.Message.Response.Error.Build
                 (SOAP.Message.Response.Error.Client,
                  "Error in displayTrack (" & Exception_Message (E) & ")"));
      end;

      SOAP.Message.Set_Parameters (Response, R_Params);
      return SOAP.Message.Response.Build (Response, Schema);
   exception
      when E : others =>
         --  return a SOAP error
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Parameter error in displayTrack (" & Exception_Message (E) & ")"));
   end displayTrack_CB;

end OccursServices.Server;
