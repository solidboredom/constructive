
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
			
