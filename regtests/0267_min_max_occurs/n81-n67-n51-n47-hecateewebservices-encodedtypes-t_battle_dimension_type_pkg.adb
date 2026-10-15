--  wsdl2aws SOAP Generator v6.1.0
--
--  AWS 20.0 - SOAP 3.0.0
--  This file was generated on 2026-10-15 07:45:41
--
--  $ wsdl2aws -f -doc occurs.wsdl

package body n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg is

   --
   -- Image
   --

   function Image (E : T_Battle_Dimension_Type) return String is
   begin
      case E is
         when SPACE          => return "SPACE";
         when AIR            => return "AIR";
         when GROUND         => return "GROUND";
         when SEA_SURFACE    => return "SEA_SURFACE";
         when SEA_SUBSURFACE => return "SEA_SUBSURFACE";
         when SOF            => return "SOF";
      end case;
   end Image;

   --
   -- Value
   --

   function Value (S : String) return T_Battle_Dimension_Type is
   begin
      if S = "SPACE" then
         return SPACE;
      end if;
      if S = "AIR" then
         return AIR;
      end if;
      if S = "GROUND" then
         return GROUND;
      end if;
      if S = "SEA_SURFACE" then
         return SEA_SURFACE;
      end if;
      if S = "SEA_SUBSURFACE" then
         return SEA_SUBSURFACE;
      end if;
      if S = "SOF" then
         return SOF;
      end if;

      raise Constraint_Error
        with "T_Battle_Dimension_Type: enum value " & S & " unknown.";
   end Value;

end n81.n67.n51.n47.HECATEEWebServices.encodedTypes.T_Battle_Dimension_Type_Pkg;
