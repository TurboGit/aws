
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:28
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with Ada.Exceptions;

with SOAP.Message.Response.Error;
pragma Elaborate_All (SOAP);
pragma Elaborate_All (SOAP.Message);
pragma Elaborate_All (SOAP.Message.Response);
pragma Elaborate_All (SOAP.Message.Response.Error);
with SOAP.Name_Space;
pragma Elaborate_All (SOAP.Name_Space);
with SOAP.Parameters;
pragma Elaborate_All (SOAP.Parameters);
with SOAP.Utils;
pragma Elaborate_All (SOAP.Utils);

package body Deriveconst_Demo.Server is

   use Ada.Exceptions;

   use SOAP.Types;
   use type SOAP.Parameters.List;

   pragma Style_Checks (Off);

   -------------
   -- call_CB --
   -------------

   function call_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data
   is
      Proc_Name : constant String
        := SOAP.Message.Payload.Procedure_Name (Payload);
      Params    : constant SOAP.Parameters.List
        := SOAP.Message.Parameters (Payload);
      Response  : SOAP.Message.Response.Object;
      R_Params  : SOAP.Parameters.List;
   begin
      if SOAPAction /= "call" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "SOAPAction " & SOAPAction & " in call, "
                 & "call expected."));
      end if;

      if Proc_Name /= "call" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Found procedure " & Proc_Name & " in call, "
                 & "call expected."));
      end if;

      Response := SOAP.Message.Response.From (Payload);

      declare
         params_big_Record : constant SOAP.Types.SOAP_Record
           := SOAP.Parameters.Get (Params, "params");
         params : constant big_Type
           := To_big_Type (params_big_Record);
      begin
         call                (params);
      exception
         when E : others =>
            --  Here we have a problem with user's callback, return a SOAP error
            return SOAP.Message.Response.Build
              (SOAP.Message.Response.Error.Build
                 (SOAP.Message.Response.Error.Client,
                  "Error in call ("
                    & Exception_Message (E) & ")"));
      end;

      SOAP.Message.Set_Parameters (Response, R_Params);
      return SOAP.Message.Response.Build (Response, Schema);
   exception
      when E : others =>
         --  Here we have a problem with some parameters, return a SOAP error
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Parameter error in call ("
                 & Exception_Message (E) & ")"));
   end call_CB;

   --------------
   -- call2_CB --
   --------------

   function call2_CB
     (SOAPAction : String;
      Payload    : SOAP.Message.Payload.Object;
      Request    : AWS.Status.Data)
      return AWS.Response.Data
   is
      Proc_Name : constant String
        := SOAP.Message.Payload.Procedure_Name (Payload);
      Params    : constant SOAP.Parameters.List
        := SOAP.Message.Parameters (Payload);
      Response  : SOAP.Message.Response.Object;
      R_Params  : SOAP.Parameters.List;
   begin
      if SOAPAction /= "call2" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "SOAPAction " & SOAPAction & " in call2, "
                 & "call2 expected."));
      end if;

      if Proc_Name /= "call2" then
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Found procedure " & Proc_Name & " in call2, "
                 & "call2 expected."));
      end if;

      Response := SOAP.Message.Response.From (Payload);

      declare
         params2 : constant tns_MByte_Type
           := From_unsignedByte_Type (SOAP.Parameters.Get (Params, "params2"));
      begin
         call2                (params2);
      exception
         when E : others =>
            --  Here we have a problem with user's callback, return a SOAP error
            return SOAP.Message.Response.Build
              (SOAP.Message.Response.Error.Build
                 (SOAP.Message.Response.Error.Client,
                  "Error in call2 ("
                    & Exception_Message (E) & ")"));
      end;

      SOAP.Message.Set_Parameters (Response, R_Params);
      return SOAP.Message.Response.Build (Response, Schema);
   exception
      when E : others =>
         --  Here we have a problem with some parameters, return a SOAP error
         return SOAP.Message.Response.Build
           (SOAP.Message.Response.Error.Build
              (SOAP.Message.Response.Error.Client,
               "Parameter error in call2 ("
                 & Exception_Message (E) & ")"));
   end call2_CB;

end Deriveconst_Demo.Server;
