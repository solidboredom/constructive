#!/bin/bash
#../cad_devlibsV6/v6assemble.scad \
 
cat \
 sources/basicfuncs.scad \
 sources/globals.scad \
 sources/typeSystem.scad \
 sources/geomInfo.scad \
 sources/placements.scad \
 sources/assemble.scad \
 sources/constructive.scad \
 sources/metricScrews.scad \
 sources/nonMetricScrews.scad \
| grep -v '^include' > ./constructive-compiled.scad
echo "constructive-compiled.scad written."
cp constructive-compiled.scad examples/constructive-compiled.scad
cp constructive-compiled.scad cad_kickstart/constructive-compiled.scad
zip kickstart.zip cad_kickstart/*
