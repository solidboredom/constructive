module tubeV2(h=heightInfo(),d=$d,dInner=$dInner,dOuter=$dOuter,wall=$wall,d1=undef,
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
	       up(stickOutBothEnds?0:holeStickOut/2)
		        cylinder(solid?0:((h+.03+abs(holeStickOut)
			           +(stickOutBothEnds?abs(holeStickOut):0)))
				         ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                 ,center=true);

	      if(($inverted && $removing))
		        up(stickOutBothEnds?0:holeStickOut/2)
			           cylinder(solid?0:((h+.03+abs(holeStickOut)
                          +(stickOutBothEnds?abs(holeStickOut):0)))
				                  ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                          ,center=true);
	    }
	    if(!$inverted && summingUp && $removing)
		    up(stickOutBothEnds?0:holeStickOut/2)
			     cylinder(solid?0:((h+.03+abs(holeStickOut)
                +(stickOutBothEnds?abs(holeStickOut):0)))
				            ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                      ,center=true);
    }
  stackingTranslation=calcStackingTranslation(lx,ly,lz);
  $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);

  translate(stackingTranslation)
    children();
  }
/*
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
	   scale(addToV(multV(absV(stackingInfo()[1])//stackOverlap
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
                ,geom = chamfer(invert=innerChamfer))
				  box(side = max(d,(d2==undef)?0:d2)
					     ,y=max(d,(d2==undef)?0:d2)
					      +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                    ,zeroIfUndef(chamferInfo()[1][0]))
					          ,z=h+.1);

	        if(arc>0 && arc<180)
		        for(angle=[-180+90,arc+90])
			         g(turnXY(angle)
                  ,geom=chamfer(invert=innerChamfer))
				              box(side=max(d,(d2==undef)?0:d2)
					                   ,y=max(d,(d2==undef)?0:d2)
					                  +2*2*max(zeroIfUndef(chamferInfo()[0][0])
                            ,zeroIfUndef(chamferInfo()[1][0])
                ),z=h+.1);
	      }
	       up(stickOutBothEnds?0:holeStickOut/2)
		        cylinder(solid?0:((h+.03+abs(holeStickOut)
			           +(stickOutBothEnds?abs(holeStickOut):0)))
				         ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                 ,center=true);

	      if(($inverted && $removing))
		        up(stickOutBothEnds?0:holeStickOut/2)
			           cylinder(solid?0:((h+.03+abs(holeStickOut)
                          +(stickOutBothEnds?abs(holeStickOut):0)))
				                  ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                          ,center=true);
	    }
	    if(!$inverted && summingUp && $removing)
		    up(stickOutBothEnds?0:holeStickOut/2)
			     cylinder(solid?0:((h+.03+abs(holeStickOut)
                +(stickOutBothEnds?abs(holeStickOut):0)))
				            ,d1=d-wall*2,d2=((d2==undef)?d:d2)-wall*2
                      ,center=true);
    }
    stackingTranslation=calcStackingTranslation(lx,ly,lz);
    $centerLineStack=calcCenterLineStackTube(lx,ly,lz,stackingTranslation);
    translate(stackingTranslation)
	    children();
  }
*/
/*
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
*/
