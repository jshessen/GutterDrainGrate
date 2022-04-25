/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  Gutter_Drain_Grate: gutter_drain_grate.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/gutter_drain_grate
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//  GNU GPLv3
//
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
//
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/



// MCAD Library Inclusion
use <MCAD/regular_shapes.scad>



/*?????????????????????????????????????????????????????????????????
??
/*???????????????????????????????????????????????????????
?? Section: Customizer
??
    Description:
        The Customizer feature provides a graphic user interface for editing model parameters.
??
???????????????????????????????????????????????????????*/
/* [Global] */
//Display Verbose Output?
$VERBOSE=1; // [1:Yes,0:No]


/* [Dimensions] */
//Pipe Diameter
PIPE_DIAMETER=1; // [0:ASTM D2729 => 3 in | 80 mm,1:ASTM D2730 => 4 in | 100 mm,2:ASTM D2731 => 6 in | 150 mm,3:SCH 40 => 0.5 in | 15 mm,4:SCH 40 => 0.75 in | 20 mm,5:SCH 40 => 1 in | 25 mm,6:SCH 40 => 1.25 in | 32 mm,7:SCH 40 => 1.5 in | 40 mm,8:SCH 40 => 2 in | 50 mm,9:SCH 40 => 2.5 in | 65 mm,10:SCH 40 => 3 in | 80 mm,11:SCH 40 => 3.5 in | 90 mm,12:SCH 40 => 4 in | 100 mm,13:SCH 40 => 5 in | 125 mm,14:SCH 40 => 6 in | 150 mm,15:SCH 40 => 8 in | 200 mm]
//Insert Into Coupling?
COUPLING=1; // [1:Yes,0:No]
//Custom Field to Override PIPE_DIAMETER Drop Down List
CUSTOM_INSIDE_DIAMETER=0; // [1:.1:210]
//Insert Depth
CUSTOM_INSERT_DEPTH=0; // [1:.1:150]
//Pipe Insert Wall/Surface Thickness
CUSTOM_INSERT_WALL_WIDTH=0; // [1:.1:10]
//Surface Diameter
CUSTOM_GRATE_DIAMETER=0; // [1:.1:210]
//Grate Slot Width
CUSTOM_GRATE_SLOT_WIDTH=0; // [1:.1:10]
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Defined/Derived Variables
*/
/* [Hidden] */
ASTM_D2729=[["ASTM D2729",3,80,82.55,1.778],["ASTM D2730",4,100,107.061,1.905],["ASTM D2731",6,150,159.385,2.54]];
SCH_40=[["SCH 40",0.5,15,21.336,2.7686],["SCH 40",0.75,20,26.67,2.8702],["SCH 40",1,25,33.401,3.3782],["SCH 40",1.25,32,42.164,3.556],["SCH 40",1.5,40,48.26,3.683],["SCH 40",2,50,60.325,3.9116],["SCH 40",2.5,65,73.025,5.1562],["SCH 40",3,80,88.9,5.4864],["SCH 40",3.5,90,101.6,5.7404],["SCH 40",4,100,114.3,6.0198],["SCH 40",5,125,141.3002,6.5532],["SCH 40",6,150,168.275,7.112],["SCH 40",8,200,219.075,8.1788]];
STANDARD_PIPE_LIST=concat(ASTM_D2729,SCH_40);
//echo(str("[",pipe_list_builder(STANDARD_PIPE_LIST),"]"));
/*
If the corresponding input variable is set to zero (0), define the working values relative to the pipe_inside_diameter
*/
PIPE_OD=STANDARD_PIPE_LIST[PIPE_DIAMETER][3];
PIPE_W=(COUPLING==0) ? STANDARD_PIPE_LIST[PIPE_DIAMETER][4] : 0;
pipe_inside_diameter=(CUSTOM_INSIDE_DIAMETER==0) ? PIPE_OD-2*PIPE_W : CUSTOM_INSIDE_DIAMETER;
pipe_insert_height=(CUSTOM_INSERT_DEPTH==0) ? pipe_inside_diameter*0.1667 : CUSTOM_INSERT_DEPTH;
wall_width=(CUSTOM_INSERT_WALL_WIDTH==0) ? pipe_inside_diameter*0.0417 : CUSTOM_INSERT_WALL_WIDTH;
grate_diameter=(CUSTOM_GRATE_DIAMETER==0) ? pipe_inside_diameter*1.1667 : CUSTOM_GRATE_DIAMETER;
grate_radius=grate_diameter/2;
grate_slot_width=(CUSTOM_GRATE_SLOT_WIDTH==0) ? pipe_inside_diameter*0.0417 : CUSTOM_GRATE_SLOT_WIDTH;

fn=($preview)?40:360;
// Constant: EPSILON
// Description: Represents the smallest positive value > 0
FLT_TRUE_MIN=1.401298e-45;
DBL_TRUE_MIN= 4.94066e-324;
EPSILON=FLT_TRUE_MIN;
// Constant: EPSILON_M
// Description: Machine epsilon is defined as the difference between 1 and the next larger floating point number.
FLT_EPSILON=1.19209e-07;    // ≈ pow(2,-23);
DBL_EPSILON=2.22e-16;       // ≈ pow(2,-52);
EPSILON_M=FLT_EPSILON;
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: Core Object Modules
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/////////////////////////////////////////////////////*/
// Module: gutter_drain_grate()
// Usage:
//   gutter_drain_grate(pipe_insert_height, pipe_inside_diameter, wall_width)
// Description:
//   Creates sample gutter drain object
// Arguments:
//   insert_height|insert_height=       height of insert
//   inside_diameter|inside_diameter=   inner diameter of the target pipe
//   wall_width|wall_width=             width of insert wall
// Examples:
if($preview) {
    gutter_drain_grate(pipe_insert_height, pipe_inside_diameter, wall_width);
} else {
    translate([0,0,pipe_insert_height+wall_width*1.25]) mirror([0,0,1])
        gutter_drain_grate(pipe_insert_height, pipe_inside_diameter, wall_width);
}
//
///////////////////////////////////////////////////////*/
module gutter_drain_grate(insert_height, inside_diameter, wall_width) {
    prefix=str("-->");
    //Create Pipe Insert
    if($VERBOSE) echo(str(prefix,"Begin Pipe Insert Creation"));
    pipe_insert(insert_height, inside_diameter, wall_width);
    if($VERBOSE) echo(str(prefix,"Complete Pipe Insert Creation"));
    
    //Create Grate Surface
    if($VERBOSE) echo(str(prefix,"Begin Grate Surface Creation"));
    translate([0,0,insert_height]) grate_surface(wall_width, grate_radius, grate_slot_width);
    if($VERBOSE) echo(str(prefix,"Complete Grate Surface Creation"));
}
/*/////////////////////////////////////////////////////*/
// Module: pipe_insert()
// Usage:
//   pipe_insert(height, diameter, wall_width)
// Description:
//   Creates the male insert for the corresponding pipe
// Arguments:
//   height|height=             height of insert
//   diameter|diameter=         inner diameter of the target pipe
//   wall_width|wall_width=     width of insert wall
//
///////////////////////////////////////////////////////*/
module pipe_insert(height, diameter, wall_width) {
    prefix=str("----> ");
    var_prefix=str("**======> ");
    var_suffix=str("**");
    
    radius=diameter/2;
    
    //Pipe Insert
    if($VERBOSE) echo(str(prefix,"Begin Insert Creation"));
    if($VERBOSE) echo(str(var_prefix,"Insert Height/Length: ",height,var_suffix));
    if($VERBOSE) echo(str(var_prefix,"Insert Width/Diameter: ",diameter,"**"));
    if($VERBOSE) echo(str(var_prefix,"Wall Width/Depth: ",wall_width,"**"));
    cylinder_tube(height,radius,wall_width, $fn=fn);
    if($VERBOSE) echo(str(prefix,"Complete Insert Creation"));
    
    //Insert Cross Support
    if($VERBOSE) echo(str(prefix,"Begin Cross Support Creation"));
    translate([0,0,height-(height/4)]){
        cube([wall_width,diameter-wall_width,height*.5],center=true);
    }
    if($VERBOSE) echo(str(prefix,"Complete Cross Support Creation"));
    
    //Insert Friction Locks
    if($VERBOSE) echo(str(prefix,"Begin Friction Lock Creation"));
    x=cos(45)*radius;
    y=sin(45)*radius;
    lock_vec=[[0,radius],[x,y],[radius,0]];
    for(coord = lock_vec){
        if($VERBOSE) echo(str(prefix,"Mirror Coordinates on X & Y Axis"));
        if($VERBOSE) echo(str(var_prefix,"Lock Coordinates: ",coord,var_suffix));
        mirror_copy([0,1,0]){
            mirror_copy(){
                translate([coord[0],coord[1],0]){
                    cylinder(h=height,r=.5, $fn=fn);
                }
            }
        }
    }
    if($VERBOSE) echo(str(prefix,"Complete Friction Lock Creation"));
}
/*/////////////////////////////////////////////////////*/
// Module: grate_surface()
// Usage:
//   grate_surface(wall_width, radius, slot_width)
// Description:
//   Creates a slotted surface to help limit debris entering the pipe
// Arguments:
//   wall_width|wall_width=     width of wall
//   radius|radius=             radius of rcylinder
//   slot_width|slot_width=     width of slot(s)
//
///////////////////////////////////////////////////////*/
module grate_surface(wall_width, radius, slot_width) {
    prefix=str("----> ");
    var_prefix=str("**======> ");
    var_suffix=str("**");
    
    thickness=wall_width*1.25;
    offset=[.7143,.6786,.6429,.5714,.4286];
    trim=[wall_width,wall_width,wall_width,wall_width,wall_width];
    x_vec=((radius*offset)-trim);
    y_vec=[for(i=[0:wall_width+slot_width:(wall_width+slot_width)*len(x_vec)]) i];
    
    if($VERBOSE) echo(str(prefix,"Begin Grate Creation"));
    //Surface
    if($VERBOSE) echo(str(prefix,"Begin Grate Surface Creation"));
    if($VERBOSE) echo(str(var_prefix,"Surface Thickness: ",thickness,var_suffix));
    difference(){
        rcylinder(h=thickness,d=radius*2,r=0.4,rd=[false,true], $fn=fn);
        if($VERBOSE) echo(str(prefix,"Complete Grate Surface Creation"));
        
        //Grate
        if($VERBOSE) echo(str(prefix,"Begin Grate Slot Creation"));
        for(i=[0:len(x_vec)-1]){
            if($VERBOSE) echo(str(prefix,"Mirror Coordinates on X & Y Axis"));
            if($VERBOSE) echo(str(var_prefix,"Slot Length: ",x_vec[i],var_suffix));
            mirror_copy([0,1,0]){
                mirror_copy(){
                    translate([x_vec[i]/2+wall_width*1.25,y_vec[i],-.1]){
                        scale([1,1,1.1])
                            stadium(x_vec[i],slot_width/2,thickness);
                        scale([1.008,1.06,1])
                            translate([0,0,thickness*1.1])
                                difference(){
                                    scale([1,1,1.1])
                                        stadium_tube(x_vec[i],slot_width/2);
                                    translate(-[x_vec[i]/2+slot_width,slot_width/2,0])
                                        cube([x_vec[i]+(2*slot_width),slot_width,thickness]);
                                }
                    }
                }
            }
        }
        if($VERBOSE) echo(str(prefix,"Complete Grate Slot Creation"));
    }
    if($VERBOSE) echo(str(prefix,"Complete Grate Creation"));
}
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: Helper Modules
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/////////////////////////////////////////////////////*/
// Module: stadium()
// Usage:
//   stadium(width,radius,height)
// Description:
//   A simple object which appends a cylinder on each end of a cube
// Arguments:
//   width|width=       width of cube
//   radius|radius=     radius of cylinder/depth of cube
//   height|height      height of cylinder/cube
//
///////////////////////////////////////////////////////*/
module stadium(width,radius,height,center=false, $fn=90) {
    scale([1,1,1]){
        union(){
            translate([(width/2),0,0]) cylinder(h=height,r=radius,center=center);
            translate([-(width/2),-(radius),0]) cube([width,2*radius,height], center=center);
            translate([-(width/2),0,0]) cylinder(h=height,r=radius,center=center);
        }
    }
}
/*/////////////////////////////////////////////////////*/
// Module: stadium_tube()
// Usage:
//   stadium_tube(height,radius)
// Description:
//   A simple object which appends a cylinder on each end of a cube
// Arguments:
//   height|height=     height of cylinder
//   radius|radius=     radius of cylinder/depth of cube
//
///////////////////////////////////////////////////////*/
module stadium_tube(height,radius, $fn=90) {
    scale([1,1,1]){
        union(){
            translate([(height/2),0,0]) sphere(r=radius);
            translate([-(height/2),0,0]) rotate(a=[90,0,90]) cylinder(h=height,r=radius);
            translate([-(height/2),0,0]) sphere(r=radius);
        }
    }
}    
/*/////////////////////////////////////////////////////*/
// Module: mirror_copy()
/*
    Description:
        A custom mirror module that retains the original
        object in addition to the mirrored one.
    https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Create_a_mirrored_object_while_retaining_the_original
//
///////////////////////////////////////////////////////*/
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();
}
/*/////////////////////////////////////////////////////*/
// Module: rcylinder()
//
//https://xyzdims.com/2020/12/28/3d-modeling-elegant-pieces-in-openscad-with-rcube-rcylinder-and-chainhull/
module rcylinder(h=2,d=1,r=0.1,rd=[true,true],$fn=40) {
    hull() { 
      translate([0,0,r]) 
         if(len(rd) && rd[0]) torus(do=d,di=r*2); else translate([0,0,-r]) cylinder(d=d,h=r);          
      translate([0,0,h-r]) 
         if(len(rd) && rd[1]) torus(do=d,di=r*2); else cylinder(d=d,h=r);
    }
}
module torus(do=2,di=0.1,a=360) {
    rotate_extrude(convexity=10,angle=a) {
       translate([do/2-di/2,0,0]) circle(d=di,$fn=20);
    }
}
//
///////////////////////////////////////////////////////*/
/*
/////////////////////////////////////////////////////////////////*/





/*#################################################################
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: Functions
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*/



//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subection: Customizer Helper
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*#####################################################*/
// Function: pipe_list_builder()
// Usage:
//   pipe_list_builder(vector)
// Description:
//   A helper function to parse a vector and construct a string suitable for Customizer

// Arguments:
//   vector|vector=     input vector/array

// *Recursion Parameters:
//   i      (0)         index variable to faciliate tail recursion
//   string ("")        return value
/*
##
#######################################################*/
function pipe_list_builder(vector,i=0,string="") =
    i==len(vector) ?
        string :
        pipe_list_builder(vector,i+1,str(string,i,":",vector[i][0]," => ",vector[i][1]," in | ",vector[i][2]," mm,"));
/*
#################################################################*/