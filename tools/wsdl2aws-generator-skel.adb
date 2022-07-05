------------------------------------------------------------------------------
--                              Ada Web Server                              --
--                                                                          --
--                     Copyright (C) 2003-2022, AdaCore                     --
--                                                                          --
--  This library is free software;  you can redistribute it and/or modify   --
--  it under terms of the  GNU General Public License  as published by the  --
--  Free Software  Foundation;  either version 3,  or (at your  option) any --
--  later version. This library is distributed in the hope that it will be  --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    --
--                                                                          --
--  As a special exception under Section 7 of GPL version 3, you are        --
--  granted additional permissions described in the GCC Runtime Library     --
--  Exception, version 3.1, as published by the Free Software Foundation.   --
--                                                                          --
--  You should have received a copy of the GNU General Public License and   --
--  a copy of the GCC Runtime Library Exception along with this program;    --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see   --
--  <http://www.gnu.org/licenses/>.                                         --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
------------------------------------------------------------------------------

with AWS.URL;
with AWS.Utils;

separate (WSDL2AWS.Generator)
package body Skel is

   -----------------
   -- End_Service --
   -----------------

   procedure End_Service
     (O    : in out Object;
      Name : String)
   is
      LL_Name : constant String :=
                  Characters.Handling.To_Lower (Format_Name (O, Name));
   begin
      Generate (LL_Name & ".ads", Skel_Template, O.Skel_Trans);
      Generate (LL_Name & ".adb", Skel_Template, O.Stub_Trans);
   end End_Service;

   -------------------
   -- New_Procedure --
   -------------------

   procedure New_Procedure
     (O             : in out Object;
      Proc          : String;
      Documentation : String;
      SOAPAction    : String;
      Wrapper_Name  : String;
      Namespace     : SOAP.Name_Space.Object;
      Input         : WSDL.Parameters.P_Set;
      Output        : WSDL.Parameters.P_Set;
      Fault         : WSDL.Parameters.P_Set)
   is
      pragma Unreferenced (Wrapper_Name, Namespace, Fault);

      use all type SOAP.WSDL.Parameter_Type;

      use Ada.Strings.Fixed;
      use type SOAP.WSDL.Schema.Binding_Style;
      use type WSDL.Parameters.P_Set;
      use type WSDL.Types.Kind;

      procedure Output_Parameters (N : WSDL.Parameters.P_Set);
      --  Output parameters

      L_Proc  : constant String := Format_Name (O, Proc);
      Max_Len : Positive := 1;

      N       : WSDL.Parameters.P_Set;

      -----------------------
      -- Output_Parameters --
      -----------------------

      procedure Output_Parameters (N : WSDL.Parameters.P_Set) is
         T_Name : constant String := WSDL.Types.Name (N.Typ);
         R      : WSDL.Parameters.P_Set;
      begin
         ==> FROM_SOAP
         Text_IO.Put (Skel_Adb, "           := ");

         case N.Mode is
            when WSDL.Types.K_Simple =>
               --  Check for Base64 case

               if SOAP.WSDL.To_Type (T_Name) = P_B64 then
                  Text_IO.Put
                    (Skel_Adb,
                     " V (SOAP_Base64'(SOAP.Parameters.Get (Params, """);
                  Text_IO.Put      (Skel_Adb, To_String (N.Name));
                  Text_IO.Put_Line (Skel_Adb, """)));");

               elsif SOAP.WSDL.To_Type (T_Name) = P_Character then
                  Text_IO.Put
                    (Skel_Adb,
                     " SOAP.Utils.Get (SOAP.Parameters.Argument (Params, """);
                  Text_IO.Put      (Skel_Adb, To_String (N.Name));
                  Text_IO.Put_Line (Skel_Adb, """));");

               else
                  Text_IO.Put
                    (Skel_Adb, " SOAP.Parameters.Get (Params, """);
                  Text_IO.Put      (Skel_Adb, To_String (N.Name));
                  Text_IO.Put_Line (Skel_Adb, """);");
               end if;

            when WSDL.Types.K_Derived =>
               Text_IO.Put
                 (Skel_Adb,
                  WSDL.Parameters.From_SOAP
                    (N.all,
                     Object =>
                        "SOAP.Parameters.Get (Params, """
                        & To_String (N.Name) & """)",
                     Is_SOAP_Type => True));
               Text_IO.Put_Line (Skel_Adb, ";");

            when WSDL.Types.K_Enumeration =>
               Text_IO.Put_Line
                 (Skel_Adb, T_Name & "_Type'Value");

               Text_IO.Put      (Skel_Adb, "                ");
               Text_IO.Put
                 (Skel_Adb,
                  "(SOAP.Utils.Get (SOAP.Parameters.Argument (Params, """);
               Text_IO.Put      (Skel_Adb, To_String (N.Name));
               Text_IO.Put_Line (Skel_Adb, """)));");

            when WSDL.Types.K_Array =>
               raise Constraint_Error;

            when WSDL.Types.K_Record =>
               Text_IO.Put (Skel_Adb, " (");

               R := N.P;

               while R /= null loop
                  Text_IO.Put
                    (Skel_Adb, "SOAP.Parameters.Get ("
                       & Format_Name (O, T_Name) & "_Record, """
                       & Format_Name (O, To_String (R.Name)) & """)");

                  if R.Next /= null then
                     Text_IO.Put_Line (Skel_Adb, ",");
                     Text_IO.Put      (Skel_Adb, "               ");
                  else
                     Text_IO.Put_Line (Skel_Adb, ");");
                  end if;

                  R := R.Next;
               end loop;
         end case;
      end Output_Parameters;

   begin
      --  Spec

      ==> TO BE DONE
        . SOAP_ACTION_PREFIX (O.Prefix) ???
        . SOAP_ACTION
        . SOAP_PROC (Proc) = Prefix + Proc
        . PROC (L_Proc)
        . DEBUG
        . IS_RPC

      Put_Header       (Skel_Ads, O, Proc, Input, Output, Mode => Skel_Spec);


      if Input /= null or else Output /= null then
         Text_IO.Put_Line
           (Skel_Adb, "      declare");
      end if;

      --  Find maximum parameter name length to align them

      N := Input;

      while N /= null loop
         Max_Len := Positive'Max
           (Max_Len, Format_Name (O, To_String (N.Name))'Length);
         N := N.Next;
      end loop;

      --  Input parameters

      N := Input;

      while N /= null loop
         declare
            ==> COMPOUND_PARAMETER_NAME
            ==> COMPOUND_PARAMETER_TYPE
            ==> COMPOUND_PARAMETER_GET
            Q_Name : constant String :=
                       SOAP.Utils.To_Name
                         (WSDL.Types.Name (N.Typ, NS => True));
            T_Name : constant String := WSDL.Types.Name (N.Typ);
         begin
            Text_IO.Put      (Skel_Adb, "         ");

            if N.Mode = WSDL.Types.K_Array then
               Text_IO.Put_Line
                 (Skel_Adb,
                  To_String (N.Name) & "_"
                  & Format_Name (O, T_Name) & "_Array : "
                  & "constant SOAP.Types.SOAP_Array");
               Text_IO.Put_Line
                 (Skel_Adb,
                  "           := SOAP.Parameters.Get (Params, """
                  & To_String (N.Name) & """);");
               Text_IO.Put      (Skel_Adb, "         ");

            elsif N.Mode = WSDL.Types.K_Record then
               Text_IO.Put_Line
                 (Skel_Adb,
                  To_String (N.Name) & "_"
                  & Format_Name (O, T_Name) & "_Record : "
                  & "constant SOAP.Types.SOAP_Record");

               if N.P = null then
                  --  An empty record, just build a corresponding object
                  Text_IO.Put_Line
                    (Skel_Adb,
                     "           := SOAP.Types.R (SOAP.Types.Empty_Object_Set"
                     & ", """ & To_String (N.Name) & """);");
               else
                  Text_IO.Put_Line
                    (Skel_Adb,
                     "           := SOAP.Parameters.Get (Params, """
                     & To_String (N.Name) & """);");
               end if;

               Text_IO.Put      (Skel_Adb, "         ");
            end if;

            declare
               => PARAMETER_NAME
               Name : constant String :=
                        Format_Name (O, To_String (N.Name));
            begin
               Text_IO.Put   (Skel_Adb, Name);
               Text_IO.Put   (Skel_Adb, (Max_Len - Name'Length) * ' ');
            end;

            Text_IO.Put      (Skel_Adb, " : constant ");

            => PARAMETER_TYPE (As in Input_Parameters in wsdl2aws-generator)
            case N.Mode is
               when WSDL.Types.K_Simple =>
                  Text_IO.Put_Line
                    (Skel_Adb, SOAP.WSDL.To_Ada (SOAP.WSDL.To_Type (T_Name)));
                  Output_Parameters (N);

               when WSDL.Types.K_Enumeration =>
                  Text_IO.Put_Line (Skel_Adb, T_Name & "_Type");
                  Output_Parameters (N);

               when WSDL.Types.K_Derived =>
                  Text_IO.Put_Line (Skel_Adb, Q_Name & "_Type");
                  Output_Parameters (N);

               when WSDL.Types.K_Array =>
                  Text_IO.Put_Line
                    (Skel_Adb, Format_Name (O, T_Name) & "_Type");
                  Text_IO.Put_Line
                    (Skel_Adb, "           := To_"
                     & Format_Name (O, T_Name) & "_Type (V ("
                     & To_String (N.Name) & "_"
                     & Format_Name (O, T_Name) & "_Array));");

               when WSDL.Types.K_Record =>
                  Text_IO.Put_Line
                    (Skel_Adb, Format_Name (O, T_Name) & "_Type");
                  Text_IO.Put_Line
                    (Skel_Adb, "           := To_"
                     & Format_Name (O, T_Name) & "_Type ("
                     & To_String (N.Name) & "_"
                     & Format_Name (O, T_Name) & "_Record);");
            end case;
         end;

         N := N.Next;
      end loop;

      --  Output parameters

      if Output = null then

         Text_IO.Put_Line
           (Skel_Adb, "      begin");
         Text_IO.Put
           (Skel_Adb, "         " & L_Proc);

      else
         Text_IO.Put
           (Skel_Adb, "         Result : ");

         if not Is_Simple_Wrapped_Parameter (O, Output) then
            Text_IO.Put (Skel_Adb, "constant ");
         end if;

         if Output.Next = null
           and then Output.Mode = WSDL.Types.K_Simple
         then
            Text_IO.Put
              (Skel_Adb,
               SOAP.WSDL.To_Ada
                 (SOAP.WSDL.To_Type (WSDL.Types.Name (Output.Typ))));

         else
            Text_IO.Put (Skel_Adb, L_Proc & "_Result");
         end if;

         if Is_Simple_Wrapped_Parameter (O, Output) then
            --  A simple wrapped output, assign the result here

            Text_IO.Put_Line (Skel_Adb, ";");
            Text_IO.Put_Line (Skel_Adb, "      begin");

            Text_IO.Put (Skel_Adb, "         Result");

            if WSDL.Parameters.Length (Output.P) = 1
              and then Output.P.Mode /= WSDL.Types.K_Array
            then
               Text_IO.Put
                 (Skel_Adb, '.' & To_String (Output.P.Name));
            end if;

            Text_IO.Put
              (Skel_Adb, " :=");

            if Is_String (Output.P) then
               Text_IO.Put (Skel_Adb, " +");
            end if;

         else
            Text_IO.New_Line;
            Text_IO.Put
              (Skel_Adb, "                   :=");
         end if;

         Text_IO.Put
           (Skel_Adb, " " & L_Proc & "_CB." & L_Proc);

         if Input /= null then
            Text_IO.New_Line (Skel_Adb);
         end if;
      end if;

      --  Input parameters

      if Is_Simple_Wrapped_Parameter (O, Input) then
         --  A simple wrapped input as parameters, inline all fields as
         --  parameter for the callback.

         N := Input.P;

         while N /= null loop
            Text_IO.Put (Skel_Adb, "                ");

            if N = Input.P then
               Text_IO.Put (Skel_Adb, "(");
            else
               Text_IO.Put (Skel_Adb, " ");
            end if;

            if Is_String (N) then
               Text_IO.Put (Skel_Adb, '-');
            end if;

            Text_IO.Put
              (Skel_Adb,
               Format_Name (O, To_String (Input.Name))
               & "."
               & Format_Name (O, To_String (N.Name)));

            if N.Mode = WSDL.Types.K_Array
              and then O.Sp
            then
               Text_IO.Put (Skel_Adb, ".Item.all");
            end if;

            if N.Next = null then
               Text_IO.Put (Skel_Adb, ")");
            else
               Text_IO.Put_Line (Skel_Adb, ",");
            end if;

            N := N.Next;
         end loop;

      else
         N := Input;

         while N /= null loop
            Text_IO.Put (Skel_Adb, "                ");

            if N = Input then
               Text_IO.Put (Skel_Adb, "(");
            else
               Text_IO.Put (Skel_Adb, " ");
            end if;

            Text_IO.Put (Skel_Adb, Format_Name (O, To_String (N.Name)));

            if N.Next = null then
               Text_IO.Put (Skel_Adb, ")");
            else
               Text_IO.Put_Line (Skel_Adb, ",");
            end if;

            N := N.Next;
         end loop;
      end if;

      Text_IO.Put_Line (Skel_Adb, ";");

      --  Set SOAP results

      if Output /= null then

         if not Is_Simple_Wrapped_Parameter (O, Output) then
            Text_IO.Put_Line
              (Skel_Adb, "      begin");
         end if;

         Text_IO.Put_Line
           (Skel_Adb, "         R_Params :=");
         Text_IO.Put
           (Skel_Adb, "           +");

         N := Output;

         while N /= null loop
            if N /= Output then
               Text_IO.Put
                 (Skel_Adb, "           & ");
            end if;

            declare
               T_Name : constant String := WSDL.Types.Name (N.Typ, True);
               NS     : constant SOAP.Name_Space.Object :=
                          SOAP.WSDL.Name_Spaces.Get
                            (SOAP.Utils.NS (To_String (N.Elmt_Name)));
            begin
               ==> TO_SOAP
               case N.Mode is
                  when WSDL.Types.K_Simple =>
                     if Output.Next = null then
                        --  A single simple parameter as return

                        Text_IO.Put
                          (Skel_Adb,
                           SOAP.WSDL.Set_Routine (SOAP.WSDL.To_Type (T_Name)));

                        Text_IO.Put
                          (Skel_Adb,
                           " (Result, """ & To_String (N.Name) & ""","
                           & " Type_Name => """ & T_Name & '"');

                        if SOAP.Name_Space.Is_Defined (NS) then
                           Text_IO.Put
                             (Skel_Adb,
                              ", NS => SOAP.Name_Space.Create ("""
                              & SOAP.Name_Space.Name (NS)
                              & """, """
                              & SOAP.Name_Space.Value (NS) & """))");
                        else
                           Text_IO.Put (Skel_Adb, ")");
                        end if;

                     else
                        --  Multiple value returned, this is a record

                        Text_IO.Put
                          (Skel_Adb,
                           SOAP.WSDL.Set_Routine
                             (SOAP.WSDL.To_Type (T_Name),
                              Constrained => True));

                        Text_IO.Put
                          (Skel_Adb, " (Result."
                           & Format_Name (O, To_String (N.Name))
                           & ", """ & To_String (N.Name) & ""","
                           & " Type_Name => """ & T_Name & """)");
                     end if;

                  when WSDL.Types.K_Derived | WSDL.Types.K_Enumeration =>
                     if Output.Next = null then
                        Text_IO.Put
                          (Skel_Adb,
                           WSDL.Parameters.To_SOAP
                             (N.all,
                              Object    => "Result",
                              Name      => To_String (N.Name),
                              Type_Name => T_Name));
                     else
                        Text_IO.Put
                          (Skel_Adb,
                           WSDL.Parameters.To_SOAP
                             (N.all,
                              Object    =>
                                "Result."
                                  & Format_Name (O, To_String (N.Name)),
                              Name      => To_String (N.Name),
                              Type_Name => T_Name));
                     end if;

                  when WSDL.Types.K_Array =>
                     if Output.Next = null then
                        --  A single array as returned parameter
                        Text_IO.Put
                          (Skel_Adb,
                           WSDL.Parameters.To_SOAP
                             (N.all,
                              Object    => "Result",
                              Name      => To_String (N.Name),
                              Type_Name => T_Name));

                     else
                        --  Array here is part of an array
                        Text_IO.Put
                          (Skel_Adb,
                           WSDL.Parameters.To_SOAP
                             (N.all,
                              Object    => "Result."
                                            & To_String (N.Name)
                                            & (if O.Sp
                                               then ".Item.all"
                                               else ""),
                              Name      => To_String (N.Name),
                              Type_Name => T_Name));
                     end if;

                  when WSDL.Types.K_Record =>
                     Text_IO.Put
                       (Skel_Adb,
                        WSDL.Parameters.To_SOAP
                          (N.all,
                           Object => "Result",
                           Name   => To_String (N.Name)));
               end case;

               if N.Next = null then
                  Text_IO.Put_Line (Skel_Adb, ";");
               else
                  Text_IO.New_Line (Skel_Adb);
               end if;
            end;

            N := N.Next;
         end loop;
      end if;
   end New_Procedure;

   -------------------
   -- Start_Service --
   -------------------

   procedure Start_Service
     (O                  : in out Object;
      Name               : String;
      Root_Documentation : String;
      Documentation      : String;
      Location           : String)
   is
      pragma Unreferenced (Root_Documentation);

      U_Name : constant String         := To_Unit_Name (Format_Name (O, Name));
      URL    : constant AWS.URL.Object :=
                 AWS.URL.Parse (Get_Endpoint (O, Location));
      S_With : Templates.Tag;
      B_With : Templates.Tag;
   begin
      --  Spec

      O.Skel_Trans := O.Skel_Trans
        & Translate.Assoc ("UNIT_NAME", U_Name)
        & Translate.Assoc ("SERVER_PORT", AWS.URL.Port (URL))
        & Translate.Assoc ("DEBUG", O.Debug);

      S_With := S_With
        & "Ada.Calendar"
        & "System.Assertions"
        & "AWS.Status"
        & "AWS.Response"
        & "SOAP.Message.Payload"
        & "SOAP.Types";

      O.Skel_Trans := O.Skel_Trans & Templates.Assoc ("WITHED_UNITS", S_With);

      --  Body

      O.Stub_Trans := O.Stub_Trans
        & Translate.Assoc ("UNIT_NAME", U_Name)
        & Translate.Assoc ("SERVER_PORT", AWS.URL.Port (URL))
        & Translate.Assoc ("DEBUG", O.Debug);

      B_With := B_With
        & "Ada.Exceptions"
        & "SOAP.Message.Response.Error"
        & "SOAP.Name_Space"
        & "SOAP.Parameters"
        & "SOAP.Utils";

      O.Stub_Trans := O.Stub_Trans & Templates.Assoc ("WITHED_UNITS", B_With);
   end Start_Service;

end Skel;
