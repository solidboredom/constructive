# Basic introduction to openscad with the <u>Constructive</u> library for a new OpenScad user

--------------------
A **basic introduction** (especially if you are new to Openscad )
it explains Constructive Syntax for main Building blocks, like tube(), box() or bentStrip() and their placement and alignment in space like stack() , align(),  X(),Y(),Z() or turnXZ() 

--- 
see also:
[Part II tutorial](./tutorials/tutorial-partII.md) shows somee basic object modification like reflectX(), cScale() ,or colors and then goes on to explain, how to work with sets of similar objects without for(), with: pieces(), span(), vals(), selectPieces(), etc..

[Part III tutorial](./tutorials/tutorial-partIII.md) shows more advanced Features like grouping commands into a g() group, working with Parts, and combinig them into Assembly 

----

The easiest way to try out the Library is to download the [kickstart.zip](https://github.com/solidboredom/constructive/blob/main/kickstart.zip)

----------------

> NOTE: To run all code examples from this tutorial you will need only Openscad and
> a single file: constructive-compiled.scad put in the same Fodler as your own .scad files.
> the easiest way to start is to download the [kickstart.zip](https://github.com/solidboredom/constructive/blob/main/kickstart.zip)
> and then extract both files contained in it into same folder. Then you can open the tryExamples.scad from this folder with OpenScad, and then use this file to try the code Examples from the Tutorial, or anything else you like. Just Pessing F5 in Openscad to see the Results.

---

## Basic building blocks

here are the basic buildng blocks box(),tube() and ball()
they are very similar to OpenScad's native cube(),cylinder() and sphere() but have simpler, less mathematical argument syntax and additionally allow for powerful Constructive features introduced later .
There are other more advanced blocks and features, such as bentStripXZ() or applying of chamfer(), which have no vanilla Openscad equivalent, the will be explained later
#### Basic building block : box()

```.scad
include <constructive-compiled.scad>

box(side=10);
```

this will create a box, all box sides of side=10 mm and with its center around center of coordinates.
same as cube([10,10,10],center=true) in vanilla Openscad syntax.

![screen](./tutorial-images/box1.png)  

---

> NOTE: for people used to classic vanilla openscad:
> unless specified differently by TOUP(),TORIGHT(),align(...), etc.(which are explained below) all box(), tube() and other "constructive" bodies will be centered around center of coordinates, like when using ",center=true)" parameter in valilla Openscad.

---

in constructive syntax you can also ommit the parameter name for the 'side=' parameter.
so

```.scad
include <constructive-compiled.scad>

box(10);
```

does exaclty the same as box(side=10);

---

```.scad
include <constructive-compiled.scad>

box(10,h=15);
```

just like above, a box with all sides of 10, but a height of h=15.
same as cube([10,10,15],center=true) in vanilla Openscad syntax.

![screen](./tutorial-images/box2.png)  

---

```.scad
include <constructive-compiled.scad>

box(10,y=25,h=15);
```

like above,  a box with all sides of 10, but a height of h=15 and a depth of y=25.
same as cube([10,25,15],center=true) in vanilla Openscad syntax.

![screen](./tutorial-images/box3.png)
---

```.scad
include <constructive-compiled.scad>

box(10,x=35,h=15);
```

a cube with a side of 10 , but x=35 and h=15, so that only the remaining unset y will get the value of 10: y=10
same as cube([35,15,15],center=true) in vanilla Openscad syntax.

![screen](./tutorial-images/box4.png)
---

> NOTE: all the examples here willl work in openscads preview (F5-Key), but later you might need to render them correctly, when (pressing the F6-key) or exporting them as .stl, you will need
> to add one more simple line to your code to acheive that. This line is called "a main() block". It is given and described at the very end of this tutorial

---
#### Basic building block: ball(diameter)
creates a ball (a sphere() in vanilla OpenScad of given diameter ) it works just the same as sphere()
but it also correctly reacts on align(), stack() and other Constructive concepts described below. out of the box. so it is preferred to use ball(d) instead of sphere()

```.scad

include <constructive-compiled.scad>
ball(10);

```
![screen](./tutorial-images/ball.png)

---

#### Basic building block: tube()

```.scad
include <constructive-compiled.scad>

tube(d=10,h=20,wall=2.5);  
```

creates a tube with outer Diameter of 10,a wall of 2.5 and height of 20mm
![screen](./tutorial-images/tube1.png)  

---

```.scad
include <constructive-compiled.scad>

tube(dOuter=45,dInner=25,h=20);  
```

just like above, but instead of specifing just d and wall thickness it is possible to specify dInner and dOuter.

![screen](./tutorial-images/tube2.png)  ---

```.scad
include <constructive-compiled.scad>

tube(d=10,h=20,solid=true);
```

creates a solid rod of d=10 in diameter and height of h=20, the solid=true argument is oneof the ways to make the rod solid,skipping the inner hole, which would turn it into a proper tube;
in vanilla Openscad syntax this would be cylinder(d=10,h=20);
![screen](./tutorial-images/tube3.png)  

----
## Moving and turning the Object around (also called translation and transfomation):
---
#### moving:

the first box  with the side of (4 mm) is moved by 5mm to the right
the second box with a 8mm side is moved by 13mm to the bottom since the negative Z(-13)

```.scad
include <constructive-compiled.scad>

X(5) box(4);
Z(-13) box(8);
```

![screen](./tutorial-images/move1.png)

---

#### Applying several Movements to one Object:

here we have several boxes scattered around. The first and the biggest box  of 15 mm sides is moved by 8mm to the right by X(8) then by 20mm to the front and by 30 mm up

```.scad
include <constructive-compiled.scad>

X(8) Y(-20) Z(-30) box(15);
X(5) box(4);
Z(13) box(5);
Y(-24) box(3);
```

![screen](./tutorial-images/move2.png)

---

## Turning Objects :

```.scad
include <constructive-compiled.scad>

turnXY(45) box(10);
```

this turns th boxby 45 degrees in the horizontal(XY) plane

![screen](./tutorial-images/turn1.png)

---

Turns are also possible around each of the other two axes: turnXY(), turnXZ() and turnYZ(), and you of course can apply several different turns to the same objects

```.scad
include <constructive-compiled.scad>

turnXZ(-30) turnXY(45) box(10);
```

![screen](./tutorial-images/turn2.png)
---

You can combine turns and moves as you wish:

```.scad
include <constructive-compiled.scad>

turnXZ(-30) X(5) Y(10) turnXY(45) Z(15) box(10);
```

![screen](./tutorial-images/turn3.png)

this will move the box up by 10 mm, turn it by 45 degrees in the horizontal(XY) plane, and the move it 10 in y axis and 5 to the right and then turn thewhole thig around XZ axis by -30 degrees

> NOTE: the sequence in which you apply turns and moves does matter.
>
> Bacause the
>
> turnXZ(30) X(20) box(10);
>
> first movess the box by 20 mm and then rotates the whole arrangement around the center of coordinates, whereas the
>  X(20) turnXZ(30) box(10);
>
> first rotates the box around its own axis and then moves it to the right by 20 mm
> you can try it by yourself , just not forget the
>
> include <constructive-compiled.scad>
>
> at the beginnning

---------------
----
### Advanced body Positioning: aligning a body relative to its coordinates:

instead of moving the body around by using X() Y() or Z() it is very often handier to just specify that it needs to be aligned so that,
its specific corner or side touches acorner or side of another body, and let the Constructive do the moving. (This is called "creating a constaint" in a traditional CAD)
here is an example:

```.scad
include <constructive-compiled.scad>

TOUP()box(10);
TODOWN()tube(d=10,h=10,solid=true);
```

the alignment moves the body around,so that not its center, but one of it's corners, or a center of a choosen side of the body is place in the coordinates, where it is drawn.
 here the box() is aligned UP, for the complete body to be drown the top side of the coordinates center,just touching it with its bottom sides center,
  and the tube is aligned Down to be to the Bottom of coordinates center, just touching it with its top sides center

![screen](./tutorial-images/align1.png)

---

there are alignment commands for each dimension, not only TOUP() and TODOWN() but also TORIGHT() TOLEFT() for the X and TOREAR() and TOFRONT() for the Y axis

```.scad
include <constructive-compiled.scad>

TORIGHT() box(10);
TOLEFT() box(5,y=30);
```

![screen](./tutorial-images/align2.png)

---

you can combine them like here

```.scad
include <constructive-compiled.scad>

TORIGHT() TOREAR() TOUP() box(5);
TODOWN() tube(d=20,h=20,wall=3);
```

![screen](./tutorial-images/align3.png)

the TORIGHT() TOREAR() TOUP()  alignment is the default alignment for cube in vanilla Openscad, so that its cube([5,5,5]); will acheive the same as
TORIGHT() TOREAR() TOUP() box(5); in constructives dialect,.
why use the longer vesion?
Bacause it is possiible to assign alignement over one axis to a block of several bodies,and then specify alignment on another axis to a specific body, like here:

```.scad
include <constructive-compiled.scad>
TOUP()
{
    TOLEFT()box(20);
    TORIGHT()box(10);
}

TODOWN()TOFRONT()tube(d=20,h=10,wall=2);
```

![screen](./tutorial-images/align4.png)
---

NOTE that  it is possible and in some cases needed to combinde several following align statements like TOUP() TORIGHT() into a  shorter single align(...) command:
align(TORIGHT, TOREAR, TOUP) box(5); does the same  as the TORIGHT() TOREAR() TOUP() box(5); from above.
in fact, TOUP() is only as hort for align(TOUP) and TORIGHT() for align (TORIGHT), etc

---

#### Stacking Bodies on top or to side

When youhabe similar bodies stacked on top each other, or to a side, than in vanilla openscad you would have to move each body to the exact postion it needs to be, not so with Constructive.
you just stack Bodies like that, just set the direction of Stacking:

> IMPORTANT: pleae pay attention there are NO SEMICOLONS between stacked parts.
> his looksvery unusual, but this is essential for stack() to work. if stack is not working properly, usually there is a semicolon between stacked bodies somewhere:

```.scad
include <constructive-compiled.scad>
TOUP() stack(TOUP)
    box(20)
    box(15)
    box(10,h=30)
    tube(d=10,wall=2,h=20)
    tube(d=5,h=10,solid=true)
    turnXY(45)box(5);
```

![screen](./tutorial-images/stack1.png)

> note please donot forget the TOUP()alignment if youare using the stack(TOUP) this will align each individual body you ae stacking in the same direction with the Stacking, only the then the Bodies are Stacked properly on top of each other.

---
----
## advanced building blocks
---

#### advanced building block: chamfer() :  tube()

you can chamfer the tubes up and bottom sides just like the we did to the box(), or even add skirts.

```.scad
include <constructive-compiled.scad>

chamfer(4,-2) tube(d=10,h=20,wall=2.5);  
```

Chamfering with the chamfer() is only possible on the outer surface of the tube for now.
To chamfer the hole inside a tube eith the current version of Constructive, it needs a little trick, we will return to the trick in another tutorial.   

![screen](./tutorial-images/tube1c.png)


#### advanced building block: Chamfer() : box()

You can easily chamfer the sides of a box() , just use chamfer(down,up,side) to set by how mamy millimeters the bottom,top, or side edges of the cube need to be cut, use negatve numbers to indicace we want to remove material (and not to add a skirt)

```.scad
include <constructive-compiled.scad>

chamfer(-1,-2,-3)box(10,x=35,h=15);
```

![screen](./tutorial-images/box5.png)

---

if you want smoother rounded vertical edges set fnCorner parameter to a higher value thanits default fnCorner=7

```.scad
include <constructive-compiled.scad>

chamfer(-1,-2,-3,fnCorner=60) box(10,x=35,h=15);
```

![screen](./tutorial-images/box6.png)

---

or make them straight with fncorner=2

```.scad
include <constructive-compiled.scad>

chamfer(-1,-2,-3,fnCorner=2) box(10,x=35,h=15);
```

or anything in between with value you choose

![screen](./tutorial-images/box7.png)
---

or to chamfer only the sides the top,but notbottom, or otherwise  

```.scad
include <constructive-compiled.scad>

chamfer(0,-2,-3) box(10,x=35,h=15);
```

or anything in between with value you choose

![screen](./tutorial-images/box8.png)

---

   skirt
 you can alsocreate a skirt  at the top or bottom using chamfer() but with a positive parameter
 for coording side

```.scad
include <constructive-compiled.scad>

chamfer(2,-2) box(10,x=35,h=15);
```

![screen](./tutorial-images/box9.png)

---

#### advanced building block: bentStripXZ()

```.scad
include <constructive-compiled.scad>

bentStripXZ(places=[ X(20),turnXZ(60),X(20),turnXZ(-45),X(10) ],
             y=5, thick=10);
```

this will create a 3D strip by moving a cylindcal base element of height y=5 accouring to command-list  in its first argument places=[ ... ]

![screen](./partII-images/bentStripXZ.png)  

> NOTE: ONLY TURNS/MOVES in XZ plane are allowed inside places parameter
> no alignment commands, like TOUP() or TOLEFT() are allowed in cuttent version.



#### Advanced stacking Example

here is a very similar Example, but we stack horizonally, and also apply chamfer() to remove 2 mm form the top andbottom sides edges, just to make them look better:

```.scad
include <constructive-compiled.scad>
chamfer(-2,-2)TORIGHT()stack(TORIGHT)
    box(20)
    box(15)
    box(10,h=30)
    tube(d=10,wall=2,h=20)
    tube(d=5,h=10,solid=true)
    turnXY(45)box(5);
```

![screen](./tutorial-images/stack2.png)

> note please donot forget the TOUP()alignment if youare using the stack(TOUP) this will align each individual body you ae stacking in the same direction with the Stacking, only the then the Bodies are Stacked properly on top of each other.

---------------------

##  Main() block:

 to be able to render the the above examples with F6 or export their .stl
 you will need to wrap your code with the so called main () block statement.
 you just do it by
 adding the assemble()add() line at the top of the code, just after the include line :

```
include <constructive-compiled.scad>

assemble() add()
```

 and then wrapping the rest of your own code as code block, using curly braces:

```
include <constructive-compiled.scad>

assemble() add()
{
 .... your code here.....
}
```

so for example, a programm:

```
include <constructive-compiled.scad>

chamfer(-2,-2)TORIGHT()stack(TORIGHT)
    box(20)
    box(15)
    box(10,h=30)
    tube(d=10,wall=2,h=20)
    tube(d=5,h=10,solid=true)
    turnXY(45)box(5);

TODOWN()TOREAR()tube(d=20,h=10,wall=2);
```

will become:

```
include <constructive-compiled.scad>

assemble() add()
{
chamfer(-2,-2)TORIGHT()stack(TORIGHT)
    box(20)
    box(15)
    box(10,h=30)
    tube(d=10,wall=2,h=20)
    tube(d=5,h=10,solid=true)
    turnXY(45)box(5);

TODOWN()TOREAR()tube(d=20,h=10,wall=2);
}
```

the result looks just the same like this and renders well with (F6-Key) as well as F5
![screen](./tutorial-images/mainblock.png)

---

see also:

[Part II tutorial](./tutorials/tutorial-partII.md) shows somee basic object modification like reflectX(), cScale() ,or colors and then goes on to explain, how to work with sets of similar objects without for(), with: pieces(), span(), vals(), selectPieces(), etc..

[Part III tutorial](./tutorials/tutorial-partIII.md) shows more advanced Features like grouping commands into a g() group, working with Parts, and combinig them into Assembly 

For a more advanced use also look at the explanations inside the example below

https://github.com/solidboredom/constructive/blob/main/examples/mount-demo.scad

there is also another Example at:

https://github.com/solidboredom/constructive/blob/main/examples/pulley-demo.scad


The easiest way to try out the Library is to download the [kickstart.zip](https://github.com/solidboredom/constructive/blob/main/kickstart.zip)



that was it! now you can render and export STLs
