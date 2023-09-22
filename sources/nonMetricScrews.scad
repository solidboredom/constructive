//NONMETRICSCRES.SCAD
//This is a part of:
//CONSTRUCTIVE LIBRARY by PPROJ (version from 05.06.2021)
//released under dual-licensed under GPL 2.0  or CERN-OHL-W.*You can choose between one of them if you use this work..

//you only need a single file: constructive-compiled.scad which
//contains all the partial files you find. you can ignore everything else..
//just include it in your code by:
//include <constructive-compiled.scad>

//if you wish to improve the library or make changes to it,
// it might be handier to use:
//include <constructive-all.scad> instead. so you do not have to recreate constructive-compiled.scad from the parts
//every time you make a change to a part of the library

module screw3mm(hCap=5,side=1,h=12.3)
          g(align(RESET,TOUP)
          ,Z(-hCap))
          chamfer(1,-1)
            tube(d=(5.7),h=hCap+.1,$fn=12)
          g(Z(hCap+.1-.05),chamfer(.1,-.3))
      {
        tube(d=margin(3.1,.2),h=4,$fn=12);
        tubeFast(d=margin(2,.2),h=h,$fn=12);
      }
