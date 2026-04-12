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
	 [0,135]
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
		    key_plate_offset=[0,0,30],
		    gasket_height=5,
		    gasket_plate_offset=[0,0,15],
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
    translate(pos_offset) difference() {
      minkowski() {
	shape(h=top_plate_height);
	sphere(6);
      }
      translate([0,0,-9.9]) cube([500,500,10],center=true);
      translate([0,0,-5]) shape(h=clearance);
      translate(plate_layer_align) keycap_cutouts(keys=keys, delta = 0.02, space = 19.5, encoder = 12);
      column_cutouts(xy=points, height=clearance);
    }
    for(p=points)
      {
	translate(p) heat_insert_columns(width=m2_colw, hi_width=m2_hi_pilot, height=clearance);
      }
  }

  module key_plate(pos_offset=key_plate_offset)
  {
    translate(pos_offset) difference()
      {
	color("green") shape(h=key_plate_height);
	translate(plate_layer_align) hole_cutouts(keys=keys);
	column_cutouts(xy=points, height=key_plate_height+.02, delta=.02);
      }    
  }
  
  module gasket(pos_offset=gasket_plate_offset)
    {
      translate(pos_offset) difference()
	{
	 color("grey") shape(h=gasket_height);
	  translate(plate_layer_align) gasket_holes(keys=keys);
	  column_cutouts(xy=points, height=gasket_height+.02, delta=.02);
	}
    }
  
  module bottom_plate(pos_offset=bottom_plate_offset)
  {
    translate(pos_offset) 
      {
	difference()
	  {
	    shape(h=bottom_plate_height);
	    column_cutouts(xy=points, height=bottom_plate_height+.02, delta=.02);
	  }
      }
  }
 
  if(top) translate([0,0,60]) rotate([3,0,0]) top_plate();
  if(plate) translate([0,0,15]) rotate([3,0,0]) key_plate();
  if(gasket) translate([0,0,10]) rotate([3,0,0]) gasket();
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
    column_cutouts(xy=points, height=bottom_half_height+.02, delta=.02);
    translate([0,0,-2]) 
      {
	for(p=points)
	  {
	    translate(p) rotate([180,0,0]) bolt_shape_cutout(c_diameter=m2_cd, bolt_diameter=m2+.05, f_height=m2_head_h, length=bottom_half_height);
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
       }
    }
}

translate([0,0,20]) top_assembly(keys=layout);
bottom_cavity();




