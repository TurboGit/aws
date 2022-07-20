
--  wsdl2aws SOAP Generator v4.1.0
--
--  AWS 2021 - SOAP 3.0.0
--  This file was generated on Wednesday 20 July 2022 at 08:28:27
--
--  $ wsdl2aws -f -doc deriveconst.wsdl

with Ada.Tags;

package body Deriveconst_Demo.Types is

   use Ada.Tags;
   use SOAP.Types;

begin
   --  Definitions for SOAP name-spaces
   Schema.Insert ("http://www.w3.org/2001/XMLSchema", "xs");
   Schema.Insert ("http://www.w3.org/2001/XMLSchema-instance", "xsi");
   Schema.Insert ("http://schemas.xmlsoap.org/soap/envelope/", "soapenv");
   Schema.Insert ("http://schemas.xmlsoap.org/soap/encoding/", "soapenc");

   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/", "wsdl");
   Schema.Insert ("http://schemas.xmlsoap.org/wsdl/soap/", "soap");
   Schema.Insert ("http://www.ecerami.com/wsdl/DeriveconstService.wsdl", "tns");
   Schema.Insert ("ns1", "urn:examples:deriveconstservice");
   Schema.Insert ("soap", "http://schemas.xmlsoap.org/wsdl/soap/");
   Schema.Insert ("soapenc", "http://schemas.xmlsoap.org/soap/encoding/");
   Schema.Insert ("tns", "http://www.ecerami.com/wsdl/DeriveconstService.wsdl");
   Schema.Insert ("urn:examples:deriveconstservice", "ns1");
   Schema.Insert ("wsdl", "http://schemas.xmlsoap.org/wsdl/");
   Schema.Insert ("xs", "http://www.w3.org/2001/XMLSchema");

   --  Definitions for procedure call
   Schema.Insert ("@call.encoding", "ENCODED");
   Schema.Insert ("@callResponse.encoding", "ENCODED");
   Schema.Insert ("@", "call");
   Schema.Insert ("", "call");
   Schema.Insert ("call.params@is_a", "@record");
   Schema.Insert ("call.params.id@is_a", "xs:int");
   Schema.Insert ("call.params.one@is_a", "tns:PercentCompleteInteger");
   Schema.Insert ("call.params.two@is_a", "tns:NonNegativeInt");
   Schema.Insert ("call.params.three@is_a", "tns:NonNegativeFloat");
   Schema.Insert ("call.params.four@is_a", "tns:Name");
   Schema.Insert ("call.params.five@is_a", "@array");
   Schema.Insert ("call.params.five.item", "Name");
   Schema.Insert ("call.params.five.item@is_a", "tns:Name");
   Schema.Insert ("call.params.six@is_a", "tns:Address");
   Schema.Insert ("call.params.seven@is_a", "tns:Code1");
   Schema.Insert ("call.params.eight@is_a", "tns:Code2");

   --  Definitions for procedure call2
   Schema.Insert ("@call2.encoding", "ENCODED");
   Schema.Insert ("@call2Response.encoding", "ENCODED");
   Schema.Insert ("call2.params2@is_a", "tns:MByte");

   Schema.Insert ("@binding.style", "RPC");

   --  Definitions for derived types
   Schema.Insert ("big", "tns:big");
   Schema.Insert ("tns:Address", "xs:string");
   Schema.Insert ("tns:Code1", "xs:string");
   Schema.Insert ("tns:Code2", "xs:string");
   Schema.Insert ("tns:MByte", "xs:unsignedByte");
   Schema.Insert ("tns:Name", "xs:string");
   Schema.Insert ("tns:NonNegativeFloat", "xs:double");
   Schema.Insert ("tns:NonNegativeInt", "xs:int");
   Schema.Insert ("tns:PercentCompleteInteger", "xs:int");
end Deriveconst_Demo.Types;
