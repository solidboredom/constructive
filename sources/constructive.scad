//CONSTRUCTIVE.SCAD
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

function margin(dim=0,margin=$margin)= dim +removeExtra(margin);
function pad(dim=0,padding=$padding) = dim -padding + removeExtra(padding);


 

module runFor(conditionList=[true])
{
	$totalPieces=len(conditionList);
  valPtrs=[for(i=[0:1:(len(conditionList)-1)])
            if(conditionList[i]) i];
	for($valPtr=valPtrs)
      children();
}
module pieces(n)
{
	$totalPieces=n;
	for($valPtr=[0:1:n-1])
		children();
}
module two()
{
	$totalPieces=2;
	for($valPtr=[0:1])
		children();
}
module skipFirst(n=1)
{
  if($valPtr>=n)
		children();
}
module ifFirst(n=1)
{
  if($valPtr<n)
		children();
}
module ifLast(n=1,totalPieces=$totalPieces,valPtr=$valPtr)
{
  if(valPtr>=totalPieces-n)
		children();
}
module selectPieces(decisionList=[true],valPtr=$valPtr)
{
  if(valPtr<len(decisionList) && decisionList[valPtr])
		children();
}


$totalPieces=1;

function every(val=1,start=0,of=$totalPieces,totalPieces=$totalPieces)
	=($valPtr*of/totalPieces)*val+start;
function span(range=180,allButLast = false,totalPieces=$totalPieces)
	= ($valPtr * ((totalPieces==1)? 0:(range / (totalPieces -(allButLast?0:1)) ) ));
function spanAllButLast(range=360, totalPieces = $totalPieces)
  = span(range=range,allButLast = true,totalPieces = totalPieces);

function vRepeat(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10,shift=0) =
		let (pattern=collect(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10))
			[for(i=[shift:1:$totalPieces-1+shift])
				pattern[i%len(pattern)]][$valPtr];
function vSpread(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10) =
		 let(pattern=collect(val1,val2,val3,val4,val5,val6,val7,val8,val9,val10))
		  let(repeats=ceil($totalPieces/len(pattern)))
		  	[for(i=[0:1:$totalPieces-1])
				pattern[floor(i/repeats)]][$valPtr];

function sides(top=1,bottom,valPtr=$valPtr) = (valPtr==0?top:(bottom==undef?(-top):bottom));

$removeExtra=.5;
function removeExtra(extra=$removeExtra,what=0) = what+($removing? extra:0);
function removeFor(body,extra=$removeExtra,what=0) = bodyIs(body)?(what+($removing? extra:0)):0;
function adjustFor(body,extra=margin(0),what=0) = bodyIs(body)?(what+extra):0;


function solidInfo() = $geomInfo[getTypeIndex($type_geomInfoSolid) ][0];
function chamferInfo() = $geomInfo[getTypeIndex($type_geomInfoChamfer) ];
function heightInfo() =	$geomInfo[getTypeIndex($type_geomInfoHeight) ][0];

function solid (enable=true) = setType($type_geomInfoSolid,[enable]);
function height(h) =	setType($type_geomInfoHeight,[h]);


//sets chamfer parameters for a direct child
// objects of box() or tube()
//chamfer (up=-1) box(side=10) chamfers the top side of the box
// chamfer (down= -1) chamfersthe bottom side
// sides are chamfered to the same value  unless changed by side=xxx
// i.e. chamfer(up=-1,sides=0) to disable chamfering of sides
// chamfer (up=1) grows the side by the same amount instead of chamfering
//allowing to get chamfered conaves (inner corners between objects)
function chamfer(down,up,side,fnCorner=7,disable=false,prevInfo=chamferInfo())
	=  	let(down=disable?0:down,up=disable?0:up)
          setType($type_geomInfoChamfer,
		 (
			[for(i=[-1,1])
					((i==-1 && down==undef)||(i==1 && up==undef))
           ?[999999,0,0,0]:([i,(i==-1)
							?down
							:up
					  ,(side==undef)
							?(i==-1?down:up)
							:side
					  ,fnCorner])
					,false]));
          /*  definePrototype("type.Geometry.chamfer",2,
            [
            [-1, 20, 20, 7], [1, 20, 20, 7],false
            ]);*/


function chamferInfoUpdate(invert=false,prevInfo=chamferInfo())
	=   invert
        ?setType($type_geomInfoChamfer,
		 [for(i=[0,1])
				if(prevInfo[i]!=undef)
					[prevInfo[i][0],prevInfo[i==0?1:0][1]
					,prevInfo[i==0?1:0][1]]
					,prevInfo[3]]
			):prevInfo;
function chamferOff()=chamfer(disable=true);
function chamferOn()=chamfer(disable=false);


function uniChamfer4(bot, top, insideBot, insideTop, side, fnCorner=7, sideDiff=($skinThick*2) ) = 
			$removing
			?chamfer(insideBot, insideTop, side?( side-($skinThick*2)):undef,fnCorner = fnCorner)
			:chamfer(bot,top,
						side,	fnCorner = fnCorner);

function uniChamfer2(bot, top, side, fnCorner=7 ,sideDiff=($skinThick*2)) = 
			$removing
			?chamfer(-bot,-top, side-sideDiff,fnCorner = fnCorner)
			:chamfer( bot, top, side, fnCorner=fnCorner);

function uniChamfer(botTop,side,fnCorner=7,sideDiff=($skinThick*2)) = 
			$removing
			?chamfer(-botTop,-botTop, side-sideDiff,fnCorner = fnCorner)
			:chamfer( botTop, botTop, side               ,fnCorner = fnCorner);

function equiChamfer(botTop,side,fnCorner=7,sideDiff=($skinThick*2)) = 
			$removing
			?chamfer( botTop, botTop, side-sideDiff,fnCorner = fnCorner)
			:chamfer( botTop, botTop, side         ,fnCorner = fnCorner);


//skin functions to create Skins for Objects

$skinThick=1.5; //default wall Thickness for Skins is set to 1.5 mm
function skin(size=0,skinThick=$skinThick , walls=2,    margin=$margin) = margin(size,margin=$margin)+ skinThick*walls-($removing? (skinThick*walls):0);
function skinIf(condition,size=0, skinThick=$skinThick , walls=2, margin=$margin) = (!condition? margin(size,margin=$margin) : skin(size,skinThick,walls));
function skinParts(partList,size=0, skinThick=$skinThick , walls=2, margin=$margin) = (!partIs(partList)? margin(size,margin=$margin) : skin(size,skinThick,walls));

function alignSkin(direction = ZCENTER) = let(skinDist=margin(0,$skinThick-$margin/2)) 
															XYZ(direction==TORIGHT? skinDist : direction==TOLEFT ?-skinDist :0
															 ,direction==TOREAR? skinDist : direction==TOFRONT ?-skinDist :0
															 ,direction==TOUP? skinDist : direction==TODOWN ?-skinDist :0);

module alignSkin(direction = ZCENTER) g(alignSkin(direction));

//-----------------------------------------------------------
//changes alignment of the children objects
//normally all box() or tube() objects are centered like
//in cube(... , center=true)
// but you can change this by adding for example a toRight() predicate
//to create an object to the right of current reference point
// changed by move() or translate()
//i.e. toRight() toUp() box(side = 10);
//shothand align() function calls
function toUp(align2=NOCHANGE,align3=NOCHANGE)= align(TOUP,align2,align3);
function toLeft(align2=NOCHANGE,align3=NOCHANGE)= align(TOLEFT,align2,align3);
function toRight(align2=NOCHANGE,align3=NOCHANGE)= align(TORIGHT,align2,align3);
function toDown(align2=NOCHANGE,align3=NOCHANGE)= align(TODOWN,align2,align3);
function toFront(align2=NOCHANGE,align3=NOCHANGE)= align(TOFRONT,align2,align3);
function toRear(align2=NOCHANGE,align3=NOCHANGE)= align(TOREAR,align2,align3);
function toBehind(align2=NOCHANGE,align3=NOCHANGE)= align(TOREAR,align2,align3);

function TOUP(align2=NOCHANGE,align3=NOCHANGE) = align(TOUP,align2,align3);
function TOLEFT(align2=NOCHANGE,align3=NOCHANGE) = align(TOLEFT,align2,align3);
function TORIGHT(align2=NOCHANGE,align3=NOCHANGE) = align(TORIGHT,align2,align3);
function TODOWN(align2=NOCHANGE,align3=NOCHANGE) = align(TODOWN,align2,align3);
function TOFRONT(align2=NOCHANGE,align3=NOCHANGE) = align(TOFRONT,align2,align3);
function TOREAR(align2=NOCHANGE,align3=NOCHANGE) = align(TOREAR,align2,align3);
function TOBEHIND(align2=NOCHANGE,align3=NOCHANGE) = align(TOREAR,align2,align3);

function RESETALIGN(align2=NOCHANGE,align3=NOCHANGE) = align(RESET,align2,align3);
function XCENTER(align2=NOCHANGE,align3=NOCHANGE) = align(XCENTER,align2,align3);
function xCenter(align2=NOCHANGE,align3=NOCHANGE) = align(XCENTER,align2,align3);
function YCENTER(align2=NOCHANGE,align3=NOCHANGE) = align(YCENTER,align2,align3);
function yCenter(align2=NOCHANGE,align3=NOCHANGE) = align(YCENTER,align2,align3);
function ZCENTER(align2=NOCHANGE,align3=NOCHANGE) = align(ZCENTER,align2,align3);
function zCenter(align2=NOCHANGE,align3=NOCHANGE) = align(ZCENTER,align2,align3);

module chamfer(down,up,side,fnCorner=7,disable=false)
{
//i[0] = -1 at bottom ,1 at top; i[1] =chamferRadius)
$geomInfo = set(chamfer(down,up,side,fnCorner,disable));
children();
}

// just like tube() but for creating holes
// it is equivalent to invert() tube(...);
// *still experimental gives unexpected results in some cases*
module bore(h=$hBore,d=$d,d2=$d2)
{
	$inverted=true;

	tubeFast(h=h,d=d,d2=d2,dInner=undef,dOuter=undef,solid=true)
	children();
}

//bentStripXZ([places],wide,thick=3)
//makes a 3D strip of
// thickness thick (circle base element)
// and wideness=y,
// ONLY  TURNS/MOVES inXZ plane are allowed in placelist
// no alignment commands allowed.
//Example:
//bentStrip([X(30),turnXZ(20),X(40),turnXZ(-20),X(30)],y=10);

module bentStripXZ(places=[X(10)],y=$y,thick=3)
{
  allPlaces=concat([turnYZ()],placesOnly(places));

  g(Y(-y/2),turnYZ(-90))linear_extrude(y)
    for(limit=[0:1:(len(allPlaces)-2)])
    {
      base =multAll([for(i=[0:1:limit])allPlaces[i]]);
      hull()
      two()
        multmatrix(
          vals(base,base*allPlaces[limit+1])
                    * turnYZ(-90))
        circle(d=thick);
    }
}


module bentStripXZCamel(places=[X(10)],heights=["ERROR:need an array of heigths"],thick=3)
{
  allPlaces=concat([turnYZ()],placesOnly(places));

  g(turnYZ(-90))
    for(limit=[0:1:(len(allPlaces)-2)])
    {
      base =multAll([for(i=[0:1:limit])allPlaces[i]]);
    hull()
      two()
        multmatrix(
          vals(base,base*allPlaces[limit+1])
                    * turnYZ(-90)*reflectZ())
        linear_extrude(height=heights[limit+$valPtr])
            circle(d=thick);
    }
}



module bentStrip3D(places=[X(10)],y=$y,thick=3)
{
  allPlaces=placesOnly(places);

  g(Z(-y/2))
    for(limit=[0:1:(len(allPlaces)-2)])
    {
      base =multAll([for(i=[0:1:limit])allPlaces[i]]);
      hull()
      two()
        multmatrix(
          vals(base,base*allPlaces[limit+1]))
      linear_extrude(y)  circle(d=thick);
    }
}

//makes a 2D strip of abaselement and a list of transormations
//Example:
//bentStrip([X(30),turnXY(20),Y(40),X(80)])circle(5);

module bentStrip(places)
{
  allPlaces=concat([UNITY],placesOnly(places));

    for(limit=[0:1:(len(allPlaces)-2)])
    {
      base =multAll([for(i=[0:1:limit])allPlaces[i]]);
      hull()
      two()
        multmatrix(vals(base,base*allPlaces[limit+1]))
        children();
    }
}


function arcPoints(r,angle=90,deltaA=1,noCenter=false)=
[for(a=[-deltaA:deltaA:angle])
			(!noCenter && a<0 && angle < 360)?[0,0]:[r*cos(a),r*sin(a)]];

module arc(r,angle=90,deltaA=1,noCenter=false,wall=0)
	difference()
	{
		polygon(arcPoints(r,angle,deltaA,noCenter));
		polygon(arcPoints(r-wall,wall==0?0:angle,deltaA,noCenter));
	}



module addOffset(rOuter=1,rInner=0)
{
difference()
{
	offset(rOuter)children();
	offset(rInner)children();
}

}


//stacks children objects on to or next to each other, can also enlarge them
//them slightly in size and merge them into each other to
//make absolutely sure the resulting body is connected to one volume
module stack(direction=TOUP,spaceBy=0,mergeBy=0)
  g(stack(direction=direction,spaceBy=spaceBy
                             ,mergeBy=mergeBy
                            ,geom=$geomInfo))
		children();





module align(a1=NOCHANGE,a2=NOCHANGE,a3=NOCHANGE)
    g(align(a1,a2,a3))children();


//shorthands for align
module TOUP(shift=0) g(TOUP(),up(shift))children();
module TODOWN(shift=0) g(TODOWN(),down(shift))children();
module TOLEFT(shift=0) g(TOLEFT(),left(shift))children();
module TORIGHT(shift=0) g(TORIGHT(),right(shift))children();
module TOFRONT(shift=0) g(TOFRONT(),front(shift))children();
module TOREAR(shift=0) g(TOREAR(),behind(shift))children();
module XCENTER(shift=0) g(XCENTER(),right(shift))children();
module YCENTER(shift=0) g(YCENTER(),behind(shift))children();
module ZCENTER(shift=0) g(ZCENTER(),up(shift))children();


module toUp(shift=0) g(TOUP(),up(shift))children();
module toDown(shift=0) g(TODOWN(),down(shift))children();
module toLeft(shift=0) g(TOLEFT(),left(shift))children();
module toRight(shift=0) g(TORIGHT(),right(shift))children();
module toFront(shift=0) g(TOFRONT(),front(shift))children();
module toBehind(shift=0) g(TOBEHIND(),behind(shift))children();
module xCenter(shift=0) g(XCENTER(),right(shift))children();
module yCenter(shift=0) g(YCENTER(),behind(shift))children();
module zCenter(shift=0) g(ZCENTER(),up(shift))children();


module turnXY(angle=90) g(turnXY(angle))children();
module turnXZ(angle=90) g(turnXZ(angle))children();
module turnYZ(angle=90) g(turnYZ(angle))children();



//similar to cube() but with better human readibly parameters
//it also reacts on toRight(),toFront(), default valuse set by set() etc
// and allows stacking and chamfering
// h can be used instead of z and means the same,
// added for better interchangeability with tube()
module box(side=10,x=$x,y=$y,z,h=heightInfo())
{

z=(z==undef)?h:z;

lx=(x==undef?side:x);
ly=(y==undef?side:y);
lz=(z==undef?side:z);

translate(multV(alignInfo(),[lx,ly,lz])/2)
	scale(addToV(multV(absV(stackingInfo()[1]/*stackOverlap*/)
                        ,[1/lx,1/ly,1/lz]),1))
		doChamferBox(lx=lx,ly=ly,lz=lz)
 			cube([lx,ly,lz],center=true);

stackingTranslation=calcStackingTranslation(lx,ly,lz);
$centerLineStack=calcCenterLineStackBox(lx,ly,lz,stackingTranslation);
translate(stackingTranslation)
	children();
}
//similar to sphere() but
//it reacts to toRight(),toFront(),etc
// and allows stacking and chamfering
module ball(d=heightInfo())
{
  assert(d!=undef,"BALL():d is undefined");
  lx=d;
  ly=d;
  lz=d;

translate(multV(alignInfo(),[lx,ly,lz])/2)
	scale(addToV(multV(absV(stackingInfo()[1]/*stackOverlap*/)
                        ,[1/lx,1/ly,1/lz]),1))
    sphere(d=d);
stackingTranslation=calcStackingTranslation(lx,ly,lz);
$centerLineStack=calcCenterLineStackBox(lx,ly,lz,stackingTranslation);
translate(stackingTranslation)
	children();
}
module ballShell(d=heightInfo(),wall=wallInfo())
{
  assert(d!=undef,"BALL():d is undefined");
  lx=d;
  ly=d;
  lz=d;

translate(multV(alignInfo(),[lx,ly,lz])/2)
	difference()
	{
		 sphere(d=d);
	 	sphere(d=d-wall*2);
	}
stackingTranslation=calcStackingTranslation(lx,ly,lz);
$centerLineStack=calcCenterLineStackBox(lx,ly,lz,stackingTranslation);
translate(stackingTranslation)
	children();
}

function _priv_tube_d(d,dInner,dOuter,wall,d1) = ((dInner!=undef)
		?dInner+wall*2:
		(dOuter!=undef
			?dOuter
			:((d==undef)
				?d1
				:d)));

function tube(h=heightInfo(),d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall
	,d1=undef, d2=$d2, solid=solidInfo()) =
 	setType($type_geomInfoTube, [
	/*wall*/solid?0
				:zeroIfUndef(((dInner!=undef && dOuter!=undef)
					?((dOuter-dInner)/2)
					:wall))
	,/*d*/ _priv_tube_d(d,dInner,dOuter,wall,d1)
	,/*lx=d*/ _priv_tube_d(d,dInner,dOuter,wall,d1)
	,/*ly=d*/ _priv_tube_d(d,dInner,dOuter,wall,d1)
	,/*h*/h
	,/*d1*/d1
	,/*d2*/d2
	,/*solid*/solid
	,true]);


function tubeInfo(geom=$geomInfo) =
		geom[getTypeIndex($type_geomInfoTube)] [8]
			?geom[ getTypeIndex($type_geomInfoTube) ]
			:undef;




module ring2D(d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall,solid=solidInfo())
{
  wall = zeroIfUndef(((dInner!=undef && dOuter!=undef)
				  ?((dOuter-dInner)/2):wall));
  d = ((dInner!=undef)
		  ?dInner+wall*2:
		      (dOuter!=undef
			       ?dOuter:((d==undef)?d1:d)));

  lx=d;
  ly=d;
  lz=0;
  assert(d!=undef,"ring2D(): d is undefined");
  summingUp= falseIfUndef($summingUp)
			 && !falseIfUndef($partOfAddAfterRemoving);

  translate(multV(alignInfo(),[lx,ly,lz])/2)
  {
    difference()
	  {
		   circle(d=d);
		   if(!solid)circle(d=d-wall*2);
	  }
  }
  stackingTranslation=calcStackingTranslation(lx,ly,lz);
  $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);

  translate(stackingTranslation)
    children();
  }


//similar to cylinder() but with better human
//readibly parameters
//allows hollow tubes
//it also reacts on toRight(),toFront(), default valuse set by set() etc
// and allows stacking and chamfering

module tubeFast(h=heightInfo(),d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall,d1=undef,
		d2=$d2,solid=solidInfo(),arc=0
             ,holeStickOut=0,stickOutBothEnds=false,innerChamfer=false,inverted=undef)
{
  $inverted= inverted==undef?$inverted:inverted;
  wall = zeroIfUndef(((dInner!=undef && dOuter!=undef)
				  ?((dOuter-dInner)/2):wall));
  d = ((dInner!=undef)
		  ?dInner+wall*2:
		      (dOuter!=undef
			       ?dOuter:((d==undef)?d1:d)));

  lx=d;
  ly=d;
  assert(h!=undef,"TUBEFAST():h is undefined");
  assert(d!=undef,"TUBEFAST():d is undefined");
  lz=h;
  summingUp= falseIfUndef($summingUp)
			 && !falseIfUndef($partOfAddAfterRemoving);

  translate(multV(alignInfo(),[lx,ly,lz])/2)
	   scale(addToV(multV(absV(stackingInfo()[1]/*stackOverlap*/)
                    ,[1/lx,1/ly,1/lz]),1))
  {
    if(($inverted && $removing)
	       || (!$inverted
		         && (solid || !(summingUp
			                       && ($removing || !$beforeRemoving)
                           ))))
    difference()
	  {
		   cylinder(h, d1=d, d2=(d2==undef)?d:d2, center=true);
	     align(TORIGHT,ZCENTER)
	     {
	        if(arc>=180)
		        intersection_for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                ,chamferInfoUpdate(invert=innerChamfer))
				  box(side = max(d,(d2==undef)?0:d2)
					     ,y=max(d,(d2==undef)?0:d2)
					      +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                    ,zeroIfUndef(chamferInfo()[1][0]))
					          ,z=h+.1);

	        if(arc>0 && arc<180)
		        for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                  ,chamferInfoUpdate(invert=innerChamfer))
				              box(side=max(d,(d2==undef)?0:d2)
					                   ,y=max(d,(d2==undef)?0:d2)
					                  +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                            ,zeroIfUndef(chamferInfo()[1][0])
                ),z=h+.1);
	      }
	      if(!solid) up(stickOutBothEnds?0:holeStickOut/2)
		        cylinder(((h+.03+abs(holeStickOut)
			           +(stickOutBothEnds?abs(holeStickOut):0)))
				         ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                 ,center=true);

	      if((!solid && $inverted && $removing))
		        up(stickOutBothEnds?0:holeStickOut/2)
			           cylinder(((h+.03+abs(holeStickOut)
                          +(stickOutBothEnds?abs(holeStickOut):0)))
				                  ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                          ,center=true);
	    }
	    if(!solid && !$inverted && summingUp && $removing)
		    up(stickOutBothEnds?0:holeStickOut/2)
			     cylinder(((h+.03+abs(holeStickOut)
                +(stickOutBothEnds?abs(holeStickOut):0)))
				            ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                      ,center=true);
    }
  stackingTranslation=calcStackingTranslation(lx,ly,lz);
  $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);

  translate(stackingTranslation)
    children();
  }

module tube(h=heightInfo(),d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall,d1=undef,
		d2=$d2,solid=solidInfo(),arc=0
             ,holeStickOut=0,stickOutBothEnds=false,innerChamfer=false,inverted=undef)
{
  $inverted= inverted==undef?$inverted:inverted;
  wall = zeroIfUndef(((dInner!=undef && dOuter!=undef)
				  ?((dOuter-dInner)/2):wall));
  d = ((dInner!=undef)
		  ?dInner+wall*2:
		      (dOuter!=undef
			       ?dOuter:((d==undef)?d1:d)));

  lx=d;
  ly=d;
  assert(h!=undef,"TUBE():h is undefined");
  assert(d!=undef,"TUBE():d is undefined");
  lz=h;
  summingUp= falseIfUndef($summingUp)
			 && !falseIfUndef($partOfAddAfterRemoving);

  translate(multV(alignInfo(),[lx,ly,lz])/2)
	   scale(addToV(multV(absV(stackingInfo()[1]/*stackOverlap*/)
                    ,[1/lx,1/ly,1/lz]),1))
  {
    if(($inverted && $removing)
	       || (!$inverted
		         && (solid || !(summingUp
			                       && ($removing || !$beforeRemoving)
                           ))))
    difference()
	  {
	     doChamferTube(lx=lx, ly=ly, lz=lz)
		   cylinder(h, d1=d, d2=(d2==undef)?d:d2, center=true);
	     align(TORIGHT,ZCENTER)
	     {
	        if(arc>=180)
		        intersection_for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                ,chamferInfoUpdate(invert=innerChamfer))
				  box(side = max(d,(d2==undef)?0:d2)
					     ,y=max(d,(d2==undef)?0:d2)
					      +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                    ,zeroIfUndef(chamferInfo()[1][0]))
					          ,z=h+.1);

	        if(arc>0 && arc<180)
		       for(angle=[-180+90,arc+90])
			        g(turnXY(angle)
                //chamfer(disable=true)
                  ,chamferInfoUpdate(invert=innerChamfer))
				           box(side=max(d,(d2==undef)?0:d2)
					          ,y=max(d,(d2==undef)?0:d2)
					             +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                    ,zeroIfUndef(chamferInfo()[1][0])
                ),h=h+.1);
	      }
	       if(!solid)up(stickOutBothEnds?0:holeStickOut/2)
		        cylinder(((h+.03+abs(holeStickOut)
			           +(stickOutBothEnds?abs(holeStickOut):0)))
				         ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                 ,center=true);

	      if((!solid && $inverted && $removing))
		        up(stickOutBothEnds?0:holeStickOut/2)
			           cylinder(((h+.03+abs(holeStickOut)
                          +(stickOutBothEnds?abs(holeStickOut):0)))
				                  ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                          ,center=true);
	    }
	    if(!solid && !$inverted && summingUp && $removing)
		    up(stickOutBothEnds?0:holeStickOut/2)
			     cylinder(((h+.03+abs(holeStickOut)
                +(stickOutBothEnds?abs(holeStickOut):0)))
				            ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                      ,center=true);
    }
    stackingTranslation=calcStackingTranslation(lx,ly,lz);
    $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);
    translate(stackingTranslation)
	    children();
  }

//--------------------------------------------------
module tubeShell(h=heightInfo(),d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall
                ,solid=solidInfo(),arc=0
                ,innerChamfer=false)
{
  wall = zeroIfUndef(((dInner!=undef && dOuter!=undef)
				  ?((dOuter-dInner)/2):wall));
  d = ( dInner != undef )
		      ? dInner + wall * 2
          : ( dOuter != undef? dOuter : d);

  lx=d;
  ly=d;
  assert(h!=undef,"TUBESOFTHOLE():h is undefined");
  assert(d!=undef,"TUBESOFTHOLE():d is undefined");
  lz=h;
  summingUp= falseIfUndef($summingUp)
			 && !falseIfUndef($partOfAddAfterRemoving);

  translate(multV(alignInfo(),[lx,ly,lz])/2)
	   scale(addToV(multV(absV(stackingInfo()[1]/*stackOverlap*/)
                    ,[1/lx,1/ly,1/lz]),1))
  {
    difference()
    {
      translate([0,0,-h/2])
        linear_extrude(height=h)
          difference()
	    {
		    circle(d=d);
        if(!solid)
          circle(d=d-wall*2);
      }

      align(TORIGHT,ZCENTER)
	    {
	        if(arc>=180)
		        intersection_for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                ,chamferInfoUpdate(invert=innerChamfer))
				  box(side = d
					  ,y = d + 2*2
                 * max(zeroIfUndef(chamferInfo()[0][0])
                    ,zeroIfUndef(chamferInfo()[1][0]))
					          ,z=h+.1);

	        if(arc>0 && arc<180)
		        for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                  ,chamferInfoUpdate(invert=innerChamfer))
				              box(side = d
					               ,y=d + 2*2*max(zeroIfUndef(chamferInfo()[0][0])
                            ,zeroIfUndef(chamferInfo()[1][0])
                ),z=h+.1);
	      }
	    }
    }
  stackingTranslation=calcStackingTranslation(lx,ly,lz);
  $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);

  translate(stackingTranslation)
    children();
  }

//-------------------------------------------------

//USE THE chamfer() function instead!!
//THIS FUNCTION IS NORMALLY NOT SUPPOSED TO BE CALLED BY THE USER
//because you need the object dimensions to use ist ,
//it caries  out the chamfering when called internally by tube() or Box()
// with parameters set before by chamfer()
// it is called within tube() and box() function
//lz =height Of chamfered Object to Top )
//lx,ly= horizontal size of chamfered object
//chamferInfo set of sides to chamfer, set by the previos call to chamfer() module
module doChamfer(lx,ly,lz,chamferInfo=chamferInfo(),tube=false,box=false,childFn=$fn,tubeData=tubeInfo())
{
//i[0] = -1 at bottom ,1 at top; i[1] =chamferRadius,

//echo("doChamfer.chamferInfo:",chamferInfo);

useTubeData = (!lx && !ly && !lz && tube);
lx= !useTubeData?lx:tubeData[2];
ly= !useTubeData?ly:tubeData[3];
lz= !useTubeData?lz:tubeData[4];//=h

//echo("chamf:",chamferInfo);
disable = chamferInfo[2];

if(!disable)
	for( i = [chamferInfo[0] , chamferInfo[1]] )
{
    r=i[1];
	  rSide=i[2];
	  fnCorner=i[3];
	  up( (lz==undef )?0:((lz/2-abs(r))*i[0]))
	  mirror([0,0,i[0]>0?0:1])
	 	 linear_extrude(height=abs(r)
			,slices=1
			,scale=[(lx+2*r)/lx,(ly+2*r)/ly])
  	resize(tube?0:[lx,ly])
		  offset(r = abs( tube?0:rSide ), $fn = fnCorner)
		{
		    if((!box && !tube) || disable)
				    projection(cut=false)
					  {
               $fn=childFn;
               children();
            }
			  else if(box) square([lx,ly],center=true,$fn=childFn);
			  else if(tube) circle(d=lx,$fn=childFn);
		}
}
//addOnly()children();
if(!disable)
  intersection()
	{
		  for(i=[chamferInfo[0],chamferInfo[1]])
		  {
			    r=i[1];
			    rSide=i[2];
				  fnCorner=i[3];
	         //echo(rSide);
		      mirror([0,0,i[0]>0?0:1])
	  	        down(chamferInfo[1]==undef?lz/2:0.02)
	               linear_extrude(
                   height=(chamferInfo[1]==undef?lz:lz/2)
                            -abs(r)+.05
              ,slices=1)
			             resize(tube?0:[lx,ly])
			                 offset(r=abs(tube?0:rSide),$fn=fnCorner)
			        {
		              if((!box && !tube) )
				             projection(cut=false)
					           {
                       $fn=childFn;
                       children();
                     }
			            else if(box) square([lx,ly],center=true,$fn=childFn);
			            else if(tube) circle(d=lx,$fn=childFn);
		          }
		  }

	    if(!box && !tube)
      {
          echo(box,tube);
        	children();
      }
	}
else  children();

}
module doChamferBox(lx,ly,lz,chamferInfo=chamferInfo(),childFn=$fn)
{
//i[0] = -1 at bottom ,1 at top; i[1] =chamferRadius,

//echo("doChamfer.chamferInfo:",chamferInfo);

useTubeData =false;
lx= !useTubeData?lx:tubeData[2];
ly= !useTubeData?ly:tubeData[3];
lz= !useTubeData?lz:tubeData[4];//=h

//echo("chamf:",chamferInfo);
disable = chamferInfo[2];

if(!disable)
	for( i = [chamferInfo[0] , chamferInfo[1]] )
{
    r=i[1];
	  rSide=i[2];
	  fnCorner=i[3];
	  up( (lz==undef )?0:((lz/2-abs(r))*i[0]))
	  mirror([0,0,i[0]>0?0:1])
	 	 linear_extrude(height=abs(r)
			,slices=1
			,scale=[(lx+2*r)/lx,(ly+2*r)/ly])
  	resize([lx,ly])
		  offset(r = abs( rSide ), $fn = fnCorner)
       square([lx,ly],center=true,$fn=childFn);

}
//addOnly()children();
if(!disable)
		  for(i=[chamferInfo[0],chamferInfo[1]])
		  {
			    r=i[1];
			    rSide=i[2];
				  fnCorner=i[3];
	         //echo(rSide);
		      mirror([0,0,i[0]>0?0:1])
	  	        down(chamferInfo[1]==undef?lz/2:0.02)
	               linear_extrude(
                   height=(chamferInfo[1]==undef?lz:lz/2)
                            -abs(r)+.05
              ,slices=1)
			             resize([lx,ly])
			                 offset(r=abs(rSide),$fn=fnCorner)
		 	        square([lx,ly],center=true,$fn=childFn);
		  }
else  children();
}

module doChamferTube(lx,ly,lz,chamferInfo=chamferInfo(),childFn=$fn,tubeData=tubeInfo())
{
useTubeData = (!lx && !ly && !lz);
lx= !useTubeData?lx:tubeData[2];
ly= !useTubeData?ly:tubeData[3];
lz= !useTubeData?lz:tubeData[4];//=h

//echo("chamf:",chamferInfo);
disable = chamferInfo[2];

if(!disable)
	for( i = [chamferInfo[0] , chamferInfo[1]] )
{
    r=i[1];
	  rSide=i[2];
	  fnCorner=i[3];
	  up( (lz==undef )?0:((lz/2-abs(r))*i[0]))
	   mirror([0,0,i[0]>0?0:1])
	 	  linear_extrude(height=abs(r)
			   ,slices=1
			      ,scale=[(lx+2*r)/lx,(ly+2*r)/ly])
                circle(d=lx,$fn=childFn);

    mirror([0,0,i[0]>0?0:1])
      down(chamferInfo[1]==undef?lz/2:0.02)
       linear_extrude(
           height=(chamferInfo[1]==undef?lz:lz/2)-abs(r)+.05
            ,slices=1)
              circle(d=lx,$fn=childFn);
}
//addOnly()children();
else  children();

}
