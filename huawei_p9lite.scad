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

	linear_extrude(height = depth, center = false, convexity = 1, twist = 0, slices = 1, scale = 1.0)
		offset(rounding,$fn=64)
			square([shortwidth,shortheight],true);
}

module roundedziggurat(width,height,depth,rounding,inset){
	// Intermediate variables:
	shortwidth = width - 2*rounding;
	shortheight = height - 2*rounding;

	horiscale = (width - (2 * inset))/width;
	vertiscale = (height - (2 * inset))/height;

	linear_extrude(height = depth, center = false, convexity = 1, twist = 0, slices = 1, scale = [horiscale,vertiscale])
		offset(rounding,$fn=64)
			square([shortwidth,shortheight],true);
}

module pnineshape(width,height,depth,rounding,insetdepth,inset){
	union (){
		translate ([0,0,insetdepth]) scale ([1,1,-1]) roundedziggurat(width,height,insetdepth,rounding,inset);
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
	// Main case
	pnineshape(w + tolerance + thickness,
		h + tolerance + thickness,
		d + tolerance + thickness,
		r + (tolerance + thickness)/2,
		insetheight,
		insetammount);
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
	translate ([w/2-tolerance/2-clip/2-insetammount,h/2-70,-1]) cube([2*thickness,43,1.6*d]);
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
}
