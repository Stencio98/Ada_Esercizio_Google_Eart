-- guardare:
-- https://gist.github.com/jtornero/9f3ddabc6a89f8292bb2
   with Ada.Text_IO; use Ada.Text_IO;
   with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
   with Ada.Float_Text_IO; use Ada.Float_Text_IO;
   with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics; use Ada.Numerics; -- sqrt
with Ada; use Ada;


package body my_utils is

   -- equals float
   function Are_Equal (A, B : Float) return Boolean is
   begin
      return Abs (A - B) < 0.001;
   end Are_Equal;

   -- procedure to take parameters from user
   procedure Start (A : in out ArrayOffloat_5) is
   begin
      Put_Line("Insert Distance: ");
      Get (A(0));
      Put_Line("Insert angle: ");
      Get (A(1));
      -- fix angle
      -- serve realmente? cos 400 = cos 40 ....
      while A(1) < -360.0 loop
         A(1) := A(1) + 360.0;
      end loop;
      while A(1) > 360.0 loop
         A(1) := A(1) - 360.0;
      end loop;

      Put_Line("Insert latitude (-90 to 90): ");
      Get (A(2));
      while A(2) < -90.0 or A(2) > 90.0 loop
         Put_Line("Insert latitude (-90 to 90): ");
         Get(A(2));
      end loop;

      Put_Line("Insert longitude (-180 to 180): ");
      Get (A(3));
      while A(3) < -180.0 or A(3) > 180.0 loop
         Put_Line("Insert longitude (-180 to 180): ");
         Get(A(3));
      end loop;

      Put_Line("Insert World Conception (0,1,2): ");
      Get (A(4));
      while not Are_Equal(A(4),0.0) and not Are_Equal(A(4),1.0) and not Are_Equal(A(4),2.0) loop
         Put_Line("Insert World Conception (0,1,2): ");
         Get(A(4));
      end loop;


      -- Stampare i valori (DEBUG)
      Put_Line ("DEB: Values for computing:");
      Put("|");
      for I in A'Range loop
         Put (Float'Image (A(I)));
         Put (" |");
      end loop;
      New_Line;

   end Start;


   -- plane world
   procedure piano (
   LO, LA : in out ArrayOfFloat_12;
   i      : Integer;
   angle  : Float;
   distance_miles : Float
   ) is
      Pi           : constant Float := 3.141592653589793;
      deg_per_mile : constant Float := 1.0 / 69.0; --1 grado crca 69 miglia
      angle_rad    : Float := angle * Pi / 180.0;

      delta_lat_deg : Float;
      delta_lon_deg : Float;
   begin
      -- spostamento in gradi (lat/lon) tenendo conti della latitudine
      delta_lat_deg := (distance_miles * Sin(angle_rad)) * deg_per_mile;

   -- serve il coseno della latitudine corrente (in radianti)
      delta_lon_deg := (distance_miles * Cos(angle_rad)) /
                    (69.0 * Cos(LA(i - 1) * Pi / 180.0));

      LA(i) := LA(i - 1) + delta_lat_deg;
      LO(i) := LO(i - 1) + delta_lon_deg;
   end piano;


   procedure sfera (
   LO, LA : in out ArrayOfFloat_12;
   i      : Integer;
   angle  : Float; -- in gradi
   distance_miles : Float
   ) is
      Pi : constant Float := 3.141592653589793;
      --R         : constant Float := 3960.0; -- Raggio terrestre in miglia
      R : constant Float := 3960.0 + 2.699784;
      angle_rad : Float := angle * Pi / 180.0;

      lat1_rad  : Float := LA(i - 1) * Pi / 180.0;
      lon1_rad  : Float := LO(i - 1) * Pi / 180.0;
      d_div_R   : Float := distance_miles / R;

      lat2_rad  : Float;
      lon2_rad  : Float;

   begin
      lat2_rad := ArcSin(Sin(lat1_rad)*Cos(d_div_R) +
                      Cos(lat1_rad)*Sin(d_div_R)*Cos(angle_rad));

      lon2_rad := lon1_rad +
               ArcTan(Sin(angle_rad)*Sin(d_div_R)*Cos(lat1_rad),
                       Cos(d_div_R) - Sin(lat1_rad)*Sin(lat2_rad));

      LA(i) := lat2_rad * 180.0 / Pi;
      LO(i) := lon2_rad * 180.0 / Pi;
   end sfera;


   procedure vincenty (
                       LO, LA : in out ArrayOfFloat_12;
                       i      : Integer;
                       angle_input  : Float; -- in gradi
                       distance_miles : Float
                      ) is

      deg_to_rad : constant Float := 3.14159265358979 / 180.0;
      lat1_rad: Float := LA(i - 1) * deg_to_rad;
      lon1_rad: Float := LO(i - 1) * deg_to_rad;
      angle : Float := angle_input * deg_to_rad;

      rad_to_deg : constant Float := 180.0 / 3.14159265358979;


      semi_asse_max : constant Float := (6378.1370 + 5.0) / 1.852; -- conversione in miglia
      f : constant Float := 1.0 / 298.257223563; -- schiacciamento
      semi_asse_min : constant Float := semi_asse_max * (1.0 - f);
      tolleranza : Float := 1.0e-12; --ciclo while

      U1 : Float := Arctan((1.0 - f) * Tan(lat1_rad));
      sigma1 : Float := Arctan(Tan(U1), Cos(angle));
      sin_alpha : Float := (Cos(U1) * Sin(angle));
      cosAlpha_al_quadrato : Float := 1.0 - sin_alpha**2;

      u_al_quadrato : Float := cosAlpha_al_quadrato * (semi_asse_max**2 - semi_asse_min**2) / semi_asse_min**2;
      A : Float := 1.0 + (u_al_quadrato / 16384.0) * (4096.0 + u_al_quadrato * (-768.0 + u_al_quadrato * (320.0 - 175.0 * u_al_quadrato)));
      B : Float := (u_al_quadrato / 1024.0) * (256.0 + u_al_quadrato * (-128.0 + u_al_quadrato * (74.0 - 47.0 * u_al_quadrato)));

      sigma : Float := distance_miles / (semi_asse_min * A);
      sigma_prev : Float := 0.0;
      -- limite iterazioni --> 100

      sigma_sigma_prev : Float := sigma - sigma_prev;
      iterations : Integer := 0;

      due_sigma_m : Float := 0.0;
      delta_sigma : Float := 0.0;

      phi_2 : Float := 0.0;
      lambda : Float := 0.0;
      C : Float := 0.0;
      L : Float := 0.0;

      lambda_due : Float := 0.0;
      alpha_due : Float := 0.0;


   begin
      --rimettere il segno + a sigma - sigma_prev
      while sigma_sigma_prev > tolleranza and iterations < 1000 loop
         due_sigma_m := 2.0 * sigma1 + sigma;
         delta_sigma := B * Sin(sigma) * (Cos(due_sigma_m) + (B / 4.0) * (Cos(sigma) * (-1.0 + 2.0 * Cos(due_sigma_m)**2) - (B / 6.0) * Cos(due_sigma_m) * (-3.0 + 4.0 * Sin(sigma)**2) * (-3.0 + 4.0 * Cos(sigma)**2)));
         sigma_prev := sigma;
         sigma := distance_miles / (semi_asse_min * A) + delta_sigma;

         iterations := iterations + 1;
         sigma_sigma_prev := sigma - sigma_prev; --ricalcola il sigma prev

         if sigma_sigma_prev < 0.0 then
            sigma_sigma_prev := 0.0 - sigma_sigma_prev;
         end if;

      end loop;

      phi_2 := Arctan(Sin(U1) * Cos(sigma) + Cos(U1) * Sin(sigma) * Cos(angle), (1.0 - f) * Sqrt(sin_alpha**2 + (Sin(U1) * Sin(sigma) - Cos(U1) * Cos(sigma) * Cos(angle))**2));
      lambda := Arctan(Sin(sigma) * Sin(angle), Cos(U1) * Cos(sigma) - Sin(U1) * Sin(sigma) * Cos(angle));
      C := (f / 16.0) * cosAlpha_al_quadrato * (4.0 + f * (4.0 - 3.0 * cosAlpha_al_quadrato));
      L := lambda - (1.0 - C) * f * sin_alpha * (sigma + C * Sin(sigma) * (Cos(due_sigma_m) + C * Cos(sigma) * (-1.0 + 2.0 * Cos(due_sigma_m)**2)));
      lambda_due := lon1_rad + L;
      alpha_due := Arctan(sin_alpha, - Sin(U1) * Sin(sigma) + Cos(U1) * Cos(sigma) * Cos(angle));
      LA(i) := phi_2 * rad_to_deg;
      LO(i) := lambda_due * rad_to_deg;
   end vincenty;

      -- EXPORT TO KML
   procedure Export_Punti_To_KML (
                                  Latitudes: in ArrayOfFloat_12;
                                  Longitudes : in ArrayOfFloat_12;
                                  File_Name  : in String
                                 ) is
      -- La procedura assume che gli array siano della stessa lunghezza
      File : File_Type;
   begin
      -- Apri il file
      Create (File, Out_File, File_Name);

    -- Scrivi intestazione KML
    Put_Line (File, "<?xml version=""1.0"" encoding=""UTF-8""?>");
    Put_Line (File, "<kml xmlns=""http://www.opengis.net/kml/2.2"">");
    Put_Line (File, "  <Document>");

    -- Loop sui punti
    for Index in Latitudes'Range loop
        Put_Line (File, "    <Placemark>");
        Put_Line (File, "      <name>Punto " & Integer'Image (Index) & "</name>");
        Put_Line (File, "      <Point>");
        Put_Line (File,
            "        <coordinates>" & Float'Image (Longitudes (Index)) & "," &
                             Float'Image (Latitudes (Index)) & ",0</coordinates>");
        Put_Line (File, "      </Point>");
        Put_Line (File, "    </Placemark>");
    end loop;

    -- Chiudi i tag
    Put_Line (File, "  </Document>");
    Put_Line (File, "</kml>");

    -- Chiudi il file
    Close (File);
end Export_Punti_To_KML;
end my_utils;
