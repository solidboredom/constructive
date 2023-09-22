//GEOMINFO.SCAD
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

function _prototype_PackedGeomerty() =
       definePrototype("type.PackedGeometry",/*index=*/undef,
           [
              definePrototype("type.Geometry.solid",/*index*/0,
              [
              false
              ])
              ,definePrototype("type.Geometry.tube",/*index=*/1,
              [
                0/*wall*/
               ,10/*d*/
               ,10/*lx=d*/
               ,10/*ly=d*/
               ,10/*h*/
               ,undef/*d1*/
               ,undef/*d2*/
               ,false/*solid*/
               ,false//useGeom
              ])
              ,definePrototype("type.Geometry.chamfer",/*index=*/2,
              [
                  [] //-1, -2, -2, 7
                 ,[]
                 ,true //disable
              ])
              ,definePrototype("type.Geometry.align",/*index*/3,
              [
              NOCHANGE
              ])
              ,definePrototype("type.Geometry.stacking",/*index*/4,
              [
              [0,0,0]//$stackDirection=
              ,[0,0,0]//direction*abs(mergeBy),//$stackOverlap
              ,[0,0,0]//direction*abs(spaceBy) //$stackSpaceBy])
              ])
              ,definePrototype("type.Geometry.height",/*index*/5,
              [
              undef
              ])
              ,definePrototype("type.Geometry.currentPartStack",/*index*/6,
              [
              "main",undef,undef
              ])
             /*        ,definePrototype("type.Geometry.noHull",<n+1>,
              [
              false
              ])
              */

           ]);

function _prototype_geomInfo_solid() = _prototype_PackedGeomerty() [0];
function _prototype_geomInfo_Tube() = _prototype_PackedGeomerty() [1];
function _prototype_geomInfo_Chamfer() = _prototype_PackedGeomerty() [2];
function _prototype_geomInfo_Align() = _prototype_PackedGeomerty() [3];
function _prototype_geomInfo_Stacking() = _prototype_PackedGeomerty() [4];
function _prototype_geomInfo_Height() = _prototype_PackedGeomerty() [5];
function _prototype_geomInfo_currentPartStack() = _prototype_PackedGeomerty() [6];

//function _prototype_geomInfo_noHull() = _prototype_PackedGeomerty() [1];


$type_geomInfoSolid =  typeOf(_prototype_geomInfo_solid());
$type_geomInfoTube = typeOf(_prototype_geomInfo_Tube());
$type_geomInfoChamfer = typeOf(_prototype_geomInfo_Chamfer());
$type_geomInfoAlign = typeOf(_prototype_geomInfo_Align());
$type_geomInfoStacking = typeOf(_prototype_geomInfo_Stacking());
$type_geomInfoHeight = typeOf(_prototype_geomInfo_Height());
$type_currentPartStack= typeOf(_prototype_geomInfo_currentPartStack());
//$type_geomInfoNoHull =  typeOf(_prototype_geomInfo_solid());

$type_geomInfoPacked = typeOf(_prototype_PackedGeomerty());

function isOfGeomType(obj)=
        ( isOfType(obj,$type_geomInfoSolid)
                 || isOfType(obj,$type_geomInfoTube)
                 || isOfType(obj,$type_geomInfoChamfer)
                 || isOfType(obj,$type_geomInfoAlign)
                 || isOfType(obj,$type_geomInfoStacking)
                 || isOfType(obj,$type_geomInfoHeight)
                 || isOfType(obj,$type_currentPartStack)
//$type_geomInfoNoHull =  typeOf(_prototype_geomInfo_solid());
                 || isOfType(obj,$type_geomInfoPacked) );

$geomInfo= _prototype_PackedGeomerty();

function set(geom1,geom2,geom3,geom4,geom5,geom6,geom7,geom8,geom9,geom10
            ,geom11,geom12,geom13,geom14,geom15,geom16,geom17,geom18,geom19,geom20
            ,oldGeom=$geomInfo)
  = isOfType(geom1,$type_geomInfoPacked)
   ?geom1
   //"error: only unpacked geometry must be passed to geomSet"
   //:geom1;
   :[ for(member=_prototype_PackedGeomerty())
      (member == typeOf(oldGeom))
        ? member
        : isOfTypeOrElse(typeOf(member),geom1,
          isOfTypeOrElse(typeOf(member),geom2,
          isOfTypeOrElse(typeOf(member),geom3,
          isOfTypeOrElse(typeOf(member),geom4,
          isOfTypeOrElse(typeOf(member),geom5,
          isOfTypeOrElse(typeOf(member),geom6,
          isOfTypeOrElse(typeOf(member),geom7,
          isOfTypeOrElse(typeOf(member),geom8,
          isOfTypeOrElse(typeOf(member),geom9,
          isOfTypeOrElse(typeOf(member),geom10,
          isOfTypeOrElse(typeOf(member),geom11,
          isOfTypeOrElse(typeOf(member),geom12,
          isOfTypeOrElse(typeOf(member),geom13,
          isOfTypeOrElse(typeOf(member),geom14,
          isOfTypeOrElse(typeOf(member),geom15,
          isOfTypeOrElse(typeOf(member),geom16,
          isOfTypeOrElse(typeOf(member),geom17,
          isOfTypeOrElse(typeOf(member),geom18,
          isOfTypeOrElse(typeOf(member),geom19,
          isOfTypeOrElse(typeOf(member),geom20,
          oldGeom[getTypeIndex(typeOf(member))]))))))))))))))))))))
      ];

function setFromList(geomList,oldGeom=$geomInfo)
  = isOfType(geomList[0],$type_geomInfoPacked)
   ?geomList[0]
   //"error: only unpacked geometry must be passed to geomSet"
   //:geom1;
   :[ for(member=_prototype_PackedGeomerty())
      (member == typeOf(oldGeom))
        ? member
        : isOfTypeOrElse(typeOf(member),geomList[0],
          isOfTypeOrElse(typeOf(member),geomList[1],
          isOfTypeOrElse(typeOf(member),geomList[2],
          isOfTypeOrElse(typeOf(member),geomList[3],
          isOfTypeOrElse(typeOf(member),geomList[4],
          isOfTypeOrElse(typeOf(member),geomList[5],
          isOfTypeOrElse(typeOf(member),geomList[6],
          isOfTypeOrElse(typeOf(member),geomList[7],
          isOfTypeOrElse(typeOf(member),geomList[8],
          isOfTypeOrElse(typeOf(member),geomList[9],
          isOfTypeOrElse(typeOf(member),geomList[10],
          isOfTypeOrElse(typeOf(member),geomList[11],
          isOfTypeOrElse(typeOf(member),geomList[12],
          isOfTypeOrElse(typeOf(member),geomList[13],
          isOfTypeOrElse(typeOf(member),geomList[14],
          isOfTypeOrElse(typeOf(member),geomList[15],
          isOfTypeOrElse(typeOf(member),geomList[16],
          isOfTypeOrElse(typeOf(member),geomList[17],
          isOfTypeOrElse(typeOf(member),geomList[18],
          isOfTypeOrElse(typeOf(member),geomList[19],
          oldGeom[getTypeIndex(typeOf(member))]))))))))))))))))))))
      ];


function stackingInfo() = $geomInfo[getTypeIndex($type_geomInfoStacking)];
function stack(direction=TOUP,spaceBy=0,mergeBy=0,geom=$geomInfo)
    = setType($type_geomInfoStacking
		,[direction,//$stackDirection=
  	direction*abs(mergeBy),//$stackOverlap=
  	direction*abs(spaceBy)//$stackSpaceBy=])
    ]);
//	 $geomInfo=set(geom);
//	g(align(direction))
	//	children();

//different geomInfo setter Functions
function alignInfo() = $geomInfo[getTypeIndex($type_geomInfoAlign) ][0];
function align(a1=NOCHANGE,a2=NOCHANGE,a3=NOCHANGE) =
	setType($type_geomInfoAlign
		, let(vals=a1+a2+a3)
			let(changes=[vals[0+3],vals[1+3],vals[2+3]])
      let(alignment=alignInfo())
			[[ (changes[0])?vals[0]:alignment[0]
			 ,(changes[1])?vals[1]:alignment[1]
			 ,(changes[2])?vals[2]:alignment[2]]]);


function currentPartRemove() = currentPart(2);
function currentPartAdd() = currentPart(1);

function currentPart(forWhat=0) =
    let(val = $geomInfo[getTypeIndex($type_currentPartStack)])
    is_undef(val[forWhat])? val[0] : val[forWhat];

function applyTo(partName="main",add=undef,remove=undef)
            = setType($type_currentPartStack
                  ,[partName,add,remove]);
