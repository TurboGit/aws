------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                            Copyright (C) 2003                            --
--                                ACT-Europe                                --
--                                                                          --
--  Authors: Dmitriy Anisimkov - Pascal Obry                                --
--                                                                          --
--  This library is free software; you can redistribute it and/or modify    --
--  it under the terms of the GNU General Public License as published by    --
--  the Free Software Foundation; either version 2 of the License, or (at   --
--  your option) any later version.                                         --
--                                                                          --
--  This library is distributed in the hope that it will be useful, but     --
--  WITHOUT ANY WARRANTY; without even the implied warranty of              --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       --
--  General Public License for more details.                                --
--                                                                          --
--  You should have received a copy of the GNU General Public License       --
--  along with this library; if not, write to the Free Software Foundation, --
--  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.          --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

--  $Id$

with System;
with Interfaces.C.Strings;

package body AWS.Net.SSL.Certificate is

   ---------
   -- Get --
   ---------

   function Get (Socket : in Socket_Type) return Object is
      use type System.Address;

      X509 : constant TSSL.X509 := TSSL.SSL_get_peer_certificate (Socket.SSL);
   begin
      if X509 = TSSL.Null_Pointer then
         return Undefined;

      else
         return
           (To_Unbounded_String
              (Interfaces.C.Strings.Value
                 (TSSL.X509_NAME_oneline (TSSL.X509_get_subject_name (X509)))),
            To_Unbounded_String
              (Interfaces.C.Strings.Value
                 (TSSL.X509_NAME_oneline (TSSL.X509_get_issuer_name (X509)))));
      end if;
   end Get;

   ------------
   -- Issuer --
   ------------

   function Issuer  (Certificate : in Object) return String is
   begin
      return To_String (Certificate.Issuer);
   end Issuer;

   -------------
   -- Subject --
   -------------

   function Subject (Certificate : in Object) return String is
   begin
      return To_String (Certificate.Subject);
   end Subject;

end AWS.Net.SSL.Certificate;
