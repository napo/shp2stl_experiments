wget -c "http://www.statweb.provincia.tn.it/indicatoristrutturalisubpro/exp.aspx?idind=48&info=d&fmt=csv" -O tasso_turistico_comunita_valle.csv
wget -c http://www.territorio.provincia.tn.it/geodati/813_Comunit__di_valle_12_12_2011.zip
unzip 813_Comunit__di_valle_12_12_2011.zip
wget http://spatialreference.org/ref/epsg/25832/prj/ -O ammcva.prj
cat > cmd.sql << EOF
CREATE VIRTUAL TABLE "ammcva" USING VirtualShape('ammcva','UTF-8', 25832);
CREATE VIRTUAL TABLE "tasso_turistico_comunita_valle" USING VirtualText('tasso_turistico_comunita_valle.csv',
'UTF-8', 1, POINT, NONE, ';');
create table "tasso_turistico_comunita_valle_2013" as SELECT DISTINCT("b"."COMUNITA") AS "id", lower("b"."DESC_") AS "comunita", lower("b"."SEDE") AS "sede","a"."valore" AS "valore","b"."Geometry" AS "geometry" 
FROM "tasso_turistico_comunita_valle" AS "a"
JOIN "ammcva" AS "b" ON ("a"."codEnte"-1000 = "b"."COMUNITA") WHERE "a"."anno"=2013;
SELECT RecoverGeometryColumn('tasso_turistico_comunita_valle_2013','geometry',25832,'POLYGON','XY');
.dumpshp tasso_turistico_comunita_valle_2013 geometry "tasso_turistico_comunita_valle_2013" "utf-8"
EOF
spatialite ammcva.sqlite < cmd.sql
#ogr2ogr -f "geojson" -t_srs epsg:4326 tasso_turistico_comunita_valle_2013.geojson tasso_turistico_comunita_valle_2013.shp
spatialite -csv ammcva.sqlite "select id, comunita, sede,valore from tasso_turistico_comunita_valle_2013" > tasso_turistico_comunita_valle_2013.csv
#rm *.zip
#rm ammcva*
#rm *.sql
#rm tasso_turistico_comunita_valle.csv
