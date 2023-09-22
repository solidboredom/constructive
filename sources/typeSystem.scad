// TYPEINFO.SCAD
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
