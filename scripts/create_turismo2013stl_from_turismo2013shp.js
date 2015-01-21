var fs = require('fs');
var shp2stl = require('shp2stl');

var file = 'turismo2013.shp';

shp2stl.shp2stl(file, 
    {
        width: 100, //in STL arbitrary units, but typically 3D printers use mm
        height: 10,
        extraBaseHeight: 0,
        extrudeBy: "valore",
        simplification: 0.5,

        binary: true,
        cutoutHoles: false,
        verbose: true,
        extrusionMode: 'straight'
    },
    function(err, stl) {
        fs.writeFileSync('turismotrentino2013.stl',  stl);
    }
);
