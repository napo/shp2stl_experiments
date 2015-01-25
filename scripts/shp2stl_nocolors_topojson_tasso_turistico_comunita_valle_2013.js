var fs = require('fs');
var shp2stl = require('shp2stl');

var file = 'tasso_turistico_comunita_valle_2013.shp';

shp2stl.shp2stl(file, 
    {
        width: 100, //in STL arbitrary units, but typically 3D printers use mm
        height: 10,
        extraBaseHeight: 0,
        extrudeBy: "valore",
        simplification: 0.2,

        binary: true,
        cutoutHoles: false,
        verbose: true,
        extrusionMode: 'straight'
    },
    function(err, stl) {
        fs.writeFileSync('tasso_turistico_comunita_valle_2013.stl',  stl);
    }
);
