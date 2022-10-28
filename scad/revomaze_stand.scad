
// 3D Model Display Stand for a REVOMAZE puzzle
// Based on products created and sold by https://www.revohq.co.uk

/* Copyright © 2019,2022 Michael Turner */
/* This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. */
/* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. */
/* You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. */


// A 3D printable display stand for a RevoMaze puzzle.
// Intended for both unsolved and completed puzzles.
// Updated version to handle RevoMaze versions 1-3

// note: the terminiology and variable names used here have evolved
//       over the life of the project and may not always be intuitive.
//       "tube" is used here to refer to the central maze core
//       "shell" or "sleeve" mean the outer anodized aluminum colored part
//       "grip" is the end of the maze tube with the flat sides like a nut.

// note: nothing here should be taken as an example of OpenScad being used properly.

// Simple useage example:
// step 1
//   Set revo_v below to either 1 or 3 depending on the version of your REVOMAZE
//   If in doubt, the V1 stand actually works for both types
// step 2
//   jump to the bottom of this file
//   ensure both of the display options are commented out (solved_stand and unsolved_stand)
//   uncomment only one of the export parts (sleeve_holder or tube_holder)
// step 3
//   Use OpenSCAD to export the part as an STL (or whatever format you prefer)
// step 4
//   comment out the part you just exported and uncomment the other one.
//   repeat step 3 to export this other part.


// Revomaze version
// There are currently 3 revisions of the Revomaze extreme.
// for purposes of the display stand, V1 and V2 are equivelent and
// V3 only differs in not needing a place to put the drawbar.
// leaving the front feet (with the drawbar indent) off can make for
// a cleaner look if you have only V3 puzzles.
revo_v = 1;

// there is an intentional space between the sleeve arms and the maze tube arms
// at the base of the stand we add a little back in at the feet in order
// to provide enough friction to hold the pieces together but not so much
// that it tweaks the plastic.
// in a hypothetically perfect world this would be set to 1.0
// the value here may need to be adjusted for your printer, filament shrinkage, etc.
// adjust as needed for your environment.
shoe_space = 1.1;

// default height at which the tube holder is coordinated with the sleeve holder
// you shouldn't need to change this in theory, but the -1 at the end is a fudge factor.
// if your tube holder and sleeve holder don't both touch the revomaze (in the unsolved
// configuration) you can make small adjustments to the fudge factor here.
tube_tall = revo_body_dia()/2 - revo_tube_dia()/2 -1;
// there is a 2mm difference between where the rendered objects line up and
// where the real-world ones do.
display_tall = revo_body_dia()/2 - revo_tube_dia()/2 +1;

// thickness of the base
floor_height = 3;
// small clearance space between the floor pieces. adjust if needed.
floor_grout = 0.75;


// zoom out enough to see the thing
$vpd = 850;

// uses revomaze.scad as a model of the maze itself.
use <revomaze.scad>;

// borrowed this function from
// https://forum.openscad.org/rounded-corners-td3843.html
module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}


// now the values for the stand itself

base_x = 120;
base_y = 130;
base_z = 15;


// first the sleeve holder

module sleeve_arm(arm_height=1) {
    difference() {
        cube([revo_collar_width() -1, revo_body_dia(), revo_body_dia()/2 + arm_height]);
        translate([-0.5, revo_body_dia()/2, revo_body_dia()/2 + arm_height])
        rotate([0,90,0])
        cylinder(r=revo_collar_r() + 1, h=revo_collar_width());
        // smooth the corners
        translate([revo_collar_width()/2 - 0.1, 0, revo_body_dia()/2 + arm_height])
            rotate([0,90,0])
            fillet(4,revo_collar_width());
        translate([revo_collar_width()/2 - 0.1, revo_body_dia(), revo_body_dia()/2 + arm_height])
            rotate([0,90,180])
            fillet(4,revo_collar_width());

    }
}

module sleeve_arms(arm_height=1) {
    arm_offset = revo_shell_len()/2 + 0.5; // arbitrary 0.5 tollerance spacing

    translate([arm_offset, 0, 0])
        sleeve_arm(arm_height);

    translate([-1 * (arm_offset + revo_collar_width() - 1), 0, 0])
        sleeve_arm(arm_height);

}

module sleeve_floor(floor_height=3) {
    arm_offset = revo_shell_len()/2 + 0.5; // duplicated from sleeve_arms
    arm_x = -1 * (arm_offset + revo_collar_width() - 1);
    translate([arm_x, 0, -1 * floor_height])
        cube([revo_collar_len() - 1, revo_body_dia(), floor_height]);
}

module sleeve_holder(height=1) {
    difference() {
        union() {
          sleeve_arms(height + floor_height);
          translate([0,0,floor_height])
          sleeve_floor(floor_height);
        }

        //        translate([-1 * revo_tube_grip_len()/2,tube_y, -0.1])
        translate([0, revo_body_dia()/2, 0])
            cube([revo_tube_grip_len(), tube_y() + floor_grout, 2 * floor_height + 1], center=true);
    }
}

module sleeve_and_holder(height=1) {
    translate([0, revo_body_dia()/2, revo_body_dia()/2 + height + floor_height])
        rotate([90,0,90])
        revo_sleeve();

    sleeve_holder(height);
}


// next the maze tube holder

// these functions are just collecting some values that get reused in the following few modules
function arm_offset() = revo_tube_len()/2 + 0.5; // arbitrary 0.5 tollerance spacing
function arm_left_offset() = -1 * (arm_offset() + revo_collar_width() - 1); // adjust tollerance to match
// unlike the sleeve, the tube arm is thin at tube diameter, so make it thicker if needed
function tube_y() = revo_tube_dia();

module tube_arm(arm_height=1) {
    difference() {
        // tube_y = revo_tube_dia();
        cube([revo_grip_width() -1, tube_y(), revo_tube_dia()/2 + arm_height]);
        translate([-0.5, tube_y()/2, revo_tube_dia()/2 + arm_height])
        rotate([0,90,0])
            cylinder(r=revo_grip_r() + 0.5, h=revo_grip_width(), $fn=7);
        // smooth the corners
        translate([revo_grip_width()/2 - 0.1, 0, revo_tube_dia()/2 + arm_height])
            rotate([0,90,0])
            fillet(2,revo_grip_width());
        translate([revo_grip_width()/2 - 0.1, tube_y(), revo_tube_dia()/2 + arm_height])
            rotate([0,90,180])
            fillet(2,revo_grip_width());
    }

}

module tube_arms(arm_height=1) {
    translate([arm_offset(), 0, 0])
        tube_arm(arm_height);

    // translate([-1 * (arm_offset + revo_collar_width() -1), 0, 0])
    translate([arm_left_offset(), 0, 0])
        tube_arm(arm_height);

}


module tube_feet_v3(floor_height=3) {
    // add spacer feet to keep alignment with sleeve stand

    // tube arms are revo_grip_width -1
    // foot spacers are slightly bigger to keep sleeve stand centered
    // this is a tight fit and may require adjustments for your print/printer
    // if so, adjust shoe_space at the top of this file.
    foot_spacer_x = revo_grip_width() + shoe_space;
    foot_extend = (revo_body_dia() - tube_y())/2; // v3 version has a foot on one end
                                                  // v1 will need it on both
    foot_spacer_y = tube_y() + foot_extend;

    // left foot
    translate([arm_left_offset(), 0, 0])
        cube([foot_spacer_x, foot_spacer_y, 2 * floor_height]);

    // right foot
    right_foot = (revo_tube_grip_len() - 1)/2 - foot_spacer_x;
    translate([right_foot, 0, 0])
        cube([foot_spacer_x, foot_spacer_y, 2 * floor_height]);

}

module tube_feet_v1(floor_height=3) {
    // add spacer feet to keep alignment with sleeve stand

    // the common bits have been refactored out to the v3 moduel
    // so here we just use that and then add to it.

    // Revomazes prior to V3 had a drawbar, so lets have somewhere to put it
    bar_rad = revo_draw_bar_dia()/2;

    difference() {
        tube_feet_v3(floor_height);

        translate([0, bar_rad +1, bar_rad + floor_height])
        rotate([0,90,0])
            revo_draw_bar();
    }
}

module tube_floor(floor_height=3) {
    translate([arm_left_offset(), 0, 0])
        cube([revo_tube_grip_len() - 1, tube_y(), floor_height]);
}


module tube_holder_common(height=tube_tall) {
    tube_arms(height + floor_height);
    tube_floor(floor_height);
    tube_feet_v3(floor_height);
}

module tube_holder(height=tube_tall) {
    // move the whole thing out by enough space for the extra foot
    foot_extend = (revo_body_dia() - tube_y())/2;
    translate([0,foot_extend,0]) {
        tube_holder_common(height);
    }

    if (revo_v < 3)
        tube_feet_v1(floor_height);
}


module tube_and_holder(height=tube_tall) {
    translate([0, revo_body_dia()/2, revo_tube_dia()/2 + height + floor_height])
        rotate([90,39,90])   // the 39 is to line up the grip flats with the arms
        revo_tube();

    tube_holder(height);
}


// Putting the piecs together (and use openscad to see what it will look like)

module unsolved_stand() {
  sleeve_and_holder();
  // note: for rendering, display_tall is 2mm taller than real-world use.
  tube_and_holder(display_tall);

  // add drawbar
  floor_height = 3;
  translate([0, revo_body_dia()/2, revo_body_dia()/2 + floor_height +1])
      rotate([0,90,0])
      revo_draw_bar();
}

module solved_stand() {
  sleeve_and_holder();
  tube_tall = revo_body_dia()/2 - revo_tube_dia()/2 ;
  translate([0,-1 * (revo_body_dia() - revo_tube_dia()/2), 0])
      tube_and_holder(tube_tall);

    bar_rad = revo_draw_bar_dia()/2;
    floor_height = 3;
    if (revo_v < 3) {
        // draw bar rests in the front feet indent
        //translate([0, bar_rad +1, bar_rad + floor_height])
        translate([0, -1 * (revo_tube_dia() + bar_rad +3), bar_rad + floor_height])
        rotate([0,90,0])
          revo_draw_bar();

    } else {
        // there is no real draw bar, just a fake nub on the grip.
        // but for display purposes we just draw both parts together
        translate([0, -1 * (revo_tube_dia()/2 +1.5), revo_body_dia()/2 + floor_height])
        rotate([0,90,0])
          revo_draw_bar();
    }
}

// The photo_sleeve below is an experimental idea and currently is
// completely untested.
// an accessory for showing off your accomplishments spoiler-free
// export this to stl on it's own and place over your solved maze.
// idea: for FDM printing, mony so called "clear" filaments end up more
//       of a blurry translucent (at best), which may be good enough
//       for some situations. Otherwise, a metalic grey may werk well.
module photo_sleeve() {
    ps_r = revo_tube_dia()/2 + 0.2; // adjust for desired clearance
    outer_r = ps_r + 0.2; // adjust for the line width you'll print with
    translate([100,0,0]) // just away from the stand so they don't accidently merge without you noticing.

    difference() {
        cylinder(r=outer_r,h=45);
        translate([0,0,-1])
        cylinder(r=ps_r, h=47);
    }
}
// uncomment this to export the photo_sleeve stl
// photo_sleeve();


// Display the stand!
// ------------------

// uncomment one of these to see how it will look
// ----------------------------------------------
// unsolved_stand();
solved_stand();

// Export a part model
// -------------------

// uncomment one of these at a time to export an stl
// -------------------------------------------------
// sleeve_holder();
// tube_holder();
