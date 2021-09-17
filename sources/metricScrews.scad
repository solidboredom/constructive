//METRICSCREWS.SCAD
//This is a part of:
//CONSTRUCTIVE LIBRARY by PPROJ (version from 05.06.2021)
//released under General Public License version 2.

//you only need a single file: constructive-compiled.scad which
//contains all the partial files you find. you can ignore everything else..
//just include it in your code by:
//include <constructive-compiled.scad>

//if you wish to improve the library or make changes to it,
// it might be handier to use:
//include <constructive-all.scad> instead. so you do not have to recreate constructive-compiled.scad from the parts
//every time you make a change to a part of the library


module pressNutM4(marginUp=margin(0),marginDown=margin(0))
{
  opaq(grey)
  g(align(XCENTER,YCENTER)
    ,Z(margin(0,-marginUp-marginDown)))
  stack()
    tubeFast(dOuter=margin(15-4.4*0),h =margin(.7,marginUp+marginDown))
    tubeFast(dOuter=margin(5.1),h = margin(6,marginUp)-.7
                    + marginUp);
}


module nutM4(nutMargin=.4,dMargin=margin(0))
clear(grey)
{
  g(Z(3.1),align(TODOWN,XCENTER,YCENTER),solid())
      tubeFast(d=8.1+dMargin
        ,h=margin(3.1,nutMargin),$fn=6);
}

module nutM3(h=margin(3.8),d=margin(6.2),align=TOUP())
  g(align)tubeFast(d=d,h=h,$fn=6);

module screwM3(h=10.1,nut=true
              ,capMargin=3.8)
clear(grey)
{
    g(align(TOUP,XCENTER,YCENTER),solid())
    {
      tubeFast(dOuter = margin(3),h = h-2.1+.02);
      Z(h-2.1)
        tubeFast(d = margin(5.5),h = 2.1+.02);
      Z(h-.02)
        tubeFast(d=margin(5.5)
                ,wall=2
                ,h = .01+removeExtra(capMargin));
    }
  children();
}
module screwM4(h=16,nut=true
              ,capMargin=3.8,nutMargin=.4,noNut=false)
clear(grey)
{
    if(!noNut)
      g(align(TODOWN,XCENTER,YCENTER),
          Z(3.1),solid())
      tubeFast(d=margin(8.1)
        ,h=margin(3.1,nutMargin),$fn=6);
    g(align(TOUP,XCENTER,YCENTER),solid())
    {
      tubeFast(dOuter = margin(4),h = h-2.4+.02);
      Z(h-2.4)
        tubeFast(d2=7.5,d = margin(4),h = 2.4+.02);
      Z(h-.02)
        tubeFast(d=margin(8.2)
                ,wall=2
                ,h = .01+removeExtra(capMargin));
    }
    children();
}
