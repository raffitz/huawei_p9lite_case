/*
 * bq Aquaris A4.5 case
 */

// bq provided dimensions:
w = 63.48;
h = 131.77;
d = 8.75;

// Measured/estimated dimensions:
r = 5.5;

module aquarishape(width,height,depth,rounding){
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

// Case:
tolerance = 1.2;
thickness = 2;
clip = 0.6;

difference() {
	union() {
		// Main case
		aquarishape(w + tolerance + thickness,
			h + tolerance + thickness,
			d + tolerance + thickness,
			r + (tolerance + thickness)/2);
	}
	// Case cavities
	translate([0,0,thickness/2]){
		aquarishape(w + tolerance,
			h + tolerance,
			d + tolerance,
			r + tolerance/2);
		aquarishape(w - clip,
			h - clip,
			d + tolerance + thickness,
			r - clip/ 2);
	}
	translate ([0,-h/2-tolerance - thickness,d+thickness]) rotate(-90,[1,0,0]){
		aquarishape(w - 2*r,2*d,1.2*h,r);
	}
	translate ([w/2-4-8.5,h/2-2-5.5,0]) aquarishape(17,11,thickness,1);
	translate ([w/2-thickness,h/2-70,thickness]) cube([2*thickness,45,1.5*d]);
	translate ([0,-10,0]){
		difference() {
			union() {
				cylinder(h=thickness,r=15,$fn=6);
				for(ra=[0:60:360]){
					rotate(ra,[0,0,1]) translate ([0,30,0]) cylinder(h=thickness,r=15,$fn=6);
				}
			}
			translate ([w/2-thickness,-h/2,0]) cube([10,h,10]);
			translate ([-w/2-10+thickness,-h/2,0]) cube([10,h,10]);
		}
	}
}
