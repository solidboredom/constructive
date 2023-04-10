//BASICFUNCS.SCAD
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

function toInt(str) = 
      str=="-"?undef
      :str[0]=="-"? -1*toInt([for(i=[1:1:len(str)-1])str[i]])
    :let(d = [for (s = str) ord(s) - 48], l = len(d))
[for (i = 0, a = d[i]; i < l; i = i + 1 ,a = i<l?( 10 * a + d[i]):a) a][l-1];

function toIntList(str) =
      let(inList=split(split(str,"[")[1],"]")[0]) len(inList)<1?[]:[for(s=split(inList,","))toInt(s)];

function join( arr, sp="", _ret="", _i=0)=
   (
    _i<len(arr)?
        join( arr, sp=sp
            , _ret= str(_ret,_i==0?"":sp,arr[_i])
            , _i=_i+1 )
    :_ret
   );

function checkInside(blockOpeners,chr) =
                    ( len (blockOpeners) > 0
                      && blockOpeners[0] == "[" && chr == "]")
                   || (len(blockOpeners) > 0
                      && blockOpeners[0] == "(" && chr == ")") ? [for(i=[1:1:len(blockOpeners)-1])blockOpeners[i]]
                                              :  chr=="(" || chr=="[" ? concat([chr],blockOpeners)
                                              :  blockOpeners;

//------
function split(str, sep=" ", i=0, word="", v=[], blockOpeners=[]) =
  str ==undef ? undef
	: i == len(str) ? concat(v, word)
  : (len(blockOpeners)>0 || (str[i] != sep)) ? split(str, sep, i+1, str(word, str[i]), v
      , checkInside(blockOpeners,str[i]))
	: split(str, sep, i+1, "", concat(v, word),checkInside(blockOpeners,str[i])) ;

function splitSimple(str, sep=" ", i=0, word="", v=[]) =
  str ==undef ? undef :
	i == len(str) ? concat(v, word) :
	str[i] == sep ? split(str, sep, i+1, "", concat(v, word)) :
	split(str, sep, i+1, str(word, str[i]), v);



// some general utility functions
function debugprint(s) = search(s, []) || true;

function multV(what,byWhat=[1]) = [for (i = [ 0 : min(len(what),len(byWhat)) - 1 ]) what[i]*byWhat[i]];
function absV(vector) = [for (i = [ 0 : len(vector) - 1 ]) abs(vector[i])];
function addToV(vector,scalar=0) = [for (i = [ 0 : len(vector) - 1 ]) vector[i]+scalar];
function zeroIfUndef(what) = (what==undef)?0:what;
function falseIfUndef(what) = (what==undef)?false:what;

function zeroIfNot(boolVal)= (boolVal)?1:0;
function zeroIf(boolVal)= (boolVal)?0:1;


//returns the maximum elemnt of the i's component of a vector of vectors
// for example of a[1][3], a[2][3], a[3][3], a[4][3]
// the i parametere is only needed internally and can be ommitedin calls
// like: maximum(a,3);
function maximum(a,componentIndex, i = 0) = (i < len(a) - 1)
        ? max(a[i][componentIndex], maximum(a,componentIndex, i +1)) : a[i][componentIndex];
//just like mximum above but the minimum
function minimum(a,componentIndex, i = 0) = (i < len(a) - 1)
        ? min(a[i][componentIndex], minimum(a,componentIndex, i +1)) : a[i][componentIndex];

//adds an element to a vector
function push(vector,element)=concat(vector,[element]);
//gets last element from a vetor
function top(vector)=vector[len(vector)-1];

function ifAnyOf(where,what,sep=":")= (len([for(el=split(where,sep))
                if(str(what)==el)1])!=0)?true:false;
function anyPairMatches(setA,setB)=
      len([for(a=setA,b=setB)if(str(a)==str(b))1])!=0;

function encloses(where,what) =
      (len([for(el=split(where,","))
          if(str(what)==el)1])!=0)?true:false;
function enclosesOneOf(where,commaSeparatedListOfWhat) =
    (len([for(el=split(commaSeparatedListOfWhat,","))
            if(encloses(where,el))1])!=0)?true:false;


//---------------------------------------------------
// List helpers

/*!
  Creates a list from a range:
  range([0:2:6]) => [0,2,4,6]
*/
function range(r) = [ for(x=r) x ];

/*!
  Reverses a list:
  reverse([1,2,3]) => [3,2,1]
*/
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

/*!
  Extracts a subarray from index begin (inclusive) to end (exclusive)
  FIXME: Change name to use list instead of array?
  subarray([1,2,3,4], 1, 2) => [2,3]
*/
function subarray(list,begin=0,end=-1) = [
    let(end = end < 0 ? len(list) : end)
      for (i = [begin : 1 : end-1])
        list[i]
];

/*!
  Returns a copy of a list with the element at index i set to x
  set([1,2,3,4], 2, 5) => [1,2,5,4]
*/
function set(list, i, x) = [for (i_=[0:len(list)-1]) i == i_ ? x : list[i_]];

/*!
  Remove element from the list by index.
  remove([4,3,2,1],1) => [4,2,1]
*/
function remove(list, i) = [for (i_=[0:1:len(list)-2]) list[i_ < i ? i_ : i_ + 1]];


/*!
  Flattens a list one level:
  flatten([[0,1],[2,3]]) => [0,1,2,3]
*/
function flatten(list) = [ for (i = list, v = i) v ];

//function flatten(vec,max=inf) = [let(i=min(len(vec)-1,max)) concat(flatten(vec,i-1),vec[i])];
function splitBodies(bodyListCommaSeparated)= flatten(concat(
    [for( body=split(bodyListCommaSeparated,","))
              if(len(body)>0) [for(i=[0:1: len(split(body,"."))-1])
                            let(substep = split(body,".")[i])(i==0 //&& len(split(body,"."))>2
                              ?substep:
                            str(split(body,".")[0],".",substep))]])) ;
//str(split(body,".")[0],".",substep)]

function mapByStringKey(stringKey,objArray) = [for(i=[0:1:len(objArray)]) if(objArray[i][0] == stringKey)objArray[i]];
//function find(stringKey,arrayVect)occurencesAt(stringKey,arrayVect)

function vals(val1,val2,val3,val4,val5
			,val6,val7,val8,val9,val10)
		= ( val2==undef)
		?val1[$valPtr]
		:concat([val1],[val2]
			,[val3]
			,[val4]
			,[val5]
			,[val6]
			,[val7]
			,[val8]
			,[val9]
			,[val10])[$valPtr];

function valsFromList(list=[undef])=list[$valPtr];

function collect(val1,val2,val3,val4,val5
			,val6,val7,val8,val9,val10) =
		[for(a=concat([val1]
			,[val2]
			,[val3]
			,[val4]
			,[val5]
			,[val6]
			,[val7]
			,[val8]
			,[val9]
			,[val10])) if(a!=undef)a];
//GLOBALS.SCAD
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

// TYPEINFO.SCAD
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

function noUndefs(
         what1=true
        ,what2=true
        ,what3=true
        ,what4=true
        ,what5=true
        ,what6=true
        ,what7=true
        ,what8=true
        ,what9=true
        ,what10=true
        ,what11=true
        ,what12=true
        ) = (what1 != undef) &&
  (what2 != undef) &&
  (what3 != undef) &&
  (what4 != undef) &&
  (what5 != undef) &&
  (what6 != undef) &&
  (what7 != undef) &&
  (what8 != undef) &&
  (what9 != undef) &&
  (what10 != undef) &&
  (what11 != undef) &&
  (what12 != undef);
  function has3ElemsOrMore(what) = noUndefs(what,what[0],what[1],what[2]);
function isPlace(what)= has3ElemsOrMore(what)
              && has3ElemsOrMore(what[0])
              && has3ElemsOrMore(what[1])
              && has3ElemsOrMore(what[2])
              && has3ElemsOrMore(top(what))
              && top(what)[3]==1;

function isPlaceOrGeom(what)=  isOfGeomType(what) || isPlace(what);

//---------typesystem start--------------------------------

function _prototype_type() =  "type.typeMark";
function definePrototype(typeString,index, protoData)=
    [for (i =[0:1: len(protoData)])
      (i <len(protoData))
        ? protoData[i]
        : [len(protoData),typeString, _prototype_type(), index]
    ];
function setType(type,protoData)=
    [for (i =[0:1: len(protoData)])
      (i != type[0])
        ? protoData[i]
        : type
    ];


function lastOf(list)= list[len(list)-1];

function typeOf(obj)=
  (obj!=undef && len(obj) == 4 && obj[3]==_prototype_type())
  ? _prototype_type()
  : lastOf(obj);

function getTypeIndex(type) = lastOf(type);

function isOfType(obj,typeMark) = (obj[typeMark[0]] == typeMark );

function isOfTypeOrElse(type,obj,elseObj) =
      (obj!=undef && isOfType(obj,type))
         ? obj//[999,id]
         : elseObj;

//--------typesystem end--------------------------
//GEOMINFO.SCAD
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
//PLACEMENTS.SCAD
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

//shorthand predicates to set color or transparecy
//allows for syntactic sugar to set opaq or transparent object colors
//like: clear(green) box(side=15);
//allows for syntactic sugar to set opaq or transparent object colors
//like: clear(green) box(side=15);




module autoColor(shells=	$shellPartsForAutoColor
 										,details=$detailPartsForAutoColor,colorFor=$currentBody,custom=[])
{
  color =pickColorWithOpacity(shells,details,colorFor);
  mapped =is_undef(colorFor)?[]:mapByStringKey(colorFor,custom);
  custom= (len(mapped)>0)?mapped[0]:[];
  isCustom = len(custom)>0;
  drawColor=isCustom?custom[1]:color[0];
  remColor=$removing?0.3:(isCustom? custom[2]:color[1]);
  
  *echo("autoColor() Debug Data:",custom,shells,details,drawColor,remColor,colorFor);

  color(drawColor,remColor)children();
}
module clear (col)
{
	color($removing?undef:col,$removing?undef:0.4)children();
}
module opaq (col)
{
	color($removing?undef:col,$removing?undef:1)children();
}

//global color constants
//define Global Constnts (actuall variable) for each color aviliable here
yellow="yellow"; grey="grey"; gray="grey"; 
purple="purple"; olive="olive"; orange="orange"; 
cyan="cyan"; blue="blue"; fuchsia="fuchsia";

pink="pink"; silver="silver"; khaki="khaki"; beige="beige";
navy="navy"; brown="brown"; red="red"; 	black="black";

aqua="aqua"; gold="gold"; maroon="maroon";
green="green"; lime="lime"; teal="teal"; 


$colorNames=[ 
			yellow,	gray
			,pink	,	navy
			,silver,	brown
			,khaki,	red
			,beige,	black
			,aqua	,	green
			,gold	,	lime
			,orange,	fuchsia
			,purple,	cyan
			,maroon,	teal
			,olive,	blue
			];



//new style color system 
function findInList(list=[],elem=$currentBody) =
		let(found=[for(i=[0:len(list)-1])
						if(list[i]==elem)i])found;
						
function pickColorWithOpacity(shells=	$shellPartsForAutoColor
 										,details=$detailPartsForAutoColor
 							,part=$currentBody) =
		let(foundShell=findInList(split(is_undef(shells)?"":shells,","),part)
			 ,foundDetail=findInList(split(is_undef(details)?"":details,","),part)
			 ,ind=	(len(foundShell)>0)
							?[foundShell[0]*2,.4]
							:(len(foundDetail)>0
									?([foundDetail[0]*2+1,1])
											:[0,.4])
			)[$colorNames[ind[0]],ind[1]];
			


//picks onec olor for shells (even index)	
function shellColor(ind)=$colorNames[ind*2];
//picks one color for details inside shell (oddindex)	
function detailColor(ind)=$colorNames[ind*2+1];


// for compatibility: old style coloring system- cumbersome to use

// old style System end



/*
//example of Module to show all colors in their typical combinations
module showColors()
	pieces(len($colorNames)/2)///2)
		g(X(every(30)),TOFRONT())
	{	
	opaq(detailColor($valPtr))
		box(5);	
	clear(shellColor($valPtr))
		box(20);
}
*/
			
//ASSEMBLE.SCAD
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

module addHullStep(onlyFor=currentPart(),addOnly=true)
{
  if(!(addOnly && $removing) && partIs(onlyFor)) hull()
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
//CONSTRUCTIVE.SCAD
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
			             resize([lx,ly])
			                 offset(r=abs(rSide),$fn=fnCorner)
		 	        square([lx,ly],center=true,$fn=childFn);
		  }
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

module pressNutM3(marginUp=margin(0),marginDown=margin(0),washerOnly=false)
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
					let($margin=.75)g(turnXY(spanAllButLast()),Y(-5.5),Z(0.05)
					,chamfer(0,-1.5),cscale(.7,1,1))
						tube(d=margin(2,.5),h=margin(4.5,.5));                  
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
//NONMETRICSCRES.SCAD
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

module screw3mm(hCap=5,side=1,h=12.3)
          g(align(RESET,TOUP)
          ,Z(-hCap))
          chamfer(1,-1)
            tube(d=(5.7),h=hCap+.1,$fn=12)
          g(Z(hCap+.1-.05),chamfer(.1,-.3))
      {
        tube(d=margin(3.1,.2),h=4,$fn=12);
        tubeFast(d=margin(2,.2),h=h,$fn=12);
      }
