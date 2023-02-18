include <../../constructive-compiled.scad>

$margin=.5;


clear(khaki)
	assemble("axlePlug","screws")
		plugs();
*assemble("lineEnd","screws")
		plugs();

module plugs(h=15.1,$marginNut=1.3)autoColor()
{
	
			applyTo("axlePlug",turnXZ(-90),Z(-56+5),TOUP(),solid())
		{				
			g(Z(-6),turnXZ(-90),Z(7),$fn=21)
				applyTo("axlePlug,lineEnd",solid(),$fn=41,TOUP()
													,Z(-14/2),X(),turnXZ(-90))
			{		
		
				g(Z(10+.1),reflectZ(),Z(7),chamfer(-.5,0),TOUP())
				{	
					add(confines())
						tube(d=22+isConfining($margin*1.5),h=h);	
					remove(confines())	
						pieces(4)
							g(turnXY(spanAllButLast()+45)
							,Y(-10+1-isConfining($margin*1.5)),ZCENTER(),turnYZ(90+40)
							,chamfer(-.5,5))box(x=4,y=26,h=5);
					two()
						remove(Z(6.6+every(10)),turnXZ(),ZCENTER(TORIGHT),chamfer(-1,-1))
							box(5,x=5,h=30);			
				
					remove(add="screws",Z(7.5),reflectZ())
					{
						Z(5-3)
							inbusScrewM3(h=10,capMargin=20,$margin=.9);
						pressNutM3(marginDown=20,$margin=$marginNut);			
					}						
				}
			}
		
			add(Z(5),chamfer(0,-3))
				tube(dOuter=29.5,h=20);
			add(Z(25+2-3))
				rotate_extrude()g(X(29/2-3),cscale(1,2,1))
				circle(d=3*2,$fn=30);		
					
			two()
				g(reflectX(sides()))
			{			
				remove(Z(15),Z(4),turnXZ(90),Z(13)
							,cscale(1,0.5,1),turnYZ(45)
							,ZCENTER(TORIGHT))
					box(20,x=30);
				remove(X(10),TORIGHT(ZCENTER))box(80,x=7);	
			}
			remove()
				assemble()
				add(Z(.5-13+25))
					tube(d=2+22/43*25,d2=24,h=43 -25);	
	}


}