/*
 * bq Aquaris A4.5 mock-up
 */

// bq provided dimensions:
width = 63.48;
height = 131.77;
depth = 8.75;

translate([-width/2,-height/2,0]){
	cube([width,height,depth]);
}
