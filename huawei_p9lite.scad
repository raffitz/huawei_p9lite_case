/*
 * Huawei P9 Lite case
 */

// Huawei provided dimensions:
w = 72.6;
h = 146.8;
d = 7.5;

// Measured/estimated dimensions:
r = 5;

module roundedppiped(width,height,depth,rounding){
	// Intermediate variables:
	shortwidth = width - 2*rounding;
	shortheight = height - 2*rounding;

	union() {
		// Bottom parallelepiped:
		translate([-shortwidth/2,-height/2,0]){
			cube([shortwidth,rounding,depth]);
		}

		// Middle parallelepiped:
		translate([-width/2,-shortheight/2,0]){
			cube([width,shortheight,depth]);
		}

		// Top parellelepiped:
		translate([-shortwidth/2,shortheight/2,0]){
			cube([shortwidth,rounding,depth]);
		}

		// Rounded corners:
		for(i=[-1,1]){
			for(j=[-1,1]){
				translate([i*shortwidth/2,j*shortheight/2,0]){
					cylinder(h=depth,r=rounding,$fn=64);
				}
			}
		}
	}
}

module roundedziggurat(width,height,depth,rounding,inset){
	// Intermediate variables:
	shortwidth = width - 2*rounding;
	shortheight = height - 2*rounding;

	union() {
		// Bottom trapezoidal prism:
		polyhedron(
			points = [
				[-shortwidth/2,-height/2,0],		// 0 Bottom SW
				[-shortwidth/2,-shortheight/2,0],	// 1 Bottom NW
				[shortwidth/2,-shortheight/2,0],	// 2 Bottom NE
				[shortwidth/2,-height/2,0],		// 3 Bottom SE
				[-shortwidth/2,-height/2 + inset,depth],	// 4 Top SW
				[-shortwidth/2,-shortheight/2,depth],		// 5 Top NW
				[shortwidth/2,-shortheight/2,depth],		// 6 Top NE
				[shortwidth/2,-height/2 + inset,depth]],	// 7 Top SE
			faces = [
				[1,0,3,2],	// Bottom face
				[5,4,7,6],	// Top face
				[2,6,5,1],	// North face
				[0,4,7,3],	// South face
				[1,5,4,0],	// West face
				[3,7,6,2]],	// East face
			convexity = 10);

		// Middle trapezoidal prism:
		polyhedron(
			points = [
				[-width/2,-shortheight/2,0],	// 0 Bottom SW
				[-width/2,shortheight/2,0],		// 1 Bottom NW
				[width/2,shortheight/2,0],		// 2 Bottom NE
				[width/2,-shortheight/2,0],		// 3 Bottom SE
				[-width/2 + inset,-shortheight/2,depth],	// 4 Top SW
				[-width/2 + inset,shortheight/2,depth],		// 5 Top NW
				[width/2 - inset,shortheight/2,depth], 		// 6 Top NE
				[width/2 - inset,-shortheight/2,depth]],	// 7 Top SE
			faces = [
				[1,0,3,2],	// Bottom face
				[5,4,7,6],	// Top face
				[2,6,5,1],	// North face
				[0,4,7,3],	// South face
				[1,5,4,0],	// West face
				[3,7,6,2]],	// East face
			convexity = 10);

		// Top trapezoidal prism:
		polyhedron(
			points = [
				[-shortwidth/2,shortheight/2,0],	// 0 Bottom SW
				[-shortwidth/2,height/2,0],		// 1 Bottom NW
				[shortwidth/2,height/2,0],		// 2 Bottom NE
				[shortwidth/2,shortheight/2,0],		// 3 Bottom SE
				[-shortwidth/2,shortheight/2,depth],	// 4 Top SW
				[-shortwidth/2,height/2 - inset,depth],	// 5 Top NW
				[shortwidth/2,height/2 - inset,depth], 	// 6 Top NE
				[shortwidth/2,shortheight/2,depth]],	// 7 Top SE
			faces = [
				[1,0,3,2],	// Bottom face
				[5,4,7,6],	// Top face
				[2,6,5,1],	// North face
				[0,4,7,3],	// South face
				[1,5,4,0],	// West face
				[3,7,6,2]],	// East face
			convexity = 10);

		// Rounded corners (cone trunks):
		for(i=[-1,1]){
			for(j=[-1,1]){
				translate([i*shortwidth/2,j*shortheight/2,0]){
					cylinder(h=depth,r1=rounding,r2=rounding-inset,$fn=64);
				}
			}
		}
	}
}

module pnineshape(width,height,depth,rounding,insetdepth,inset){
	union (){
		roundedziggurat(width-2*inset,height-2*inset,insetdepth,rounding - inset,-inset);
		translate ([0,0,insetdepth]) roundedppiped(width,height,depth - 2*insetdepth,rounding);
		translate ([0,0,depth-insetdepth]) roundedziggurat(width,height,insetdepth,rounding,inset);
	}
}

// Case:
tolerance = 0.6;
thickness = 2.4;
clip = 1.6;

// Inset:
insetheight = 1.5;
insetammount = 1;

difference() {
	union() {
		// Main case
		pnineshape(w + tolerance + thickness,
			h + tolerance + thickness,
			d + tolerance + thickness,
			r + (tolerance + thickness)/2,
			insetheight,
			insetammount);
	}
	// Case cavities
	translate([0,0,thickness/2]){
		pnineshape(w + tolerance,
			h + tolerance,
			d + tolerance,
			r + tolerance/2,
			insetheight,
			insetammount);
		roundedppiped(w - insetammount - clip,
			h - insetammount - clip,
			d + tolerance + 2*thickness,
			r - clip/ 2);
	}
	// Charging port and speaker hole
	translate ([0,-h-tolerance - thickness,d+thickness]) rotate(-90,[1,0,0]){
		roundedppiped(50,2*d,0.6*h,r);
	}
	// Audio Jack hole
	translate ([0,0,d+thickness]) rotate(-90,[1,0,0]){
		roundedppiped(35,2*d,0.6*h,r);
	}
	// Camera hole
	translate ([22,66,-1]) roundedppiped(17.5,10,thickness+2,1);
	// Volume and Lock Button hole
	translate ([w/2-tolerance/2-clip/2-insetammount,h/2-70,-1]) cube([2*thickness,43,1.5*d]);
	// Decorative holes
	translate ([0,10,0]){
		intersection() {
			union() {
				for(i=[-4:1:2]){
					translate ([0,i*30,-1]){
						cylinder(h=thickness+2,r=15,$fn=6);
						for(ra=[60,300]){
							rotate(ra,[0,0,1]) translate ([0,30,0]) cylinder(h=thickness + 2,r=15,$fn=6);
						}
					}
				}
			}
			// Bounding space
			translate ([0,-15,-1]) roundedppiped(w-16,120,10,3);
		}
	}
}
