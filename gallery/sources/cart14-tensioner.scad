include <../../constructive-compiled.scad>
include <cart14-Plugs.scad>

//this is a placement where need to place the tesioner to putit on a plug tube tensioned
placeAtTheAxlePlug=X(-77)*turnXZ(180)*turnYZ(45);


//Assemble all Parts together

assemble("tensionerCore,tensionerArms,caret","screws")
	tensioner();

//-----------
//assemble every single part separately ready for Printing, aligning every Part on its own lying on the Print bed
opaq(yellow)
{
	assemble("tensionerCore")
		g(Y(-20),Z(-3),turnXZ(-90),stepBack(placeAtTheAxlePlug))
			tensioner();
	assemble("tensionerArms")
		g(Y(35),turnXZ(-90),stepBack(placeAtTheAxlePlug))
			tensioner();
	two()
		assemble("caret")
			g(Y(65),Z(31),reflectX(sides()),X(20),turnXZ()
					,turnXZ(-90),stepBack(placeAtTheAxlePlug))	
				tensioner(carets=1);
}
//-----------------------------------------------
//--this code below creates all Parts already aligned together 
module tensioner($fn=45,carets=2)
	autoColor()
		g(placeAtTheAxlePlug)
{
	//remove the Plug from  <cart14-Plugs.scad> from the 
	//TensionerCore leaving the  surface fitting the Plug
	remove("tensionerCore",stepBack(placeAtTheAxlePlug))
		confinementOf()
			plugs(); 	
	//create the removable Core for the Tensioner arms	(handles) making 
	//space for it in the Socket belonging to Tensioner Arms (created below)
	applyTo("tensionerCore",X(-5-16),turnYZ(45))
	{
		g(turnXZ(),Z(2),TODOWN(),solid(),height(margin(25)))
		{
			add(remove="tensionerArms")
				tube(d=margin(29));
			remove()
				tube(d=17);
		}
		two() 
			remove(X(-3),turnYZ(span(90)+45),cscale(1.5,1,1),turnXY(45))
				box(5,h=30);	
	}
	//create a socket for the removable core
	add("tensionerArms",turnXZ())
		tube(dOuter=36,dInner=22,h=10);
				
	pieces(carets)
		g(reflectZ(sides()),Z(15),TOUP(),solid())
	{	
		//create the tensioner Arms
		two() 
			add("tensionerArms",remove="caret",reflectY(sides()),Y(5),chamfer(-1,-1))
				box(margin(10,1),y=margin(5,1),h=60);
		//create carets as many as "carets" argument inside pieces() above
		add("caret",Z(10+4),X(10),turnXZ(90),chamfer(-1,-1))
			box(21,14);	
		//create  the scres and Nuts making space for them in carets	
		applyTo("screws")		
		{
			add(remove="caret")tubeFast(d=margin(3),h=80);
			add(remove="caret",Z(9),X(5),turnXZ(90))tubeFast(d=margin(5),h=margin(10));
	
			add(remove="caret",Z(-30),turnXZ(90),X(42),Z(2))
			{
				g(chamfer(-1,-1))
					tubeFast(d=margin(3),h=margin(8));
				g(Z(3.5),turnXY(45),chamfer(-1,-1))
					pressNutM3(marginDown=margin());
				Z(3)	
					inbusScrewM3(h=10,capMargin=20,$margin=.9);		
			}		
		}
	}
}
		