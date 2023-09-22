//METRICSCREWS.SCAD
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


module cableClampSm(hMargin=margin(0),marginUp=0,xyMargin=margin(0,1),x=4,y=5.4,h=10.6) 
	cableClamp(hMargin,marginUp,xyMargin,x,y,h)children();

module cableClamp6m(hMargin=margin(0),marginUp=0,xyMargin=margin(0,1),x=4.3,y=5.9,h=10.4) 
	cableClamp(hMargin,marginUp,xyMargin,x,y,h)children();
	
module clampScrews(hMargin=margin(0),screws=2)
	pieces(screws)g(Z(-sides($screwDist/2-3/2)),turnXZ(-90),TOUP())
	{
			tubeFast(d=margin(2.2),h=5,solid=true,$fn=15);
		Z(5-.01)tubeFast(d=margin(4),h=3+hMargin,solid=true,$fn=15);
	}
module cableClamp(hMargin=margin(0),marginUp=0,xyMargin=margin(0),x=4.3,y=5.7,h=10.3)

{
	Z((-h-hMargin)/2)linear_extrude(hMargin+h+marginUp)
	turnXY(-90)
		Y(y/2-xyMargin/2)
	{
		
		circle(d=x+xyMargin,$fn=21);
		yCube=y-x/2+xyMargin/2;
		Y(yCube/2)square([x+xyMargin,yCube],center=true);
	}
	$screwDist=h-1.4;	
	X(3) children();
}	

module pressNutM3(marginUp=margin(0),marginDown=margin(0),
				dSpike=margin(2,.5),hSpike=margin(4.5,.5),rSpike=5.5,
				washerOnly=false)
g(TOUP(),solid())
{
  opaq(grey)
  g(align(XCENTER,YCENTER)
    ,Z(margin(0,-marginUp-marginDown)))
  stack()
    tubeFast(dOuter=margin(13),h =margin(.9,marginUp+marginDown))
    if(!washerOnly)Z(-0.01)tubeFast(dOuter=margin(4),h = margin(5,marginUp)-.9
                    + marginUp);
  	pieces(4)
			g(turnXY(spanAllButLast()),Y(-rSpike),Z(0.05)
				,chamfer(0,-1.5),cscale(.7,1,1))
						tube(d=dSpike,h=hSpike);                  
}

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
module inbusScrewM3(h=10.1,nut=true
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
