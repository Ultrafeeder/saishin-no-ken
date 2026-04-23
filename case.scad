// rows contain columns in vectors
include <keys.scad>
include <kb-utils/top-plate-utils.scad>
include <kb-utils/joiner-utils.scad>

points =[
	 [0,8],
	 [80,10],
	 [180,3],
	 [190, 50],
	 [190,145],
	 [85,150],
	 [0,135],
	 [0, 75]
];

module shape(p=points, h)
{
  linear_extrude(height=h, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) polygon(p);
}

module column_cutouts(xy, height, delta=0)
{
  $fn=20;
  for(p=xy)
    {
      translate(p) cylinder(h=height, d=m2_colw+delta, center=true);
    }
}

module top_assembly(
		    keys,
		    top_plate_height=9,
		    top_plate_offset=[0,0,0],
		    key_plate_height=1.5,
		    key_plate_depth=1,
		    key_plate_offset=[0,0,20],
		    gasket_height=5,
		    gasket_plate_offset=[0,0,10],
		    bottom_plate_height=3,
		    bottom_plate_offset=[0,0,0],
		    plate_layer_align=[15,110,0],
		    top=true,
		    plate=true,
		    gasket=true,
		    bottom_plate=true
		    )
{


  module top_plate(
		   clearance=(key_plate_height+gasket_height+bottom_plate_height)*2,
		   pos_offset=top_plate_offset
		   )
    {
    module oled_recess()
      {
	translate([0,0,-.2]) cube([15,37,3.5], center=true);
	translate([0,0,2]) cube([14,31,7], center=true);
	translate([0,-20,.5]) cube([15,5,7], center=true);
      }

   
    translate(pos_offset) difference() {
      minkowski() {
	shape(h=top_plate_height);
	sphere(6);
      }
      translate([0,0,-9.9]) cube([500,500,10],center=true);
      translate([0,0,-5]) shape(h=clearance);
      translate(plate_layer_align) keycap_cutouts(keys=keys, delta = 0.02, space = 19.5, encoder = 16);
      translate([170,98,6]) color("red") oled_recess();
      column_cutouts(xy=points, height=clearance);
      translate([0,0,7]) column_cutouts(xy=bottom_screws, height=6);
    }
    for(p=points)
      {
	translate(p) heat_insert_columns(width=m2_colw, hi_width=m2_hi_pilot, height=clearance);
      }
    for(b=bottom_screws)
      {
	translate(b) translate([0,0,7.3]) heat_insert_columns(width=m2_colw, hi_width=m2_hi_pilot, height=6);
      }
    }

  plate_screws = [
		  [54,50],
		  [54,108],
		  [93,110],
		  [132,105],
		  [93,70],
		  [154,30],
		  ];
  bottom_screws = [
		   [10,110],
		   [10,40],
		   [40,20],
		   [85,43],
		   [120,40],
		   [178,25],
		   [150,55],
		   [157,100],
		   [185,100],
		   [150,137],
		   [40,133],
];
  module key_plate(pos_offset=key_plate_offset)
  {
    module oled_platform()
    {
      translate([0,0,-.2]) cube([15,36.5,3.5], center=true);
    }

    translate(pos_offset) difference()
      {
	color("green") shape(h=key_plate_height);
	translate(plate_layer_align) hole_cutouts(keys=keys);
	column_cutouts(xy=points, height=key_plate_height+.04, delta=2);
	translate([170,80,.5]) cube([16,5,7], center=true);
	for (p=plate_screws)
	  {
	    translate(p) translate([0,0,-(key_plate_height+2.3)]) bolt_shape_cutout(c_diameter=m2_cd, bolt_diameter=(m2)+.4, f_height=m2_head_h, length=key_plate_height+2);
	    for (b=bottom_screws)
	      {
		translate(b) translate([0,0,-4])  cylinder(h=20, d=(m2)+1); 
	      }
	  }
      } 
    translate(pos_offset)
      {
	translate([170,98,2.4]) difference() 
	  {
	    oled_platform();
	    translate([0,-20,.5]) cube([16,5,7], center=true);
	  }
      }
       
  }
  
  module gasket(pos_offset=gasket_plate_offset)
    {
      translate(pos_offset) difference()
	{
	 color("grey") shape(h=gasket_height);
	  translate(plate_layer_align) gasket_holes(keys=keys);
	  column_cutouts(xy=points, height=gasket_height+.04, delta=2);
	  translate([170,80,.5]) cube([16,5,8], center=true);
	  for(p=plate_screws)
	    {
	      translate(p) translate([0,0,-6]) cylinder(h=15, d=(m2)+1, center = false);
	    }
	  for (b=bottom_screws)
	    {
	      translate(b) translate([0,0,-4]) cylinder(h=20, d=(m2)+1); 
	    }
	}
    }
  
  
  module bottom_plate(pos_offset=bottom_plate_offset)
  {
    translate(pos_offset) 
      {
	difference()
	  {
	    shape(h=bottom_plate_height);
	    translate(plate_layer_align) gasket_holes(keys=keys);
	    column_cutouts(xy=points, height=bottom_plate_height+.04, delta=2);
	    column_cutouts(xy=plate_screws, height=15, delta=0);
	    translate([170,80,.5]) cube([16,5,8], center=true);
	    for(b=bottom_screws)
	      {
		translate(b) translate([0,0,4.5]) rotate([180,0,0]) bolt_shape_cutout(c_diameter=m2_cd, bolt_diameter=(m2)+.4, f_height=m2_head_h, length=bottom_plate_height+2);

	      }
	  };
	for(p=plate_screws)
	  {
	    translate(p) heat_insert_columns(width=m2_colw, hi_width=m2_hi_pilot, height=bottom_plate_height+.2);
	  };
      }
  }

  if(top)  translate([0,-.4,30]) rotate([3,0,0]) top_plate();
  if(plate)  rotate([3,0,0]) key_plate();
  if(gasket)  rotate([3,0,0]) gasket();
  if(bottom_plate) rotate([3,0,0]) bottom_plate();
}

module bottom_enclosure(
			bottom_half_height=6,
)
{
  difference() {
    minkowski()
      {
	shape(h=bottom_half_height);
	sphere(6);
      }
    translate([0,0,3]) shape(h=15);
    translate([0,0,6]) cube([500,500,6], center=true);
    column_cutouts(xy=points, height=bottom_half_height+.03, delta=.02);
    translate([0,0,-2]) 
      {
	for(p=points)
	  {
	    translate(p) translate([0,0,0])  rotate([180,0,0]) bolt_shape_cutout(c_diameter=m2_cd, bolt_diameter=m2+.6, f_height=m2_head_h, length=bottom_half_height);
	  }
      }
  }
}

module bottom_cavity()
{
  let(
      pos_offset=[8,16,-10],
      dimensions=[170,115,20]
)
    {
      difference() 
	    {
	      rotate([3,0,0]) bottom_enclosure();
	      translate(pos_offset) cube(dimensions);
	      color("red") translate([130,160,0]) rotate([90,0,0]) cylinder(h = 30, d = 17.5, center = false);
	      color("red") translate([50,160,-1]) rotate([90,0,0]) cylinder(h = 30, d = 20.1, center = false);
	    }
     difference() 
       {
	 minkowski()
	   {
	     translate(pos_offset) cube(dimensions);
	     sphere(3);
	   }
	 translate([0,0,-5]) rotate([3,0,0]) cube([200,200,40]);
	 translate(pos_offset) cube(dimensions);
	 color("red") translate([130,160,-1]) rotate([90,0,0]) cylinder(h = 30, d = 15.5, center = false);
	 color("red") translate([50,160,-1]) rotate([90,0,0]) cylinder(h = 30, d = 15.5, center = false);
       }
    }
  difference() {
    color("red") translate([130,148.5,0]) rotate([90,0,0]) cylinder(h = 17.5, d = 20, center = false);
    color("green") translate([130,151.5,0]) rotate([90,0,0]) cylinder(h = 17.5, d = 17.5, center = false);
    color("blue") translate([130,150,0]) rotate([90,0,0]) cylinder(h = 50, d = 10, center = false);
    translate([120,134,-17]) cube([20,30,16]);
  }
  difference() {
    color("red") translate([50,145.5,-1]) rotate([90,0,0]) cylinder(h=14.5, d=22, center = false);
    color("green") translate([50,151.5,-2]) rotate([90,0,0]) cylinder(h = 17.5, d = 20.1, center = false);
    color("blue") translate([50,150,0]) rotate([90,0,0]) cylinder(h = 50, d = 13, center = false);
    translate([39,134,-16]) cube([24,30,16]);
  }
module mcu_holder() {
      difference(){ 
	//Overall profile
	translate([-1, -1, -2.5]) cube([25.2, 56, 7]);
	translate([0,0,-2]) union() {
	  //left cutout closest to mcu cutout
	  cube([5,56,3.6]);
	  //right cutout closest to mcu cutout
	  translate([18.2,0,0]) cube([5,56,3.6]);
	}
	translate([0,0,1.55]) union() {
	  //top opening
	  translate([.5,0,0]) cube([22.2, 70, 3]);
	  translate([2.5,-10,0]) cube([18, 70, 3]);
	  //mcu slot
	  translate([-.05,0,0]) cube([23.32, 56, 1.4]);
	  translate([0,10,0]) cube([23.2, 40, 4]);
	  translate([-2,-2,-8]) cube([30, 60, 6]);
	}
      }
}
 color("blue") translate([140,30,-11]) rotate([0,0,90]) mcu_holder();
}

translate([0,0,4]) top_assembly(keys=layout);
bottom_cavity();







