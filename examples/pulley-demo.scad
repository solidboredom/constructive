//constructive library by PPROJ (version from 05.06.2021)
//under dual-licensed under GPL 2.0  or CERN-OHL-W.*You can choose between one of them if you use this work..

//Demo of some possibilities of the
//"Constructive" Library by PPROJ (version from 05.06.2021)
include <constructive-compiled.scad>

$fn=12+12;
fastRender=true;


//the autocolor()function used below is passed this custom olor table
partColors= [
               ["screws",grey,0.4]
              ,["bearing",grey,.6]
              ,["wheel",orange,.3]
              ,["tube",red,.4]
              ,["screwMounts",yellow,.8]
              ,["hub",brown,.8]
              ,["walls",yellow,.8]

              ];


function partNameTextSelector(t=$t) =
          let(partSets=[
             "screws,bearing,tube,wheel"  ,"screws"
            ,"bearing,wheel,tube","bearing,tube"
            ]) partSets[round(t*len(partSets))];


animationMessage();

$derivedParts=["screwMounts,walls"];

assemble(partNameTextSelector())
{
 pulley();
  remove(ALL,align(TOFRONT,TOLEFT),turnXY(45))  box(70);
}

render()
assemble("hub,walls")
{
  pulley();
  remove(ALL,align(TOFRONT,TOLEFT),turnXY(45+20))  box(70);
}

module pulley(capOrNut=-1) autoColor(custom=partColors)
{
  pieces(bodyIs("wheel",2,$removing?1:2))
    g(applyTo("wheel")
      ,Z(.5+8),reflectZ(sides(-1))
      ,Z(.5-10)
      ,height(7+2)
      ,solid()
      ,toUp())
{
  pieces(fastRender?0:6)
  {
    remove(Z(-3),turnXY(span()),X(15))
            tubeFast(d=10,$fn=21);

    remove(Z(2),turnXY(span()+360/6/2),X(25))
          difference()
          {
            tubeFast(d=14,h=100,$fn=21);
            g(X(6.5),turnXY(45))
            tubeFast(d=24,h=20,$fn=4);
          }
  }
  remove("wheel")
      tubeFast(d=24,h=100);

  remove(add="bearing",Z(-.01),solid($removing)
          ,partIs("bearing",chamfer(-.5,-.5)
          ,chamfer(1,-.5)))
      tube(dOuter=28+margin(),dInner=15
              ,h=margin(7,.4));

  remove(add="tube",solid(false)
    ,Z(2+bodyIs("tube",.3,0)))
    invertFor("wheel")
      tubeFast(dInner=46-bodyIs("tube",0,.6)
              ,dOuter=50+bodyIs("tube",0,.6)
            ,h=7*2);

  add(remove="enclosureBase,walls,screwMounts"
      ,solid())
  {
    dMargin=1;

  two()
    g(vals(chamfer(-.5,-.5),UNITY)
      ,Z(every(6)-margin(0,2)/2))
    if(vals(true,!bodyIs("wheel")))
        tube(d=margin(67,3.6),h=margin(2,2+every(20)));

    g($removing?chamfer(7-.1,-.5):chamfer(10,-.5))
      tube(d=margin(46.8,8+dMargin*2));

    removeOnly()
      g(chamfer(.01,2),Z(2.5+.01))
        tube(d=margin(46.8,10+dMargin*2+3.5),h=3);
    }
}

g(Z(-4.5-margin()/2)
  ,height(margin(7+2+4-.2)),TOUP(),solid())
{
  applyTo("hub",Z(-.001))
  {
    //add()tube(dOuter=pad(15));
    add()tube(d=20,h=3.4);
    add()tube(d=24,h=3);
    add()tube(d=40,h=2.5);

}
  remove("hub,walls,enclosureBase"
    ,chamfer(.5,.5))
      tube(d=margin(15,.3));

  //*tube(dOuter=73,h=1);
  add("enclosureBase,walls"
    ,Z(-.002),solid(false)
      ,bodyIs("walls",UNITY,chamfer(.5,-3)))
    difference()
    {
      tube(dOuter=74+4,wall=bodyIs("walls",6,7)
        ,h=bodyIs("walls",heightInfo(),8.5-.001));
      g(align(bodyIs("enclosureBase",TODOWN,TOLEFT)))
          box(100);
    }
//    add(solid(false))
  //    tube(dOuter=74,wall=2);

  applyTo("screwMounts")
    screwMounts();

  applyTo("walls")
  {
    two()add(turnXY(every(90)))
      box(x=80,y=18,h=3.5);

    add(chamfer(-3,-.03),X(4)
      ,scale(1.4,1,1),solid(false))
    {
        tube(dOuter=92,wall=4);
        g(chamfer(-.5,-.03),solid(true))
          tube(dOuter=92-4,h=1);
    }
    add(chamfer(-1,-.03),X(54),solid(false))
        tube(dOuter=38,wall=3);
    addRemove(chamfer(-3,-.03),X(70),solid(false))
        tube(dOuter=18,wall=4);
    two()
      remove()
      difference()
        {
          g(align(TOLEFT,ZCENTER))
            box(100,h=100);
          tubeFast(d=84,h=9+.001);
        }
  }
  pieces(4)
    add("screws"
      ,remove="walls,enclosureBase,screwMounts"
        ,turnXY(every(90))
      ,solid(),X(39),Z(2),turnXY(30)
        ,Z(10),reflectZ(-capOrNut),Z(-11.5))
          screwM4(h=margin(20),capMargin=3,nutMargin=1);
  }
}
module screwMounts()
{
  add()pieces(4)
        g(solid(),turnXY(every(90)),X(35+4)
        ,chamfer(-1,-.01)
        ,scale(.5,.8,1))
              tube(dOuter=22+5);
}
module animationMessage()
  g(X(-10),Y(-40),turnYZ(45))
  {
      opaq(black)text(partNameTextSelector(),size=7);
      if($t==0)opaq(red)
      {
        Y(-10)text("Enable Animations in Openscad now ",size=7);
        Y(-20)text("set FPS to 0.2 and Steps to 4",size=6);
        Y(-28)text("(press Alt-V and select [Animate] first)",size=4);
      }
      else Y(-10)text("Thanks! updating every few seconds",size=6);
  }
