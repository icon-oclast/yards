
// 3d model of a REVOMAZE puzzle
// Based on products created and sold by https://www.revohq.co.uk

/* Copyright © 2019,2022 Michael Turner */
/* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. */
/* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. */
/* You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. */


// This is an attempt to model a revomaze (generic form, no actual maze)
// as a prelude to creating a revomaze stand of somesort
// all measurements taken on my unopened TI revomaze and or my disassembled Aqua
// todo: verify with other revomazes. determine tollerances.

// modules

module revo_draw_bar(c="silver") {
     echo ("draw_bar");
    // draw bar
    // outer length = 105.62, diameter = 10.85
    // inner bar =  65mm, 7mm diameter
    length = 105.62;
    bells = 20;
    bell_from_center = ((length /2) - (bells / 2));

    inner_r = (7 / 2);
    outer_r = (10.85 / 2);
    color(c) {  // to visually distinguish it
        // inner bar
        cylinder(r=inner_r, h=length, center=true);

        // barbell ends
        // cylinder(r=(10.85 /2), h=105.62, center=true);
        translate([0,0, bell_from_center])
            cylinder(r=outer_r, h=bells, center=true);
        translate([0,0, -bell_from_center])
            cylinder(r=outer_r, h=bells, center=true);
    } // color

    // todo: hole for pin
    // large hole: 3.80 diameter, 4.20 deep,
    //             hole edge 4.5mm from inner bell edge, 12.00mm from outside edge.
    // small hole: 3mm diameter, 2.08mm deep
    //             hole edge 4.8mm from inner bell edge, 12.20mm from outside edge.

}

module revo_draw_bar_space() {
     echo ("draw_bar");
    // draw bar
    // length = 105.62, diameter = 10.85
    // so we'll use 11 and 106
    cylinder(r=(11 /2), h=106, center=true);
}

function revo_draw_bar_dia() = 10.85;
function revo_draw_bar_inner_len() = 65;
function revo_draw_bar_outer_len() = 105.62;
function revo_total_len() = revo_draw_bar_outer_len(); // the draw bar is the longest part

module revo_tube(c="grey") {
    // maze tube (cylindrical part)
    // measures just under 85mm. hard to get exact while it's in the sleeve.
    // calling it as 85 even
    // it visually appears to be just a hair shorter than the sleeve edge
    // (chamfer?)
    tube_dia = 23.62;
    tube_r = (tube_dia / 2);
    tube_len = 85;

    // end grip
    // points appear to be 1.2mm from cylinder.
    // grip is 9.37mm longer on each end
    // total length is 103.90
    // (which gives an error of 0.16mm)
    grip_r = (tube_r - 1.2);
    grip_len = ((9.37 *2) + tube_len);

    difference() {
        union() {
            // maze tube
            color(c) {
                cylinder(r=tube_r, h=tube_len, center=true);
                // end grip
                // note, grip has 7 sides!
                cylinder(r=((23.62 /2) - 1.2), h=((9.37 *2) + 85), $fn=7, center=true);
            }
        } // maze tube union

        // hole for draw bar
        revo_draw_bar_space();
    } // difference
} // revo_tube

module revo_tube_space() {
    // hole in which the revomaze tube will fit
    // tolerances are purely wild guesses here.
    // use with difference() to get an actual hole.
    // tube diameter = 23.62, so for the hole let's use 23.75
    // grip height =((9.37 *2) + 85) = 103.75, so use 105
    cylinder(r=(23.75/2), h=105, center=true);
}

function revo_tube_dia() = 23.62;
function revo_tube_r() = revo_tube_dia()/2;
function revo_tube_len() = 85;
function revo_tube_grip_len() = ((9.37 *2) + revo_tube_len());
function revo_grip_width() = 9.37;
function revo_grip_r() = revo_tube_r() - 1.2;

* revo_tube();

// revomaze shell (what is also sometimes referred to as the "sleeve")
// "extreme" is the metal maze ("obsession" is plastic and not addressed here)
// "V1" is the ribbed sleeve (the default one that most everyone probably has)
// "V2" is the smooth sleeve (not seen one in person, specs below are presumed assumptions based on V1 measurements)
// "V3" is the same sleeve as V1
// if in doubt, use V1 as that's what everything here is actually based on.

module revo_shell_v2(c="blue") {
    // sleeve
    color(c) {  // everyone starts with blue
        // sleeve inner ring at edges
        // measures 30.65 dia, 84.76 long
        // probably should match the length of the maze-tube before grip
        cylinder(r=(30.65 / 2), h=84.76, center=true);
        // collar
        // diameter 40.03
        cylinder(r=20, h=82.74, center=true);
        // body diameter 50.03
        cylinder(r=25, h=64.22, center=true);
    }
// todo: revomaze label
}


module revo_sleeve(c="blue") {
  difference() {
    revo_shell_v1(c);
    revo_tube_space();
  }
}

module revo_shell_v1(c="blue") {  // everyone starts with blue
// create revo surface texture

// concentric bands
// diameter 49.02 (vs. 50.03 for raised parts)
// lengths
//   raise: 4.5 5 5 5 5 5 5 5 4.5
//   lower:    7 1 1 1 1 1 1 7
// total added: 64
// should total 64.2

    // sleeve inner ring at edges
    // measures 30.65 dia, 84.76 long
    // probably should match the length of the maze-tube before grip
    inner_ring_r = (30.65 /2);
    inner_ring_len = 84.76;

    // collar diameter 40.03
    collar_r = (40.0 /2);
    // collar length (total end-to-end, not each collar)
    collar_len = 82.74;

    // stacked ring ribs
    // body length = 64.2
    // body diameter tall = 50.03
    // body diameter short= 49.02
    body_l_d = 50;
    body_l_r = (body_l_d /2);
    body_s_d = 49;
    body_s_r = (body_s_d /2);

    body_len = 64.2;

    color(c) {

        // inner ring edge
        cylinder(r=inner_ring_r, h=inner_ring_len, center=true);

        // collar
        cylinder(r=collar_r, h=collar_len, center=true);

        // attempting stacked ring version
        // body_s cylinder for the entire lengeth
        cylinder(r=body_s_r, h=body_len, center=true);
        // then the body_l rings where needed
        // todo: put a nice parameterized function here

        // half height = 32.11
        translate([0,0,-32.11])
        cylinder(r=25, h=4.5);

        // translate([0,0,(-32.11 + 4.5 + 7)])
        translate([0,0,-20.61])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6)])
        translate([0,0,-14.61])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6)])
        translate([0,0,-8.61])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6 + 6)])
        translate([0,0,-2.61])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6 + 6 + 6)])
        translate([0,0,3.39])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6 + 6 + 6 + 6)])
        translate([0,0,9.39])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6 + 6 + 6 + 6 + 6)])
        translate([0,0,15.39])
        cylinder(r=25, h=5);

        // translate([0,0,(-32.11 + 4.5 + 7 + 6 + 6 + 6 + 6 + 6 + 6 + 5 +7)])
        translate([0,0,27.39])
        cylinder(r=25, h=4.55);

    } // color
}

function revo_body_dia() = 50.03;

function revo_collar_r() = (40.0 /2); // collar diameter 40.03
function revo_collar_len() = 82.74;   // collar length (total end-to-end, not each collar)
function revo_shell_len() = 64.2;     // body between collars
function revo_collar_width() = ((revo_collar_len() - revo_shell_len()) /2); // width of one collar

module revo_tube_and_bar(t="silver", b="grey") {
    revo_draw_bar(b);
    revo_tube(t);
}

module revo_maze(c="blue", t="silver", b="grey") {
    revo_tube_and_bar(t,b);
    revo_sleeve(c);
}

module revo_certificate(center=false) {
    // measured certificate at just short of 62mm x 92mm (rounded to nearest mm)
    // selected 0.1mm thickness arbitrarily, instead of creating a 2D object.
    color("green")
      cube([92, 62, 0.1], center);
}

function revo_certificate_size() = [92, 62, 0];  // 3.62 x 2.44 imperials

// V3 certificates are miniture dollhouse size
// These appear to be manually cut from photo-paper and may vary noticibly
// from one to the next.  The one I measured was 47.82mm x 32.11mm
// rounding and adding a little buffer here for reasonable use
module revo_mini_certificate(center=false) {
    // selected 0.1mm thickness arbitrarily, instead of creating a 2D object.
    color("green")
      cube([48, 33, 0.1], center);
}

function revo_mini_certificate_size() = [48, 33, 0];


// certificate test
* translate([50,-30,0]) {
    revo_certificate();
}

* translate([46,1,0]) {
    rotate([90,0,0])
    revo_draw_bar();
}

// basic example blue revomaze.
rotate([90,0,0])
revo_maze();
