
// REV 1.1





$fs=1; // fragment length for circles
d=0.01; // delta for extra cut

kd=19.5; // standard key spacing
cw=14; // standard width for cherry mx compatible keyholes
ch=9; // height for cherry mx compatible keyholes

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
ex6 = 75;
ey6 = 30;
ex7 = 95;
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
    [ex6,ey6],
    [ex7, ey1]
    ];

px0 = 45;
py0 = 103;
px1 = 84;
py1 = 107;
px2 = 123;
py2 = 65;
py3 = 70;
py4 = 78;
plate_columns = [
		 [px0, py0],
		 [px1, py1],
		 [px2, py0],
		 [px0, py2],
		 [px1, py3],
		 [px2, py4]
];
// rp_mcu(x = 0, y = 0, z = 0);
// polygon(points = reference_points, convexity = 1 );

module case(left=false,top=false,bottom=false,master=true) {
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
  screw_radius = 1.9;
  heat_insert_radius = 2.2;
  
  key_shift = 0;
  key_pos_left = [
    [3.75,0,1,2],[3.75,1,1,2],[4,2,1,2],[4.15,3,1,2],[3.9,4,1,2],[3.8,5,1,2], [3.5,6,1,2],
    [2.75,0,1,2],[2.75,1,1,2],[3,2,1,2],[3.15,3,1,2],[2.9,4,1,2],[2.8,5,1,2], [2.5,6,1,2],
    [1.75,0,1,2],[1.75,1,1,2],[2,2,1,2],[2.15,3,1,2],[1.9,4,1,2],[1.8,5,1,2], [1.5,6,1,2],
    [.75,0,1,2], [.75,1,1,2], [1,2,1,2],[1.15,3,1,2],[.9,4,1,2], [.8,5,1,2],  
    [-.25,0,1,2],[-.25,1,1,2],[0,2,1,2]
];
  key_pos_thumb_left = [
    [-.45,3.6,1,2],[-.45,4.6,1,2],[0,5.25,1.25,2],[-.2,6.2,1.25,2]
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
      if (size>1) rotate(a = [0,0,-12]) translate([-(kd-cw)/2+8, -(kd-cw)*(size)-2, thickness+d]) cube([kd+d, (kd*size)+d, sink*sink_unit+d*2]);
      else translate([-(kd-cw)/2, -(kd-cw)/2, thickness+d]) cube([kd+d, kd+d, sink*sink_unit+d*2]);
      if (size>1)  rotate(a = [0,0,-13]) translate([8,-2,-10]) cube([cw,cw,20]);
      else translate([0,0,-10]) cube([cw,cw,20]);
      if (size>1) rotate(a = [0,0,-13]) translate([(cw/2-chw/2)+2, -chd+2.5, thickness-chh-mpt]) cube([chw, chw+chd*2, chh]);
      else translate([(cw/2-chw/2), -chd, thickness-chh-mpt]) cube([chw, chw+chd*2, chh]);
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
	  translate([0, 0, 2]) cylinder(h = 5, r = 3, center = false);
	  translate([0, 0, -1]) cylinder(h = thickness+d*3, r = screw_radius);
	}
    }

    module standoff_hole() {
      for (p=plate_columns) 
	difference() {
	  color("red") translate(p) cylinder(h=2.7,d=3);
	  translate([p[0],p[1],-.2]) cylinder(h=1.5,d=2.2);
	}
}
    
    module encoder() {
      diameter = 8;
      bolt_clearance_d = 16;
      union() {
	cube([13.5, 14.5, 5.5], center = true); 
	translate([0,-6.85,-2.75]) cube([1.25,1.25, 6.2]);
	translate([0,0,12.75]) cylinder(h = 21, d = diameter, center = true);
	translate([0,0,7]) cylinder(h = 5, d = bolt_clearance_d, center = true);
     }
    }
    
    oled_recess_width = 28.5;
    oled_recess_height = 50.5;
    oled_recess_depth = 3;
       module oled_recess(){
	 union() {
	   translate([0,0,4]) cube([oled_recess_width, oled_recess_height, oled_recess_depth],center = true);
	   translate([0,0,2]) cube([oled_recess_width-14, oled_recess_height-14, oled_recess_depth+2], center=true);
	   translate([-7.25,-18.25,-2.2]) cube([oled_recess_width-14, 8, 3]);
	 }
	   translate([(oled_recess_width-5.5)/2, (oled_recess_height-5.5)/2, 0]) cylinder(r=heat_insert_radius, h=8, center = true);
	   	   translate([-(oled_recess_width-5.5)/2, -(oled_recess_height-5.5)/2, 0]) cylinder(r=heat_insert_radius, h=8, center = true);

       }
       module oled_plate() {
	 val = [-1,1];
	 plate_width = 28;
	 plate_height = 50;
	 hole_offset = 6;
	 module plate() {
	   color(c = "red", alpha = .8) cube([plate_width, plate_height,2],center = true);
	 }
	 difference() {
	   plate();
	   cube([14, 32, 3],center = true);
	   for (v=val){
	       translate([v*(oled_recess_width-hole_offset)/2, v*(oled_recess_height-hole_offset)/2, 1])
		 cylinder(d=8, h=1, center = true);
	       translate([v*(oled_recess_width-hole_offset)/2, v*(oled_recess_height-hole_offset)/2, 0])
		 cylinder(h = 3, r = screw_radius, center=true);
	     }

	 }
      
       }
       translate([160,90,15]) oled_plate();
    
    difference() {
      minkowski() {
	linear_extrude(height = thickness, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) polygon(points = reference_points,convexity = 3);
	cylinder(h = d, r = corner);
      }
      translate([160,90, 2]) oled_recess();
      translate([160,55, -1]) encoder();
    translate([6, 30, 0]) {
      keys();
      translate([12,-3,0]) thumb_keys();
    }
      screw_holes();
    }
    difference() {
      key_raises();
      keys();
    }
      translate([0,0,-.5]) standoff_hole();
  }
  module back(){
    thickness = 4;
    front_sink = 3;
    hole_depth = border*4+2*d;
    
    module screw_holes() {
      for (s=screw_holes)
	translate(s)
	  union(){
	  cylinder(h = (ch+thickness+d*2)+6, r=heat_insert_radius );
	}
    }
    
    module plate_standoffs(st) {
      for (p=plate_columns) {
	translate(p){
	  cylinder(h = 2, r = 3);
	  translate([0,0,st/2])cube([1, 1.8, st],center=true);
	  translate([0,0,st/4])cube([1, 3.6, st/2],center=true);
	  translate([0,0,st/2])cube([1.8, 1, st],center=true);
	  translate([0,0,st/4])cube([3.6, 1, st/2],center=true);
	}
      }
    }

    module trs_hole() {
      union(){
	cube([9, 24, 11]);
	rotate(a=[90,0,0])translate([4.5,5.7,-33]) cylinder(h = 9, r = 5);
      }
    }
    
    
    module pc_cable_hole() {
      rotate(a=[90,0,0])translate([4.5,5.7,-33]) cylinder(h = 9, r = 3);
    }

    module mcu_holder() {
      difference(){ 
	//Overall profile
	translate([-1, -1, -2.5]) cube([25.2, 56, 6.3]);
	translate([0,0,-2]) union() {
	  //left cutout closest to mcu cutout
	  cube([5,56,3.6]);
	  //right cutout closest to mcu cutout
	  translate([18.2,0,0]) cube([5,56,3.6]);
	}
	translate([0,0,1.55]) union() {
	  //top opening
	  translate([.5,0,0]) cube([22.2, 56, 3]);
	  //mcu slot
	  translate([0,0,0]) cube([23.2, 56, 1.2]);
	}
      }
    }   

    module case_walls() {
      minkowski() {
	      linear_extrude(height = ch+thickness+5, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0) polygon(points = reference_points);
	      cylinder(h = d, r = corner);
	    }
    }
    module case_chamber() {
      union() {
	      linear_extrude(height = ch+thickness+6, center = false, convexity = 10, twist = 0, slices = 20, scale = 1) polygon(points = reference_points);
	      cylinder(h = ch+thickness+6, r = corner);
	    }
    }
    
	plate_standoffs(st=(ch+thickness+d*2)+6);
    module plate() {
      difference() {
	union() {
	  difference() {
	    case_walls();
	    translate([0,0,1]) case_chamber();
	    translate([160,113,thickness+d]) trs_hole();
	   if (!left) translate([40,113,thickness+d]) pc_cable_hole();
	     	  }
	  for (s=screw_holes){
	    translate(s)
	    cylinder(h = ch+thickness+5, r = 4 );
	  }
	  translate([8,20,thickness+2]) mcu_holder();
	}
	translate([0,0,.5]) screw_holes();
      }
    }
    plate();
}
  if (top) translate([0,0,0]) front();
  if (bottom) translate([0,0,-ch-10]) back();
}


// render top
case(left=true,top=true);
translate([400,0,0]) mirror([1,0,0]) case(left=true,top=true);
// render bottom
case(left=false,bottom=true);
translate([400,0,0]) mirror([1,0,0]) case(left=true,bottom=true);

 
