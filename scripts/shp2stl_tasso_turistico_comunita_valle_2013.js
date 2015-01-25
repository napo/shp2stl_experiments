var shapefile 	= require('shapefile'),
	geocolor 	= require('geocolor'),
	shp2stl 	= require('shp2stl'),
	fs 			= require('fs'),
	topojson 	= require('topojson'),
	ogr2ogr 	= require('ogr2ogr'),
	brewer 		= require('colorbrewer');
	geodata		= require('geojson');

var fileRoot 	= "tasso_turistico_comunita_valle_2013",
	shpFile 	= fileRoot + ".shp",
	attribute 	= "valore",
	numBreaks 	= 9, 
	colorScheme = "Oranges"

var sourceProjection = fileRoot + ".prj";


var obj = JSON.parse(fs.readFileSync(fileRoot + ".geojson", 'utf8'));
console.log(brewer[colorScheme][numBreaks])
geojson = geocolor.jenks(obj, attribute, numBreaks, brewer[colorScheme][numBreaks], {'stroke-width':.3})
//fs.writeFileSync(fileRoot + ".geojson",  JSON.stringify(geojson));
var topology = topojson.topology(geojson.features, {"property-transform": function(feature) { return feature.properties; }});
fs.writeFileSync(fileRoot + ".topojson", JSON.stringify(topology));


shp2stl.shp2stl(shpFile, 
	{
		width: 100, //in STL arbitrary units, but typically 3D printers use mm
		height: 10,
		extrudeBy: attribute,
		sourceSRS: sourceProjection,
        	extraBaseHeight: 0,
        	simplification: 0.2,
		//filterFunction: filterFunction,
		//Google Mercator projection, since most people are used to seeing the 
		//world like this now, for better or worse
		destSRS: 'EPSG:900913' 
	},
	function(err, stl) {
		fs.writeFileSync(fileRoot + '.stl',  stl);
	}
);
