#!/bin/bash
#../cad_devlibsV6/v6assemble.scad \

cat \
 basicfuncs.scad \
 globals.scad \
 typeSystem.scad \
 geomInfo.scad \
 placements.scad \
 assemble.scad \
 constructive.scad \
 metricScrews.scad \
| grep -v '^include' > constructive-compiled.scad
echo "constructive-compiled.scad written."
