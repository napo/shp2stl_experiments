var fs = require('fs');
var shp2stl = require('shp2stl');

var file = 'attrattivita_universitaria_regioni_italiane_2013';

shp2stl.shp2stl(file, 
    {
        width: 100, //in STL arbitrary units, but typically 3D printers use mm
        height: 5,
        extraBaseHeight: 0,
        extrudeBy: "valore",
        simplification: 0.5,

        binary: true,
        cutoutHoles: false,
        verbose: true,
        extrusionMode: 'straight'
    },
    function(err, stl) {
        fs.writeFileSync('attrattivita_universitaria_regioni_italiane_2013.stl',  stl);
    }
);
