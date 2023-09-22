//GLOBALS.SCAD
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



$padding=.8;
$margin=.8;


$sideX=undef;
$sideY=undef;
$sideZ=undef;


$derivedParts=[];

$autoColor=[undef,1];

UNITY=        [ [1, 0, 0, 0],
      					[0, 1, 0, 0],
       					[0, 0, 1, 0],
       					[0, 0, 0, 1]];
$placement =UNITY;
infinity=1e308;
inf=infinity;


$placementStack=[["origin",UNITY]];
$placementStackTop=0;

$summingUp=false;

$hulling=false;
$removing=false;
$removingAgain=false;
$addingAgain=false;
$partOfAddAfterRemoving=false;
$inverted=false;
$beforeRemoving=true;
$enclosing=false;
$currentBody=undef;

$valPtr=0;

$arc=undef;
$x=undef;
$y=undef;
$h=undef;
$d=undef;
$d2=undef;
$dInner=undef;
$dOuter=undef;
$wall=0;
$solid=false;
$hBore=undef;


//used to track transformations made by move() to be still
// able to use  connect()
$centerLineStack=[[0,0,0,"m"]];



//global constants which an be used with the align() function
//like align(TORIGHT,TOUP) box(side=10);
// instead of toRight() toUp() box(side=10);
RESET=[0,0,0,1,1,1];
NOCHANGE=[0,0,0,0,0,0];

XCENTER=[0,0,0,1,0,0];
YCENTER=[0,0,0,0,1,0];
ZCENTER=[0,0,0,0,0,1];

TORIGHT=[1,0,0,1,0,0];
TOREAR=  [0,1,0,0,1,0];
TOBEHIND=[0,1,0,0,1,0];

TOUP=[0,0,1,0,0,1];
TODOWN=-1* TOUP;
TOLEFT=-1* TORIGHT;
TOFRONT=-1* TOBEHIND;


/***internal global variables end************************/

