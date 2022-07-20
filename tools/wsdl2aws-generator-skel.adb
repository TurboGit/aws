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

   use Templates;

   Template_Skel_Ads : constant String := "s-skel.tads";
   Template_Skel_Adb : constant String := "s-skel.tadb";

   procedure Add_TagV
     (Set                  : in out Templates.Translate_Set;
      Assoc_Name, Tag_Name : String);

   procedure Add_TagV
     (Set        : in out Templates.Translate_Set;
      Assoc_Name : String;
      Value      : Boolean);

   --------------
   -- Add_TagV --
   --------------

   procedure Add_TagV
     (Set                  : in out Templates.Translate_Set;
      Assoc_Name, Tag_Name : String)
   is
      T : Templates.Tag;
   begin
      if Templates.Exists (Set, Assoc_Name) then
         T := Templates.Get (Templates.Get (Set, Assoc_Name));
      end if;

      T := T & Tag_Name;

      Templates.Insert (Set, Templates.Assoc (Assoc_Name, T));
   end Add_TagV;

   procedure Add_TagV
     (Set        : in out Templates.Translate_Set;
      Assoc_Name : String;
      Value      : Boolean)
   is
      T : Templates.Tag;
   begin
      if Templates.Exists (Set, Assoc_Name) then
         T := Templates.Get (Templates.Get (Set, Assoc_Name));
      end if;

      T := T & Value;

      Templates.Insert (Set, Templates.Assoc (Assoc_Name, T));
   end Add_TagV;

   -----------------
   -- End_Service --
   -----------------

   procedure End_Service
     (O    : in out Object;
      Name : String)
   is
      LL_Name : constant String :=
                  Characters.Handling.To_Lower (Format_Name (O, Name))
                  & "-server";
   begin
      Text_IO.Put_Line ("Generate : " & LL_Name);

      Generate (LL_Name & ".ads", Template_Skel_Ads, O.Skel_S_Trans);
      Generate (LL_Name & ".adb", Template_Skel_Adb, O.Skel_B_Trans);
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
      pragma Unreferenced (Wrapper_Name, Namespace, Fault,
                           Documentation);

      use all type SOAP.WSDL.Parameter_Type;

      --  use Ada.Strings.Fixed;
      use type SOAP.WSDL.Schema.Binding_Style;
      use type WSDL.Parameters.P_Set;
      use type WSDL.Types.Kind;

      procedure Output_Parameters (N : WSDL.Parameters.P_Set);
      --  Output parameters

      L_Proc  : constant String := Format_Name (O, Proc);
      N       : WSDL.Parameters.P_Set;

      Parameter_Name : Templates.Tag;
      Parameter_Type : Templates.Tag;
      Parameter_Get  : Templates.Tag;
      Decl_Name      : Templates.Tag;
      Decl_Kind      : Templates.Tag;
      Decl_P_Name    : Templates.Tag;

      -----------------------
      -- Output_Parameters --
      -----------------------

      procedure Output_Parameters (N : WSDL.Parameters.P_Set) is
         T_Name : constant String := WSDL.Types.Name (N.Typ);
         R      : WSDL.Parameters.P_Set;
      begin
         --  ==> FROM_SOAP
         Text_IO.Put (Skel_Adb, "           := ");

         case N.Mode is
            when WSDL.Types.K_Simple =>
               --  Check for Base64 case

               if SOAP.WSDL.To_Type (T_Name) = P_B64 then
                  Parameter_Get := Parameter_Get
                    & "V (SOAP_Base64'(SOAP.Parameters.Get (Params, """
                    & To_String (N.Name)
                    & """)))";

               elsif SOAP.WSDL.To_Type (T_Name) = P_Character then
                  Parameter_Get := Parameter_Get
                    &  "SOAP.Utils.Get (SOAP.Parameters.Argument (Params, """
                    & To_String (N.Name)
                    & """))";

               else
                  Parameter_Get := Parameter_Get
                    & "SOAP.Parameters.Get (Params, """
                    & To_String (N.Name)
                    & """)";
               end if;

            when WSDL.Types.K_Derived =>
               Parameter_Get := Parameter_Get
                 & WSDL.Parameters.From_SOAP
                     (N.all,
                      Object =>
                         "SOAP.Parameters.Get (Params, """
                         & To_String (N.Name) & """)",
                      Is_SOAP_Type => True);

            when WSDL.Types.K_Enumeration =>
               Parameter_Get := Parameter_Get
                 & (T_Name & "_Type'Value"
                    & "(SOAP.Utils.Get (SOAP.Parameters.Argument (Params, """
                    & To_String (N.Name)
                    & """)))");

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

      --  ==> TO BE DONE
      --    . SOAP_ACTION_PREFIX (O.Prefix) ???
      --    . SOAP_ACTION
      --    . SOAP_PROC (Proc) = Prefix + Proc
      --    . PROC (L_Proc)
      --    . DEBUG
      --    . IS_RPC

      Add_TagV (O.Skel_S_Trans, "PROC", L_Proc);
      Add_TagV (O.Skel_B_Trans, "PROC", L_Proc);

      Add_TagV (O.Skel_S_Trans, "SOAP_ACTION", SOAPAction);
      Add_TagV (O.Skel_B_Trans, "SOAP_ACTION", SOAPAction);

      Add_TagV (O.Skel_B_Trans, "IS_RPC", O.Style = SOAP.WSDL.Schema.RPC);

      Put_Header (Skel_Ads, O, Proc, Input, Output, Mode => Skel_Spec);

      if Input /= null or else Output /= null then
         Text_IO.Put_Line
           (Skel_Adb, "      declare");
      end if;

      --  Input parameters

      N := Input;

      while N /= null loop
         declare
            --  ==> DECL_PARAMETER_NAME
            --  ==> DECL_PARAMETER_TYPE
            --  ==> DECL_PARAMETER_GET
            Q_Name : constant String :=
                       SOAP.Utils.To_Name
                         (WSDL.Types.Name (N.Typ, NS => True));
            T_Name : constant String := WSDL.Types.Name (N.Typ);
         begin
            if N.Mode = WSDL.Types.K_Array then
               Decl_Kind := Decl_Kind & "ARRAY";
               Decl_Name := Decl_Name
                 & To_String (N.Name)
                 & "_" & Format_Name (O, T_Name) & "_Array";
               Decl_P_Name := Decl_P_Name
                 & To_String (N.Name);

            elsif N.Mode = WSDL.Types.K_Record then
               Decl_Name := Decl_Name
                 & To_String (N.Name)
                 & "_" & Format_Name (O, T_Name) & "_Record";
               Decl_P_Name := Decl_P_Name
                 & To_String (N.Name);

               if N.P = null then
                  Decl_Kind := Decl_Kind & "NULL_RECORD";
               else
                  Decl_Kind := Decl_Kind & "RECORD";
               end if;

            end if;

            Parameter_Name := Parameter_Name
              & Format_Name (O, To_String (N.Name));

            --  => PARAMETER_TYPE (As in Input_Parameters
            --     in wsdl2aws - generator)
            case N.Mode is
               when WSDL.Types.K_Simple =>
                  Parameter_Type := Parameter_Type
                    & SOAP.WSDL.To_Ada (SOAP.WSDL.To_Type (T_Name));

                  Output_Parameters (N);

               when WSDL.Types.K_Enumeration =>
                  Parameter_Type := Parameter_Type
                    & (T_Name & "_Type");

                  Output_Parameters (N);

               when WSDL.Types.K_Derived =>
                  Parameter_Type := Parameter_Type
                    & (Q_Name & "_Type");
                  Output_Parameters (N);

               when WSDL.Types.K_Array =>
                  Parameter_Type := Parameter_Type
                    & (Format_Name (O, T_Name) & "_Type");

                  Parameter_Get := Parameter_Get
                    & "To_"
                    & Format_Name (O, T_Name) & "_Type (V ("
                    & To_String (N.Name) & "_"
                    & Format_Name (O, T_Name) & "_Array))";

               when WSDL.Types.K_Record =>
                  Parameter_Type := Parameter_Type
                    & (Format_Name (O, T_Name) & "_Type");

                  Parameter_Get := Parameter_Get
                    & "To_"
                    & Format_Name (O, T_Name) & "_Type ("
                    & To_String (N.Name) & "_"
                    & Format_Name (O, T_Name) & "_Record)";
            end case;
         end;

         N := N.Next;
      end loop;

      O.Skel_B_Trans := O.Skel_B_Trans
        & Templates.Assoc ("DECL_NAME", Decl_Name)
        & Templates.Assoc ("DECL_P_NAME", Decl_P_Name)
        & Templates.Assoc ("DECL_KIND", Decl_Kind)
        & Templates.Assoc ("PARAMETER_NAME", Parameter_Name)
        & Templates.Assoc ("PARAMETER_TYPE", Parameter_Type)
        & Templates.Assoc ("PARAMETER_GET", Parameter_Get);

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
               --  ==> TO_SOAP
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
      pragma Unreferenced (Root_Documentation, Documentation);

      U_Name : constant String         := To_Unit_Name (Format_Name (O, Name));
      URL    : constant AWS.URL.Object :=
                 AWS.URL.Parse (Get_Endpoint (O, Location));
      S_With : Templates.Tag;
      B_With : Templates.Tag;
   begin
      --  Spec

      O.Skel_S_Trans := O.Skel_S_Trans
        & Templates.Assoc ("UNIT_NAME", U_Name)
        & Templates.Assoc ("SERVER_PORT", Positive'(AWS.URL.Port (URL)))
        & Templates.Assoc ("DEBUG", O.Debug);

      S_With := S_With
        & "Ada.Calendar"
        & "System.Assertions"
        & "AWS.Status"
        & "AWS.Response"
        & "SOAP.Message.Payload"
        & "SOAP.Types";

      O.Skel_S_Trans := O.Skel_S_Trans
        & Templates.Assoc ("WITHED_UNITS", S_With);

      --  Body

      O.Skel_B_Trans := O.Skel_B_Trans
        & Templates.Assoc ("UNIT_NAME", U_Name)
        & Templates.Assoc ("SERVER_PORT", Positive'(AWS.URL.Port (URL)))
        & Templates.Assoc ("DEBUG", O.Debug);

      B_With := B_With
        & "Ada.Exceptions"
        & "SOAP.Message.Response.Error"
        & "SOAP.Name_Space"
        & "SOAP.Parameters"
        & "SOAP.Utils";

      O.Skel_B_Trans := O.Skel_B_Trans
        & Templates.Assoc ("WITHED_UNITS", B_With);
   end Start_Service;

end Skel;
