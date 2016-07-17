/*
 * bq Aquaris A4.5 mock-up
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

aquarishape(w,h,d,r);
