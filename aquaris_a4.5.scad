/*
 * bq Aquaris A4.5 mock-up
 */

// bq provided dimensions:
width = 63.48;
height = 131.77;
depth = 8.75;

// Measured/estimated dimensions:
rounding = 5.5;

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
