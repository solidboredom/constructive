//PLACEMENTS.SCAD
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

//include <globals.scad>
//include <typeSystem.scad>
//include <geomInfo.scad>

//the followoing Matrix inversion funcion derived from Oscar lindes code
//Copyright (c) 2014 Oskar Linde

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.


//matrix math
function vec3(p) = len(p) < 3 ? concat(p,0) : p;
function vec4(p) = let (v3=vec3(p)) len(v3) < 4 ? concat(v3,1) : v3;
function unit(v) = v/norm(v);
function take3(v) = [v[0],v[1],v[2]];
function tail3(v) = [v[3],v[4],v[5]];
function identity3()=[[1,0,0],[0,1,0],[0,0,1]];
function identity4()=[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];
function take3(v) = [v[0],v[1],v[2]];
function tail3(v) = [v[3],v[4],v[5]];
function rotation_part(m) = [take3(m[0]),take3(m[1]),take3(m[2])];
function unit(v) = v/norm(v);
function rot_trace(m) = m[0][0] + m[1][1] + m[2][2];
function rot_cos_angle(m) = (rot_trace(m)-1)/2;


q1=[[1,0,0,0],[1,1,1,1],[0,1,2,3],[0,0,1,3]];
q1inv=[[1,0,0,0],[-3,3,-2,1],[3,-3,3,-2],[-1,1,-1,1]];
q2=[[0,0,0,0],[0,0,0,0],[0,-1,0,0],[0,0,-1,0]];
qn1i2=-q1inv*q2;
z3=[0,0,0];
z4=[0,0,0,0];

function matrix_power(m,n)= n==0? (len(m)==3?identity3():identity4()) :
        n==1 ? m : (n%2==1) ? matrix_power(m*m,floor(n/2))*m : matrix_power(m*m,n/2);

function det(m) = let(r=[for(i=[0:1:len(m)-1]) i]) det_help(m, 0, r);
// Construction indices list is inefficient, but currently there is no way to imperatively
// assign to a list element
function det_help(m, i, r) = len(r) == 0 ? 1 :
    m[len(m)-len(r)][r[i]]*det_help(m,0,remove(r,i)) - (i+1<len(r)? det_help(m, i+1, r) : 0);
function matrix_invert(m) = let(r=[for(i=[0:len(m)-1]) i]) [for(i=r) [for(j=r)
    ((i+j)%2==0 ? 1:-1) * matrix_minor(m,0,remove(r,j),remove(r,i))]] / det(m);
function matrix_minor(m,k,ri, rj) = let(len_r=len(ri)) len_r == 0 ? 1 :
    m[ri[0]][rj[k]]*matrix_minor(m,0,remove(ri,0),remove(rj,k)) - (k+1<len_r?matrix_minor(m,k+1,ri,rj) : 0);

//---------------------------------------------------
// matrix math derved from Oscar Lindes code end-----
//---------------------------------------------------


function reflect(x=-1,y=-1,z=-1,vector=[-1,-1,-1,-1])= scale(-x,-y,-z,-vector);
function reflectX(x=1)=let(y=-1,z=-1,vector=[-1,-1,-1,-1]) scale(-x,-y,-z,-vector);
function reflectY(y=1)=let(x=-1,z=-1,vector=[-1,-1,-1,-1]) scale(-x,-y,-z,-vector);
function reflectZ(z=1)=let(x=-1,y=-1,vector=[-1,-1,-1,-1]) scale(-x,-y,-z,-vector);

function cscale(x=1,y=1,z=1,vector=[1,1,1,1])=scale(x,y,z,vector);

function scale(x=1,y=1,z=1,vector=[1,1,1,1])= [ [ x*vector[0], 0, 0,0],
                [0,  y*vector[1], 0, 0],
                [0, 0,  z*vector[2],0],
                  [0,0,0,1]];


function movePlace(x=0,y=0,z=0,vector=[0,0,0,0])= [ [1, 0, 0, x+vector[0]],
      					[0, 1, 0, y+vector[1]],
       					[0, 0, 1, z+vector[2]],
       						[0,0,0,1]];
function turnPlace(xy=0,xz=0,yz=0) =[ [cos(xy)*cos(xz), -sin(xy), -sin(xz), 0],
      					[sin(xy),  cos(xy)*cos(yz), -sin(yz), 0],
       					[sin(xz),        sin(yz), cos(xz)*cos(yz), 0],
       						[0,0,0,1]];

function turnXY(angle=90)= turnPlace(xy=angle);
function turnXZ(angle=90)= turnPlace(xz=angle);
function turnYZ(angle=90)= turnPlace(yz=angle);


function XYZ(X=0,Y=0,Z=0,x=0,y=0,z=0)= [ [1, 0, 0, x+X],
                [0, 1, 0, y+Y],
                [0, 0, 1, z+Z],
                  [0,0,0,1]];

function XY(X=0,Y=0,Z=0,x=0,y=0,z=0)= XYZ(X+x,Y+y,Z+z);
function X(X=0,Y=0,Z=0,x=0,y=0,z=0)= XYZ(X+x,Y+y,Z+z);
function Y(Y=0,X=0,Z=0,x=0,y=0,z=0)= XYZ(X+x,Y+y,Z+z);
function Z(Z=0,X=0,Y=0,x=0,y=0,z=0)= XYZ(X+x,Y+y,Z+z);

function right(x=0)=X(x);
function left(x=0) =X(-x);
function up(z=0) =  Z(z);
function down(z=0) =Z(z);
function front(y=0) =Y(-y);
function behind(y=0) =Y(y);

//convineince mddules

module XYZ(x=0,y=0,z=0) g(XYZ(x,y,z))children();
module XY(x=0,y=0,z=0) g(XYZ(x,y,z))children();

module X(right=0,left=0,front=0,behind=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module Z(up=0,right=0,left=0,front=0,behind=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module Y(behind=0,right=0,left=0,front=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();


module right(right=0,left=0,front=0,behind=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module up(up=0,right=0,left=0,front=0,behind=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module front(front=0,right=0,left=0,behind=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();

module left(left=0,right=0,front=0,behind=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module behind(behind=0,right=0,left=0,front=0,up=0,down=0) g(XYZ(right-left,behind-front,up-down))children();
module down(down=0,right=0,left=0,front=0,behind=0,up=0) g(XYZ(right-left,behind-front,up-down))children();
module reflect(x=-1,y=-1,z=-1,vector=[-1,-1,-1,-1])g(reflect(x,y,z,vector))children();
module reflectX(x=1)g(reflectX(x))children();
module reflectY(y=1)g(reflectY(y))children();
module reflectZ(z=1)g(reflectZ(z))children();
module cscale(x=1,y=1,z=1,vector=[1,1,1,1])
{
  assert(x[0]==undef,str("you are using cscale() from the constructive library, not the standard scale() module. it dos the same uses a bit different syntax,to pass it a vector, use it like: scale(vector=[2,3,5.1]),otherwise just use normal scale(x,y,z) values without square braces,but you called it like the standard scale: using scale(",x,",.......)"));
  g(scale(x,y,z,vector))children();
}

//mults all mattries in a list, but if list is not a list but amatrix itself returnsthe matrix itself
function multAll(list, c = 0) =
 list[0][0]==undef? list //checks if there is no list but only matrix element then returns it
 :( c < (len(list) - 1)
 ? (list[c] * multAll(list, c + 1))
 : list[c]);

function calcStackingTranslation(lx,ly,lz,stackingInfo=stackingInfo())=
                            stackingInfo[2/*$stackSpaceBy*/]
                            +multV(stackingInfo[0/*stackDirection*/]
                                    ,[lx,ly,lz]);
function calcCenterLineStackBox(lx,ly,lz,stackingTranslation,centerLineStack=$centerLineStack)=
              push(push(centerLineStack
		          ,push([top(centerLineStack)[0]-lx/2,ly/2,lz/2],"c-start"))
		          ,concat(push([top(centerLineStack)[0]+lx/2,ly/2,lz/2]
			       + stackingTranslation,"c-end"),[-lx/2]));

function calcCenterLineStackTube(lx,ly,lz,stackingTranslation,centerLineStack=$centerLineStack)=
            let( mlOld=centerLineStack[len(centerLineStack)-1])
            push(push(centerLineStack,[mlOld[0],ly/2,lz/2,"m"])
						,push([mlOld[0],ly/2,lz/2,"m"]
              +stackingTranslation,"t-center"));

function gAll(listOfSteps=[UNITY])= multAll(listOfSteps);

function windBack(until,i=$placementStackTop)=  $placementStack[i][1]
  * ((i==1 || $placementStack[i][0]==until|| $placementStack[i-1][0]==until)
   ?  UNITY : windBack(until,i-1));

function backwards(steps1=[UNITY],steps2=[UNITY],steps3=[UNITY],steps4=[UNITY])
         = [matrix_invert(multAll(concat(steps1,steps2,steps3,steps4)))];

function	stepBack(transformation=UNITY)=
						matrix_invert(transformation);
function geomsOnly(p,geom=undef) =
        let(geomList=[for(e=p)if(isOfGeomType(e))e])
          (!geom&&len(geomList)>0)?setFromList(geomList):set(geom);

function placesOnly(p)= [for(e=p)if(isPlace(e) && !isOfGeomType(e))e];

module g(step1=UNITY,step2=UNITY,step3=UNITY,step4=UNITY,step5=UNITY
        ,step6=UNITY,step7=UNITY,step8=UNITY,step9=UNITY,step10=UNITY
        ,step11=UNITY,step12=UNITY,step13=UNITY,step14=UNITY,step15=UNITY
        ,step16=UNITY,step17=UNITY,step18=UNITY,step19=UNITY,step20=UNITY
        ,name="",geom)
{
 p=[step1,step2,step3,step4,step5
        ,step6,step7,step8,step9,step10
        ,step11,step12,step13,step14,step15
        ,step16,step17,step18,step19,step20];

place=placesOnly(p);
$geomInfo = geomsOnly(p,geom);
$placement=multAll(place);
$placementStack=concat($placementStack, [[name,$placement]]);
$placementStackTop=$placementStackTop+1;
  multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }
}

module applyTo(partName,step2=UNITY,step3=UNITY,step4=UNITY,step5=UNITY
        ,step6=UNITY,step7=UNITY,step8=UNITY,step9=UNITY,step10=UNITY
        ,step11=UNITY,step12=UNITY,step13=UNITY,step14=UNITY,step15=UNITY
        ,step16=UNITY,step17=UNITY,step18=UNITY,step19=UNITY,step20=UNITY
        ,name="",geom)
        //step1 is already occupied by the  "applyTo" parameter, so we start with the step2
  g(applyTo(partName),step2,step3,step4,step5,step6
                ,step7,step8,step9,step10
        ,step11,step12,step13,step14,step15
        ,step16,step17,step18,step19,step20
        ,name=name,geom=geom)
          children();
