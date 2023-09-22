//BASICFUNCS.SCAD
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
