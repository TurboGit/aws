--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

pragma Warnings (Off);
pragma Style_Checks (Off);

with Ada.Tags;

package body OccursServices.Types is

   use Ada.Tags;
   use SOAP.Types;

begin
   Schema.Insert ("http://www.w3.org/2001/XMLSchema", "s");
   Schema.Insert ("http://www.w3.org/2001/XMLSchema-instance", "xsi");
   Schema.Insert ("http://schemas.xmlsoap.org/soap/envelope/", "soapenv");
   Schema.Insert ("http://schemas.xmlsoap.org/soap/encoding/", "soapenc");
   Schema.Insert ("http", "http://schemas.xmlsoap.org/wsdl/http/");
   Schema.Insert ("http@qualified", "FALSE");
   Schema.Insert ("http://81.67.51.47/HECATEEWebServices/", "tns");
   Schema.Insert ("http://81.67.51.47/HECATEEWebServices/@qualified", "FALSE");
   Schema.Insert ("http://81.67.51.47/HECATEEWebServices/encodedTypes", "s0");
   Schema.Insert ("http://81.67.51.47/HECATEEWebServices/encodedTypes@qualified", "FALSE");
   Schema.Insert ("http://microsoft.com/wsdl/mime/textMatching/", "tm");
   Schema.Insert ("http://microsoft.com/wsdl/mime/textMatching/@qualified", "FALSE");
   Schema.Insert ("http://schemas.xmlsoap.org/soap/encoding/@qualified", "FALSE");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/http/", "http");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/http/@qualified", "FALSE");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/mime/", "mime");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/mime/@qualified", "FALSE");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/soap/", "soap");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/soap/@qualified", "FALSE");
   Schema.Insert ("http://www.w3.org/2001/XMLSchema@qualified", "FALSE");
   Schema.Insert ("mime", "http://schemas.xmlsoap.org/wsdl/mime/");
   Schema.Insert ("mime@qualified", "FALSE");
   Schema.Insert ("s", "http://www.w3.org/2001/XMLSchema");
   Schema.Insert ("s@qualified", "FALSE");
   Schema.Insert ("s0", "http://81.67.51.47/HECATEEWebServices/encodedTypes");
   Schema.Insert ("s0@qualified", "FALSE");
   Schema.Insert ("soap", "http://schemas.xmlsoap.org/wsdl/soap/");
   Schema.Insert ("soap@qualified", "FALSE");
   Schema.Insert ("soapenc", "http://schemas.xmlsoap.org/soap/encoding/");
   Schema.Insert ("soapenc@qualified", "FALSE");
   Schema.Insert ("tm", "http://microsoft.com/wsdl/mime/textMatching/");
   Schema.Insert ("tm@qualified", "FALSE");
   Schema.Insert ("tns", "http://81.67.51.47/HECATEEWebServices/");
   Schema.Insert ("tns@qualified", "FALSE");
   Schema.Insert ("@displayTrack.encoding", "ENCODED");
   Schema.Insert ("@displayTrackResponse.encoding", "ENCODED");
   Schema.Insert ("@:", "displayTrack");
   Schema.Insert ("", "displayTrack");
   Schema.Insert ("displayTrack.pa_track@is_a", "@record");
   Schema.Insert ("displayTrack.pa_track.p_battleDimension@is_a", "s0:T_Battle_Dimension");
   Schema.Insert ("displayTrack.pa_track.p_battleDimension@is_ref", "FALSE");
   Schema.Insert ("displayTrack.pa_track.p_tag", "s:string");
   Schema.Insert ("displayTrack.pa_track.p_tag@is_a", "s:string");
   Schema.Insert ("displayTrack.pa_track.p_tag@is_ref", "FALSE");
   Schema.Insert ("displayTrack.values@is_a", "@array");
   Schema.Insert ("@binding.style", "RPC");
   Schema.Insert ("T_Track", "s0:T_Track");
   Schema.Insert ("s0:T_Battle_Dimension", "@enum");
end OccursServices.Types;
