use <threads.scad>
thrustthrustBearingIR = 6/2;
thrustthrustBearingOR = 14/2;
thrustthrustBearingH = 5;

radBearingOR = 10/2;
radBearingIR = 6/2;
radBearingH = 3;

motorFlatR = 10/2;
motorR = 12/2;
motorBR = 5/2;
motorBRL = 1.3;
motorL = 15;
gearBoxL = 9.5;

shaftL = 9.5;
shaftR1 = 3/2;
shaftR2 = 2.5/2;



couplingR = thrustthrustBearingOR;
couplingHexLength = 10;
couplingHexR=5/2+0.20;

couplingdLength = 10;
couplingDR = 3/2+0.20;
couplingDRD = 2.5/2+0.15;
couplingL = couplingHexLength+couplingdLength;

driveTrainBodyL = couplingL + thrustthrustBearingH + gearBoxL + motorL + motorBRL;

module coupling(){
    color([0,1,0])
    difference(){
        union(){
            translate([0,0,radBearingH]){
                cylinder(couplingL-radBearingH,couplingR, couplingR);
                cylinder(couplingL+thrustthrustBearingH-2-radBearingH,thrustthrustBearingIR, thrustthrustBearingIR);
                
            }
            cylinder(radBearingH, radBearingIR, radBearingIR);
        }
        translate([0,0,-1])cylinder(couplingHexLength+1, couplingHexR,couplingHexR,$fn=6);
        translate([0,0,couplingHexLength-1]) dCylinder(couplingdLength+2+thrustthrustBearingH, couplingDR,couplingDRD);;
    }
}

module dCylinder(l,r1,r2){
    difference(){
        cylinder(l,r1,r1, $fn = 40);
        translate([-r1,r1-(2*r1-2*r2),-1]) cube([2*r1, 2*r1, l+2]);
    }
}

module doubleFlatCylinder(l,r1,r2){
    difference(){
        cylinder(l,r1,r1, $fn = 40);
        translate([-r1,r2,-1]) cube([2*r1, 2*r1, l+2]);
        translate([-r1,-r2-2*r1,-1]) cube([2*r1, 2*r1, l+2]);
    }
}

module thrustBearing(){
    color([0,0,1])
    difference(){
        cylinder(thrustthrustBearingH, thrustthrustBearingOR, thrustthrustBearingOR);
        translate([0,0,-1])
        cylinder(thrustthrustBearingH+2, thrustthrustBearingIR, thrustthrustBearingIR);
    }
}


module radBearing(){
    color([0,0,1])
    difference(){
        cylinder(radBearingH, radBearingOR, radBearingOR);
        translate([0,0,-1])
        cylinder(radBearingH+2, radBearingIR, radBearingIR);
    }
}

module gearBox(){
    translate([-motorR, -motorFlatR,0]) cube([2*motorR, 2*motorFlatR, gearBoxL]);
}

module motor(){
    dCylinder(shaftL, shaftR1, shaftR2);
    translate([0,0,shaftL+gearBoxL]){
        doubleFlatCylinder(motorL, motorR, motorFlatR);
        translate([0,0,motorL]) cylinder(motorBRL, motorBR, motorBR); 
    }
    translate([0, 0,shaftL]) gearBox();
}


module tube(l, t, rl, rh){
    difference(){
            cylinder(l, rl, rh);
            cylinder(l, rl-t, rh-t);
            }
}

module placethrustBearing(){
    translate([0,0,couplingL]) children();
}

module placeMotor(){
    placethrustBearing() translate([0,0,thrustthrustBearingH-shaftL]) children();
}

module driveLineAssembly(){
    coupling();
    placethrustBearing() thrustBearing();
    placeMotor() motor();
    radBearing();
}






//coupling();
//endCap();
//rotate([180,0,0]) body();
//cutAwayAssembly();
//iveLineAssembly();