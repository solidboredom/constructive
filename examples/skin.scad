include <constructive-compiled.scad>

$skinThick=1.5; //thickness of the Skin in mm
$margin=0;


assemble()	
{
	//hull()	
															 
	addRemove(height(skin(20)), TOUP(),alignSkin(TOUP))
	{		
			
		g(X(-10),chamfer(-4,-4-1))
			 tube( d = skin(30),solid=true);

			g(X(4),chamfer(-1,-1,-5))
				box(skin(30), skin(18), h=skin(10));				
	}	
	remove(TOLEFT(TOFRONT))	box(30,h=100);		
}

