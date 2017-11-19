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
			convexity = 2);

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
			convexity = 2);

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
			convexity = 2);

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

difference() {
	union() {
		// Main case
		roundedppiped(w + tolerance + thickness,
			h + tolerance + thickness,
			d + tolerance + thickness,
			r + (tolerance + thickness)/2);
	}
	// Case cavities
	translate([0,0,thickness/2]){
		roundedppiped(w + tolerance,
			h + tolerance,
			d + tolerance,
			r + tolerance/2);
		roundedppiped(w - clip,
			h - clip,
			d + tolerance + thickness,
			r - clip/ 2);
	}
	translate ([0,-h-tolerance - thickness,d+thickness]) rotate(-90,[1,0,0]){
		roundedppiped(w - 2*r,2*d,1.2*h,r);
	}
	translate ([0,h/2,0]) roundedppiped(w-2*thickness,30,2*d,r);
	translate ([w/2-tolerance/2-clip/2,h/2-70,0]) cube([2*thickness,45,1.5*d]);
	translate ([0,10,0]){
		difference() {
			union() {
				cylinder(h=thickness,r=15,$fn=6);
				for(ra=[0:60:360]){
					rotate(ra,[0,0,1]) translate ([0,30,0]) cylinder(h=thickness,r=15,$fn=6);
				}
			}
			translate ([w/2-3*thickness,-h/2,0]) cube([10,h,10]);
			translate ([-w/2-10+3*thickness,-h/2,0]) cube([10,h,10]);
		}
	}
}
