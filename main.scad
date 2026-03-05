include <./NopSCADlib/vitamins/pcb.scad>
include <./NopSCADlib/vitamins/pcbs.scad>
include <rp_2040_blk.scad>

$fs=1; // fragment length for circles
d=0.01; // delta for extra cut

kd=19.5; // standard key spacing
cw=14; // standard width for cherry mx compatible keyholes
ch=7.5; // height for cherry mx compatible keyholes

shw=3.3; //stabilzer hole width in mm
shl=14; //stabilizer hole height in mm
shd=12; //stabilzer hole distance to switch center
shs=0.7; //stabilizer hole shift

mpt=1.5; //thickness of mount plate
chw=5; // width for inner holes for mk switch clips on swtch chassis
chh=2; // height for inner holes for mk switch clips on switch chassis
chd=0.6; // depth of clip holes into switch hole

  

//pcb(rp_2040);

ex0 = 80;
ey0 = 19;
ex1 = 0;
ey1 = 139;
ex2 = 178.5;
ey3 = 69;
ex3 = 178.5;
ey4 = 59;
ex4 = 165.0;
ey5 = 0;
reference_points = [
    [ex0, ey0], // Bottom mid
    [ex1, ey0], // Bottom left
    [ex1, ey1], // Top left
    [ex2, ey1], // Top right
    [ex2, ey3], // Mid right
    [ex3, ey4], // Right
    [ex4, ey5], // Bottom
    ];
screw_holes = [
    [ex1, ey0], // Bottom left
    [ex1, ey1], // Top left
    [ex2, ey1], // Top right
    [ex3, ey4], // Right
    [ex4, ey5], // Bottom
    ];
// rp_mcu(x = 0, y = 0, z = 0);
// polygon(points = reference_points, convexity = 1 );

module case(left=false) {
  border = 2.5;
  length = 7.5*kd - border*2;
  width = 5*kd - border*2;
  corner = 5;
  wiring_hole = 6;
  support_width = 3.5;
  sink_unit = 2;
  thickness = 6;
  fastener_shift = 1.0;
  adjusted_length = length + border*2 - fastener_shift*2;
  adjusted_width = width + border*2 - fastener_shift*2;
  screw_radius = 1.2;
  nut_radius = 2;
  
  key_shift = 0;
  key_pos_left = [
    [3.75,0,1,2],[3.75,1,1,2],[4,2,1,2],[4.15,3,1,2],[3.9,4,1,2],[3.8,5,1,2], [3.5,6,1,2],
    [2.75,0,1,2],[2.75,1,1,2],[3,2,1,2],[3.15,3,1,2],[2.9,4,1,2],[2.8,5,1,2], [2.5,6,1,2],
    [1.75,0,1,2],[1.75,1,1,2],[2,2,1,2],[2.15,3,1,2],[1.9,4,1,2],[1.8,5,1,2], [1.5,6,1,2],
    [.75,0,1,2], [.75,1,1,2], [1,2,1,2],[1.15,3,1,2],[.9,4,1,2], [.8,5,1,2],  
    [-.25,0,1,2],[-.25,1,1,2],[0,2,1,2]
];
  key_pos_thumb_left = [
    [-.45,3.6,1,2],[-.45,4.6,1,2],[0,5.15,2,2],[-.2,6.1,2,2]
];
  key_pos_right = [
    [3.75,0,1,2],[3.75,1,1,2],[4,2,1,2],[4.15,3,1,2],[3.9,4,1,2],[3.8,5,1,2], [3.5,6,1,2],
    [2.75,0,1,2],[2.75,1,1,2],[3,2,1,2],[3.15,3,1,2],[2.9,4,1,2],[2.8,5,1,2], [2.5,6,1,2],
    [1.75,0,1,2],[1.75,1,1,2],[2,2,1,2],[2.15,3,1,2],[1.9,4,1,2],[1.8,5,1,2], [1.5,6,1,2],
    [.75,0,1,2], [.75,1,1,2], [1,2,1,2],[1.15,3,1,2],[.9,4,1,2], [.8,5,1,2],  
    [-.25,0,1,2],[-.25,1,1,2],[0,2,1,2],[0.15,3,1,2],[-.1,4,1,2],[-0.2,5,1,2],[-.50,6,1,2]
  ];
 key_pos_thumb_right = [
    [-.5,3,1,2],[-.5,4,1,2],[0,5,2,2],[0,6,2,2]
];

 // iterates over elements in array with values to module params 
 // row = key[0] increment/decrement by 1 positions a key 1u(19.5mm)*this value from the bottom left/right depending on which half
 // col = key[1] increment/decrement by 1 positions a key 1u(19.5mm)*this value from the left/right side depending on which half
 // size = key[2] keycap size, adjust adjacent col by difference to avoid key collision
 // sink = key[3] depth of key
 // rot = key[4] rotations of key
 // encoder = key[5] if key is encoder
  module key(row,col,size,sink=0) {
    translate([kd*(col+(size-1)/2)+border, kd*row+border, -sink*sink_unit-d]) {
      translate([-(kd-cw)/2, -(kd-cw)/2, thickness+d]) cube([kd+d, kd+d, sink*sink_unit+d*2]);
      translate([0,0,-10]) cube([cw,cw,20]);
      translate([cw/2-chw/2, -chd, thickness-chh-mpt]) cube([chw, chw+chd*2, chh]);
    }
  }
  module thumb_key(row,col,size,sink=0) {
    translate([kd*(col+(size-1)/2)+border, kd*row+border, -sink*sink_unit-d]) {
      if (size>1) rotate(a = [0,0,-12]) translate([-(kd-cw)/2, -(kd-cw)*size-1, thickness+d]) cube([kd+d, (kd*size)+d, sink*sink_unit+d*2]);
      else translate([-(kd-cw)/2, -(kd-cw)/2, thickness+d]) cube([kd+d, kd+d, sink*sink_unit+d*2]);
      if (size>1)  rotate(a = [0,0,-13]) translate([0,0,-10]) cube([cw,cw,20]);
      else translate([0,0,-10]) cube([cw,cw,20]);
      translate([cw/2-chw/2, -chd, thickness-chh-mpt]) cube([chw, chw+chd*2, chh]);
    }
  }

  module keys() {
    if (left) for (k=key_pos_left) key(k[0],k[1]+key_shift,k[2],k[3]);
    else for (k=key_pos_right) key(k[0],k[1]+key_shift,k[2],k[3]);
  }
  module thumb_keys(){
   if (left) for (k=key_pos_thumb_left) thumb_key(k[0], k[1], k[2], k[3]); 
   else for (k=key_pos_thumb_right) thumb_key(k[0], k[1], k[2], k[3]); 
}
  
  module key_raise(row,col,size,sink=0) {
    if (sink < 0)
      translate([kd*(col+(size-1)/2)+border,kd*row+border,0]) {
	translate([-(kd-cw)/2,-(kd-cw)/2,thickness+d]) cube([kd+d,kd+d,-sink+sink_unit+d*2]);
      }
  }
  
  module key_raises() {
    if (left) for (k=key_pos_left) key_raise(k[0],k[1]+key_shift,k[2],k[3]);
    else for (k=key_pos_right) key_raise(k[0],k[1]+key_shift,k[2],k[3]);
  }
  
  module front() {
    module screw_holes() {
      for (s=screw_holes)
		      translate(s)
			union() {
			translate([0, 0, 4]) cylinder(h = 3, r = 3, center = false);
			translate([0, 0, -1]) cylinder(h = thickness+d*3, r = screw_radius);
			}
    }
    
    difference() {
      minkowski() {
	linear_extrude(height = thickness, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) polygon(points = reference_points,convexity = 3);
	cylinder(h = d, r = corner);
      }
    translate([6, 30, 0]) {
      keys();
      translate([10,-3,0]) thumb_keys();
    }
      screw_holes();
    }
    difference() {
      key_raises();
      keys();
    }
    }
  front();
}


case(left=true);
// mirror([0,1,0]) translate([10, 40, 0]) case();
