//ASSEMBLE.SCAD
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

ALL="ALL"; 

//allows to use confinementOf() which assembles a confinement from Parts which are marked whith confines() marker 
//function to mark which operations constitute aconfinement,
//like in add(confines("part1"))box():
//or in in remove(confines("part2"))tube(d=2,h=10);
//then you can use
//intersection()
//	{
//		confinement()moduleWithParts();
//		assemble()moduleWithParts();
//	}
//to confine the PArts inside the confinement
function confinementPartName() = "confinement";
function isConfining(truePart=0,falsePart=0) = partIs(confinementPartName())?truePart:falsePart;
function confines(otherparts=currentPart()) = str(otherparts,",",confinementPartName() );
module confinementOf() assemble(confinementPartName())children();

//---------

function isAddingFirst()= ($summingUp
							&& !$removing   );
function expandParentsStripArgs(child,derivedParts=$derivedParts)=
          join([for(p = split(
                expandParents(child,derivedParts),","))
                stripPartArgs(p)],",");

function expandParents(child,derivedParts=$derivedParts)=
            let(parents =
            [ for(found = getGenialogyIndexForPart(child,derivedParts))
             each
            let(foundInFamily=[ for(i = [1:1:len(found)-1])found[i]])
            let(foundAt=found[0])
            [for(a=[len(foundInFamily)-1:-1:0])
                  if(foundAt && foundAt>a &&
                   (!enclosesOneOf(child,foundInFamily[a])))foundInFamily[a]
            ]])join(concat(reverse(parents),[child]),",");

function stripPartArgs(partNameWithArgs)=
    split(partNameWithArgs,"(")[0];
function stripPartName(partNameWithArgs)=
        let(rightPart=split(partNameWithArgs,"(")[1])
          (rightPart==undef?undef:split(rightPart,")")[0]);

function addArgVals(parts,valArray1,valArray2,valArray3,valArray4,valArray5
			,valArray6,valArray7,valArray8,valArray9,valArray10)=
      let(argValsArrays=collect(valArray1,valArray2,valArray3,valArray4,valArray5
    			,valArray6,valArray7,valArray8,valArray9,valArray10)
        ,partsAsArray= split(parts,",")
        ,partsCount= len(partsAsArray))
  join([for(pIndex=[0:1:partsCount-1])
        let(partName= stripPartArgs(partsAsArray[pIndex])
            ,argNames=split(stripPartName(partsAsArray[pIndex]),",")
            ,nArgMax= -1 + (argNames==undef?0:len(argNames)))
          str(partName,"("
              ,join([for(i=[0:1:nArgMax])
                    str(argNames[i],"=",argValsArrays[pIndex][i])]
                    ,",")
              ,")")
        ],",");

$currentPartArgs=undef;
function  argString(paramName,default=undef,currentArgs=$currentPartArgs)=
let(matched=[for(args = split(currentArgs,","))
    let(argParts= split(args,"="))
  if(argParts[0] == paramName) (argParts[1])])
  len(matched)>0?matched[0]:default;
function  argInt(paramName,default=undef,currentArgs=$currentPartArgs)=
let(matched=[for(args = split(currentArgs,","))
    let(argParts= split(args,"="))
  if(argParts[0] == paramName) toInt(argParts[1])])
  len(matched)>0?matched[0]:default;

function  argIntList(paramName,default=undef,currentArgs=$currentPartArgs)=
let(matched=[for(args = split(currentArgs,","))
    let(argParts= split(args,"="))
  if(argParts[0] == paramName) toIntList(argParts[1])])
  len(matched)>0?matched[0]:default;


function getGenialogyIndexForPart(child,derivedParts=$derivedParts)=
        [for(f=[0:1:len(derivedParts)-1])
        let(family=derivedParts[f])
        let(familySplit=split(family,","))
        let( foundAt=max([for(i=[len(familySplit)-1:-1:1])
          enclosesOneOf(child,split(familySplit[i],"(")[0])?i:-1]))
          concat(foundAt,familySplit)];

function currentPartIn(bodySet,standardBody
                      ,concatStadardPrefix="+",exactNamePrefix=":",excludeItPrefix="!"
                      ,currentBody=$currentBody) = ( bodySet==ALL
				|| ( ($currentBody != undef)
	  				   && (bodySet != undef)
	  				   && (let(expandedParentsCurrentBody = expandParentsStripArgs(currentBody)
                    , bodySetReplacedPlusSign = is_undef(standardBody)
                                                  ?bodySet
                                                  :join(split(bodySet,concatStadardPrefix)
                                                        ,str(standardBody,","))
                    , bodysInSet= split(bodySetReplacedPlusSign,",")
                    ,  positiveBodySet= [for(b=bodysInSet)
                                        let(sp=split(b,excludeItPrefix))
                                        if(len(sp)==1)b]
                    ,  negativeBodySet= [for(b=bodysInSet)
                                        let(sp=split(b,excludeItPrefix))
                                        if(len(sp)>1)
                                          let(syntaxError= assert(len(sp)<3
                                          ,str("Only one exclusionPrefix ''"
                                            ,excludeItPrefix
                                            ,"' allowed per body name."
                                            ," seprate prefixed excluded "
                                            ,"bodynames by commas ','"
                                              )))
                                            sp[1]]
                    //  ,debu= echo(negativeBodySet)
                  )(!encloses(negativeBodySet,currentBody) &&
                      len([for(body=positiveBodySet)
                        let(exactlyThis = reverse(split(body,exactNamePrefix))
                            ,curBody = (len(exactlyThis)>1
                                        ?currentBody
                                        :expandedParentsCurrentBody))
                        if(encloses(curBody, exactlyThis[0]))true
                      ])>0))));
//					    ? (true) : (false);
function currentPartExactIn(bodySet) = ( bodySet==ALL
				|| (	  ($currentBody != undef)
	  				   && (bodySet != undef)
	  				   && enclosesOneOf($currentBody,bodySet) )) ? (true) : (false);

function currentBodyIn(bodySet) = currentPartIn(bodySet);
function ifBodyIs(bodySet, ifTrue, ifFalse=0) = currentPartIn(bodySet)
						? ifTrue : ifFalse;
function bodyIs(bodySet, ifTrue=true, ifFalse=false) = currentPartIn(bodySet)
						? ifTrue : ifFalse;
function partIs(bodySet, ifTrue=true, ifFalse=false) = currentPartIn(bodySet)
						? ifTrue : ifFalse;
function partIsExact(bodySet, ifTrue=true, ifFalse=false) = currentPartExactIn(bodySet)
						? ifTrue : ifFalse;



module assemble(
	shells=currentPart(),details="",bodys2="",bodys3="",bodys4="",bodys5="",bodys6="",bodys7="",bodys8="",bodys9=""
  , $summingUp=true,$removing=false,$beforeRemoving=true,$derivedParts=[])
{
  
  bodyListCommaSeparated=str(	",",bodys9
  										,",",bodys8
  										,",",bodys7
  										,",",bodys6

  										,",",bodys5
  										,",",bodys4  

  										,",",bodys3
  										,",",bodys2
  										,",",details
  										,",",shells
  );

	echo("Assembling: ",splitBodies(expandParents(bodyListCommaSeparated)));
 	$shellPartsForAutoColor=shells;
 	$detailPartsForAutoColor=details;
 for(currentPartWithArgs =splitBodies(expandParents(bodyListCommaSeparated)))
 {
    $currentBody= stripPartArgs(currentPartWithArgs);
    $currentPartArgs=stripPartName(currentPartWithArgs);
	
	 difference()
	{
		children();
    union()
    {
			$removing = true;
			$beforeRemoving=false;
			children();
		}
	}
 }
}

module addHullStep(onlyFor=currentPart(),addOnly=true,removeOnly=false)
{
  if((removeOnly ||!(addOnly && $removing)) && 
  	  !(removeOnly && $removing) && 
  		partIs(onlyFor)) hull()
    {
       $hulling=true;
       children();
    }
  children();
}

module noHull(bodySet=currentPart())
{
  if(!$hulling
     || ($hulling && (bodySet!="" && !currentPartIn(bodySet,currentPart()))))children();
}

module hullIf(case=false)
{
  if(case)hull()children();
  else children();
}

module addOnly()
	if(!$removing) children();

module removeOnly()
	if($removing)children();


module encloseOnly()
	if(!$enlosing) children();



module addRemove(only,step1=UNITY,step2=UNITY,step3=UNITY,step4=UNITY,step5=UNITY
        ,step6=UNITY,step7=UNITY,step8=UNITY,step9=UNITY,step10=UNITY
        ,step11=UNITY,step12=UNITY,step13=UNITY,step14=UNITY,step15=UNITY
        ,step16=UNITY,step17=UNITY,step18=UNITY,step19=UNITY,step20=UNITY
        ,name="",geom,add,remove)
{
//////////////
p=[(isPlaceOrGeom(only)?only:UNITY),step1,step2,step3,step4,step5
			 ,step6,step7,step8,step9,step10
			 ,step11,step12,step13,step14,step15
			 ,step16,step17,step18,step19,step20];

onlyPart = ( only == undef || isPlaceOrGeom(only))
        ?currentPart($removing?2:1):only;

place=placesOnly(p);


$geomInfo= geomsOnly(p,geom);

$placement=multAll(place);
$placementStack=concat($placementStack, [[name,$placement]]);
$placementStackTop=$placementStackTop+1;

if( $currentBody == undef || onlyPart==ALL
    || (onlyPart == undef && add == undef && remove== undef)
    || currentPartIn (onlyPart)
    )
     multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }

 if( currentPartIn (add,currentPartAdd()))
    addOnly()
     multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }
if(  currentPartIn(remove,currentPartRemove()))
    removeOnly()
         multmatrix($placement)
    {
       $placement=UNITY;
       children();
    }
}

module invert($removing=$removing?false:true,$beforeRemoving=$beforeRemoving?false:true)
{
	children();
}

module invertFor(body)
{
	$removing=bodyIs(body)?($removing?false:true):$removing;
	$beforeRemoving=bodyIs(body)?($beforeRemoving?false:true):$beforeRemoving;
	children();
}

module add(to,step1=UNITY,step2=UNITY,step3=UNITY,step4=UNITY,step5=UNITY
        ,step6=UNITY,step7=UNITY,step8=UNITY,step9=UNITY,step10=UNITY
        ,step11=UNITY,step12=UNITY,step13=UNITY,step14=UNITY,step15=UNITY
        ,step16=UNITY,step17=UNITY,step18=UNITY,step19=UNITY,step20=UNITY
        ,name="",geom,remove)
{


//////////////
 p=[(isPlaceOrGeom(to)?to:UNITY),step1,step2,step3,step4,step5
        ,step6,step7,step8,step9,step10
        ,step11,step12,step13,step14,step15
        ,step16,step17,step18,step19,step20];

toPart = ( to == undef || isPlaceOrGeom(to))?currentPart():to;
place=placesOnly(p);

$geomInfo= geomsOnly(p,geom);
what=toPart;
$placement=multAll(place);
$placementStack=concat($placementStack, [[name,$placement]]);
$placementStackTop=$placementStackTop+1;

//echo("add.geomInfo:",$geomInfo);
 if( currentPartIn (toPart,currentPartAdd()))
    addOnly()     multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }
if(currentPartIn(remove,currentPartRemove()))
  removeOnly()     multmatrix($placement)
  {

    $placement=UNITY;
    children();
  }
}

module remove(from,step1=UNITY,step2=UNITY,step3=UNITY,step4=UNITY,step5=UNITY
        ,step6=UNITY,step7=UNITY,step8=UNITY,step9=UNITY,step10=UNITY
        ,step11=UNITY,step12=UNITY,step13=UNITY,step14=UNITY,step15=UNITY
        ,step16=UNITY,step17=UNITY,step18=UNITY,step19=UNITY,step20=UNITY
        ,name="",geom,add)
{

//////////////
p=[(isPlaceOrGeom(from)?from:UNITY),step1,step2,step3,step4,step5
			 ,step6,step7,step8,step9,step10
			 ,step11,step12,step13,step14,step15
			 ,step16,step17,step18,step19,step20];

fromPart = ( from == undef || isPlaceOrGeom(from))?currentPart():from;

place=placesOnly(p);


$geomInfo= geomsOnly(p,geom);

$placement=multAll(place);
$placementStack=concat($placementStack, [[name,$placement]]);
$placementStackTop=$placementStackTop+1;

if( currentPartIn (add,currentPartAdd()))
    addOnly()     multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }

if(  currentPartIn(fromPart,currentPartRemove()))
    removeOnly()     multmatrix($placement)
  {
    $placement=UNITY;
    children();
  }
}
