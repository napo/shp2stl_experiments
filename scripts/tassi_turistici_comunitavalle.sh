wget "http://www.statweb.provincia.tn.it/indicatoristrutturalisubpro/exp.aspx?idind=48&info=d&fmt=csv" -O tasso_turistico_comunita_valle.csv
wget http://www.territorio.provincia.tn.it/geodati/813_Comunit__di_valle_12_12_2011.zip
unzip 813_Comunit__di_valle_12_12_2011.zip
wget http://spatialreference.org/ref/epsg/25832/prj/ -O ammcva.prj
spatialite_tool -i -shp ammcva -d ammcva.sqlite -t ammcva -c cp1252 -g geometry -s 25832
cat tasso_turistico_comunita_valle.csv | sed "s/;/|/g" > tmp.csv
cat > cmd.sql << EOF
CREATE VIRTUAL TABLE tasso_turistico
USING VirtualText('tasso_turistico_comunita_valle.csv',
'UTF-8', 1, POINT, NONE, ';');
CREATE TABLE geometrie_turismo2013 as SELECT "a"."COMUNITA" AS "comunita", "a"."DESC_" AS "desc",
    "a"."SEDE" AS "SEDE", 
    "b"."anno" AS "anno", "b"."codEnte"-1000 AS "idcodEnte",
    "b"."valore" AS "valore"
FROM "ammcva" AS "a"
JOIN "tasso_turistico" AS "b" ON ("a"."COMUNITA" = "idcodEnte") where anno=2013;
delete from geometrie_turismo2013;
SELECT AddGeometryColumn('geometrie_turismo2013', 'geometry',25832, 'POLYGON', 'XY');
INSERT INTO geometrie_turismo2013
SELECT ammcva.comunita, ammcva.desc_, ammcva.sede, tasso_turistico.anno, tasso_turistico.codEnte-1000 as idcodEnte, tasso_turistico.valore, ammcva.geometry
FROM tasso_turistico JOIN ammcva ON ammcva.comunita = idcodEnte where anno=2013;
EOF
spatialite ammcva.sqlite < cmd.sql
spatialite_tool -e -shp turismo2013 -d ammcva.sqlite -t geometrie_turismo2013 -g geometry -c CP1252
