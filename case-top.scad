// rows contain columns in vectors
include <keys.scad>
include <kb-utils/top-plate-utils.scad>

points =[
	 [0,0],
	 [90,10],
	 [250,0],
	 [250,150],
	 [90,165],
	 [0,150]
];

module top_assembly(
		    polygon_points=points,
		    keys,
		    top_plate_height=9,
		    top_plate_offset=[0,0,40],
		    key_plate_height=1.5,
		    key_plate_depth=1,
		    key_plate_offset=[0,0,30],
		    gasket_height=5,
		    gasket_plate_offset=[0,0,15],
		    bottom_plate_height=3,
		    bottom_plate_offset=[0,0,0],
		    plate_layer_allign=[20,120,0],
		    top=true,
		    plate=true,
		    gasket=true,
		    bottom_plate=true
		    )
{
  module shape(p=polygon_points, h)
  {
   	linear_extrude(height=h, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) polygon(p);
  }

  module top_plate(
		   clearance=(key_plate_height+gasket_height+bottom_plate_height)*2,
		   pos_offset=top_plate_offset
		   )
    {
    translate(pos_offset) difference() {
      minkowski() {
	shape(h=top_plate_height);
	sphere(4);
      }
      translate([0,0,-9.9]) cube([500,500,10],center=true);
      translate([0,0,-(clearance/2)]) shape(h=clearance);
      translate([20,120,0]) keycap_cutouts(keys=keys, delta = 0.02, space = 19.5, encoder = 12);
    }
  }

  module key_plate(pos_offset=key_plate_offset)
  {
    translate(pos_offset) difference()
      {
	shape(h=key_plate_height);
	translate(plate_layer_allign) hole_cutouts(keys=keys);
      }    
  }
  
  module gasket(pos_offset=gasket_plate_offset)
    {
      translate(pos_offset) difference()
	{
	 color("grey") shape(h=gasket_height);
	  translate(plate_layer_allign) gasket_holes(keys=keys);
	}
    }
  
  module bottom_plate(pos_offset=bottom_plate_offset)
  {
    translate(pos_offset) shape(h=bottom_plate_height);
  }
 
  if(top) top_plate();
  if(plate) key_plate();
  if(gasket) gasket();
  if(bottom_plate) bottom_plate();
}

top_assembly(keys=layout);


