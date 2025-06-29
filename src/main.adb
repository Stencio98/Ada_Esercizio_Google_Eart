with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics; use Ada.Numerics; -- sqrt
with Ada; use Ada;

with my_utils; use my_utils;


procedure Main is

-- INIZIO DEL MAIN
begin
   Start(array_start);
   New_Line;
   -- calcules...
   -- su un piano --> lantudine (asse y); longitidine (asse x)

   -- imposto il punto A di partenza nell'array
   latitudes(0) := array_start(2); --a
   longitudes(0) := array_start(3); --a

   -- controllo prima il tipo di mondo su cui calcolo
   if Are_Equal (array_start(4), 0.0) then
      Put_Line ("selezionato: piano");
      -- 11 chiamate per completare le celle restanti
      piano (longitudes, latitudes, 1, array_start(1) + 90.0, array_start(0));--b
      piano (longitudes, latitudes, 2, array_start(1), array_start(0));--c
      piano (longitudes, latitudes, 3, array_start(1)+ 90.0, array_start(0));--d
      piano (longitudes, latitudes, 4, array_start(1) - 45.0, array_start(0) * Sqrt(2.0));--e
      piano (longitudes, latitudes, 5, array_start(1) + 90.0, array_start(0));--f
      piano (longitudes, latitudes, 6, array_start(1) - 45.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--g
      piano (longitudes, latitudes, 7, array_start(1) - 135.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--h
      piano (longitudes, latitudes, 8, array_start(1) + 90.0, array_start(0));--i
      piano (longitudes, latitudes, 9, array_start(1) - 135.0, array_start(0) * Sqrt(2.0));--l
      piano (longitudes, latitudes, 10, array_start(1) + 90.0, array_start(0));--m
      piano (longitudes, latitudes, 11, array_start(1) + 180.0, array_start(0));--n

      Put_Line ("___ ___ ___ ___");
      Put_Line (" ");
      for i in longitudes'Range loop
         Put_Line ("LO: " & Float'Image (longitudes(i)));
         Put_Line ("LA: " & Float'Image (latitudes(i)));
         Put_Line ("___ ___ ___ ___");
         Put_Line (" ");
      end loop;

   elsif Are_Equal (array_start(4), 1.0) then
      Put_Line ("selezionato: sfera");
      -- 11 chiamate per completare le celle restanti
      sfera (longitudes, latitudes, 1, array_start(1) + 90.0, array_start(0));--b
      sfera (longitudes, latitudes, 2, array_start(1), array_start(0));--c
      sfera (longitudes, latitudes, 3, array_start(1)+ 90.0, array_start(0));--d
      sfera (longitudes, latitudes, 4, array_start(1) - 45.0, array_start(0) * Sqrt(2.0));--e
      sfera (longitudes, latitudes, 5, array_start(1) + 90.0, array_start(0));--f
      sfera (longitudes, latitudes, 6, array_start(1) - 45.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--g
      sfera (longitudes, latitudes, 7, array_start(1) - 135.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--h
      sfera (longitudes, latitudes, 8, array_start(1) + 90.0, array_start(0));--i
      sfera (longitudes, latitudes, 9, array_start(1) - 135.0, array_start(0) * Sqrt(2.0));--l
      sfera (longitudes, latitudes, 10, array_start(1) + 90.0, array_start(0));--m
      sfera (longitudes, latitudes, 11, array_start(1) + 180.0, array_start(0));--n

      Put_Line ("___ ___ ___ ___");
      Put_Line (" ");
      for i in longitudes'Range loop
         Put_Line ("LO: " & Float'Image (longitudes(i)));
         Put_Line ("LA: " & Float'Image (latitudes(i)));
         Put_Line ("___ ___ ___ ___");
         Put_Line (" ");
      end loop;


   elsif Are_Equal (array_start(4), 2.0) then
      Put_Line ("selezionato: geoide");
      vincenty (longitudes, latitudes, 1, array_start(1) + 90.0, array_start(0));--b
      vincenty (longitudes, latitudes, 2, array_start(1), array_start(0));--c
      vincenty (longitudes, latitudes, 3, array_start(1)+ 90.0, array_start(0));--d
      vincenty (longitudes, latitudes, 4, array_start(1) - 45.0, array_start(0) * Sqrt(2.0));--e
      vincenty (longitudes, latitudes, 5, array_start(1) + 90.0, array_start(0));--f
      vincenty (longitudes, latitudes, 6, array_start(1) - 45.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--g
      vincenty (longitudes, latitudes, 7, array_start(1) - 135.0, 3.0/2.0 * array_start(0) * Sqrt(2.0));--h
      vincenty (longitudes, latitudes, 8, array_start(1) + 90.0, array_start(0));--i
      vincenty (longitudes, latitudes, 9, array_start(1) - 135.0, array_start(0) * Sqrt(2.0));--l
      vincenty (longitudes, latitudes, 10, array_start(1) + 90.0, array_start(0));--m
      vincenty (longitudes, latitudes, 11, array_start(1) + 180.0, array_start(0));--n

      Put_Line ("___ ___ ___ ___");
      Put_Line (" ");
      for i in longitudes'Range loop
         Put_Line ("LO: " & Float'Image (longitudes(i)));
         Put_Line ("LA: " & Float'Image (latitudes(i)));
         Put_Line ("___ ___ ___ ___");
         Put_Line (" ");
      end loop;

   end if;

   -- making KML file
   Export_Punti_To_KML(latitudes, longitudes, "out.kml");

end Main;




