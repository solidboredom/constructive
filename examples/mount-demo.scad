//constructive library by PPROJ (version from 05.06.2021)
//under dual-licensed under GPL 2.0  or CERN-OHL-W.*You can choose between one of them if you use this work..

//Demo of some possibilities of the
//"Constructive" Library by PPROJ (version from 05.06.2021)

include <constructive-compiled.scad>

$fn=21;

//asks user to set Animations FPS and Steps.
// this module is included below
animationMessage();


//this function returns list of Names of Parts.
//each element of the list specifies parts to be displayed
// in one time frame of OpenScad anmation
function partNameTextSelector(t=$t) =
          let(partSets=[
             "screws,base,mountEnds"  ,"base"
            ,"screws,base"            ,"base"
            ,"base,mountEnds(count=2)","mountEnds"
            ,"mountEnds(count=1)"     ,"screws"
            ]) partSets[round(t*len(partSets))];

//this is the actual call to the library to render parts
//with names returned by the partNameTextSelector function
assemble(partNameTextSelector($t))
      mount(); //everything in this demo (but screws) is constructed
              //inside mount() module
              //which is coded below

//if you do not want animations
//you can specify part names directly instead, like:
// assemble("screws,base,mountEnds(count=1)") mount();


//the autocolor()function used below is passed this custom olor table
partColors= [
                          ["base",khaki,0.5]
                          ,["mountEnds",pink,.6]
                          ,["screws",black,.5]
                        ];

//here in this module we construct everything
module mount()
    //uses the colors above
  autoColor(custom=partColors)
    //appyTo("somename") speifies default name of the part
    //which following add(), remove(), confine() or addRemove() will affect,
    //unless specifically specified by their first argument, like in add("mountEnds")
    applyTo("base",height(margin(8)) //height() sets default if height of tube() or box()
                                    //is not given as argument of their calls.
                                    //its value is also returned by the heightInfo() function if needed.
                ,chamfer(-2,-2) //chamfers top, bottom, and/or sides of
                                //each child by an approx. 2 mm cut
                ,solid()) //solid means that children tube() and tubeFast()
                          //will produce solid rods without inner holes
{
  //most commands scan be chained like: X(10) turnXY(30) Z(40) TOUP() cube(10);
  //but also grouped under one g(....) : g(X(10),turnXY(30),Z(40),TOUP()) cube(40);
  //the result is the same, but the g(...) variant is FASTER in openscad, so it is the preferred one.

  g(Z(-4),TOUP()) //X(),Y(),Z() just move the object like
                  //translate([x,y,z])
                  //TOUP() makes the following tube() or box() stand on the
                  //coordinates point they are drawn in,instead of beeing centered on them.
                 //it works similar to the cube([10,10,10]) vs cube([10,10,10],center=true)
                //but makes it possible to align to any of the 6 cube's corners
                //TOUP() is a shorthand for align(TOUP)
  //in Fact align(TOUP,TOREAR,TORIGHT)box(10); is equivalent to cube([10,10,10]);
  // and just the box(10); is equivalent to cube([10,10,10],center=true);
  {
  //add() adds the following objects to the part specified by the parent applyTo()
  // this ones will add to the part called "base". bacause this specific add(...) is achild of an applyTo("base",....) above.
    add(stack()) //stack() stacks tube()s,box()es or both !!!!NOT SEPARATED by ";"!!!! upon each other (or sidwards if wished)
      tube(dOuter=75)
      tube(dOuter=52,h=10);
    //margin() function is used to make holes, around a part,
    //bigger size (by the margin given or default)
    //  than the part itself
    //this function :  margin(14,0.2) will return 14.2 if called inside of child of remove()
    // and only 14 if called inside of a child of add()
    //if it is used after remove(). the currrent default is..8 so marging(14) will return 14.8 or 14 coordingly
    remove(Z(-margin(0)/2),chamfer(1,1))
      tube(d=40,h=18+1);
  }
  remove(X(-15),Y(-39),Z(1),TOUP())
    //tubeFast() works faster than tube() but will ignore chamfer. it cannot chamfer.
    tubeFast(d=30,h=40);

  // two() is a shorthand for pieces(2) essentially a for($valPtr=[0:1])
      //removes from the part specified by applyTo("base")
      //AND adds to part "screws"
	two()
    //reflectY() is equivalent ot mirror([1,-1,1]) or similar
    //sides() function returns -1 for the first element and 1 for the second
    add(reflectY(sides()),Y(96),Z(4)
        ,chamfer(-.5,-.5),turnYZ()
        ,align(TOFRONT,TODOWN))
            box(y=8,x=12,h=4);
  two()
    add(turnXY(sides(90)),X(30))
      hull()
  {
    X(-3)tubeFast(d=20);
    X(50)box(side=10);
  }

  g(TOUP(),chamfer(-1,-1))
  {
    two()
        remove(add="screws",
              reflectY(sides()),Y(115-22),turnYZ(-90))
          screwM3(h=20);//screwM4 and screwM3 are part of the library
      //adds to the part specified by applyTo("base")
      //AND removes from "mountEnds"
    add(Z(-4),remove="mountEnds")
      box(x=margin(10),y=margin(224),h=margin(8));
  }
        //pieces(n) is a shorthand for
        // for ($varPtr =[0:1:n])  and a bit more
        // argInt("count",default=2) gets the value of an argument
        //  specified in the assemble() string
        //for Example argInt("someval") returns the number 123
        //for a call of assemble("mountEnds(someval=123,count=2)")mount();
  pieces(argInt("count",default=2))
    add("mountEnds"
        ,reflectY(sides()),Y(100),Z(8)
        ,turnYZ(),align(TOFRONT,TODOWN)
        ,chamfer(-1,-1),height(12))
  {
    box(y=16,x=18);
    hull()
      pieces(2)
        g(X(-3),Y(-6-vals(0,12)))
          tube(d=vals(12,12));
  }
  //this removes from "mountEnds". if part name
  //is specified as first parameter of add() or remove()
  // it overrides the default set
  //by any appyTo("whatever")
  remove("mountEnds",Z(-16),X(-3),turnYZ())
    tube(d=5,h=500);
  two()
    g(reflectX(sides()),X(37))
  {
    g(Z(4),turnYZ())
    {
      hull()two()
	       add(vals(XYZ(),XYZ(-11,0,-4)))
		        tube(dOuter=18-every(7),h=25);
      remove(add="screws",Z(-13))
        screwM4(h=25,nutMargin=10);
    }

    two()
      remove(align(vals(TOFRONT,TOREAR),TOUP)
          ,X(10),Z(8.5)
		      ,turnXZ(18),turnXY(-22)
            //every(x) will return 0,x,2*x,3*x,...,n*x
            //          for every element in pieces(n)
          ,turnYZ(40+every(100))
                  ,chamfer(-.3,-.3))
				  box(100,h=110,y=1.2);
  }
}

module animationMessage()
  g(Z(20),X(20),Y(-40),turnYZ(45))
  {
      opaq(black)text(partNameTextSelector(),size=7);
      if($t==0)opaq(red)
      {
        Y(-10)text("Enable Animations in Openscad now ",size=7);
        Y(-20)text("set FPS to 0.2 and Steps to 8",size=6);
        Y(-28)text("(press Alt-V and select [Animate] first)",size=4);
      }
      else Y(-10)text("Thanks! updating every few seconds",size=6);
  }
