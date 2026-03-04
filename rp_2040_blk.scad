include <./NopSCADlib/vitamins/microswitches.scad>
include <./NopSCADlib/vitamins/d_connectors.scad>
include <./NopSCADlib/vitamins/leds.scad>
include <./NopSCADlib/vitamins/axials.scad>
include <./NopSCADlib/vitamins/radials.scad>
include <./NopSCADlib/vitamins/smds.scad>
include <./NopSCADlib/vitamins/green_terminals.scad>
include <./NopSCADlib/vitamins/7_segments.scad>
include <./NopSCADlib/vitamins/potentiometers.scad>
include <./NopSCADlib/vitamins/buttons.scad>

rp_2040 = [
	   "RP_2040_blk",
	   "Rasperry Pi usb-c",
	   53.34,
	   22.86,
	   1.6,
	   0.5,
	   2.1,
	   0,
	   "black",
	   false,
	   [],
	   [
	    [ 3.6, 22.86/2, 180, "usb_C"],
	    [ 25,   21/2,   0, "chip", 7, 7, 0.8],
	    [ 12.75, 7.5,   0, "block", 4.5, 3.35, 2, "DarkGray"],
	    [ 12.75, 7.5,   0, "block", 3,  2.25, 2.75, "LightGray"],
	    ],
	   [],
	   [ 1.37, 1.61, 20, 2, gold, 2.54, 19.54 ],
];

use <./NopSCADlib/vitamins/pcb.scad>
