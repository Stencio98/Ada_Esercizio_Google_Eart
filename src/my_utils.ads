-- file .ads
package my_utils is
   subtype Element is Float;

   -- start parameters (5)
   type ArrayOfFloat_5 is array (0 .. 4) of Element;
   -- 0: distance
   -- 1: direzione in gradi rispetto al nord
   -- 2: punto di origine (latitudine y)
   -- 3: punto di origine (longitudine x)
   -- 4: modello (0 --> piatto; 1 --> sferico; 2 --> geoide)

   -- store 12 parameters (2 arrays x & y)
   type ArrayOfFloat_12 is array (0 .. 11) of Element;

   -- start parameters
   array_start : ArrayOfFloat_5;

   --latitude & longitude
   latitudes : ArrayOfFloat_12;
   longitudes : ArrayOfFloat_12;
   -- equals float
   function Are_Equal (A, B : Float) return Boolean;

   procedure Start (A : in out ArrayOffloat_5);

   procedure piano (LO, LA : in out ArrayOfFloat_12; i: Integer; angle: Float; distance_miles: Float);

   procedure sfera (LO, LA : in out ArrayOfFloat_12; i: Integer; angle: Float; distance_miles: Float);

   procedure vincenty (LO, LA : in out ArrayOfFloat_12; i: Integer; angle_input : Float; distance_miles : Float);

   --procedure geoide (LO, LA: in out ArrayOfFloat_12; i: Integer; angle: Float; distance_miles: Float);

   procedure Export_Punti_To_KML (Latitudes: in ArrayOfFloat_12; Longitudes : in ArrayOfFloat_12; File_Name  : in String);

end my_utils;
