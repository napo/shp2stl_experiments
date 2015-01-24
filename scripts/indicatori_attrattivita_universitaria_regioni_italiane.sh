wget http://www.opencoesione.gov.it/opendata/Indicatori_regionali_20140922.zip
unzip Indicatori_regionali_20140922.zip
wget http://www.istat.it/it/files/2011/04/reg2011_g.zip
unzip reg2011_g.zip
cat > cmd.sql << EOF
CREATE VIRTUAL TABLE "reg2011" USING VirtualShape('reg2011_g','CP1252', 23032);
CREATE VIRTUAL TABLE "indicatori_regionali" USING VirtualText('Indicatori_regionali_20140922.csv',
'UTF-8', 1, POINT, NONE, ';');
CREATE TABLE "attrattivita_universitaria_regioni_italiane_2013" as SELECT "a"."ID_RIPARTIZIONE" AS "cod_reg", lower("b"."NOME_REG") AS "regione",
    "a"."VALORE" AS "indice",
    "b"."Geometry" AS "geometry"
FROM "indicatori_regionali" AS "a"
JOIN "reg2011" AS "b" ON ("a"."ID_RIPARTIZIONE"= "b"."COD_REG")
WHERE "a"."COD_INDICATORE" = 244 AND "a"."ANNO_RIFERIMENTO" = 2013
    AND "a"."ID_RIPARTIZIONE" < 21;
SELECT RecoverGeometryColumn('attrattivita_universitaria_regioni_italiane_2013','geometry',23032,'MULTIPOLYGON','XY');
.dumpshp attrattivita_universitaria_regioni_italiane_2013 geometry "attrattivita_universitaria_regioni_italiane_2013" "utf-8"
.dumpgeojson attrattivita_universitaria_regioni_italiane_2013 geometry "attrattivita_universitaria_regioni_italiane_2013.geojson"
EOF
spatialite attrattivita_universitaria_regioni_italiane.sqlite < cmd.sql
spatialite -csv attrattivita_universitaria_regioni_italiane.sqlite "select cod_reg,regione,indice from attrattivita_universitaria_regioni_italiane_2013;" > attrattivita_universitaria_regioni_italiane_2013.csv
rm *.zip
rm reg2011*
rm *.sql
#rm Indicatori_regionali_20140922.csv

