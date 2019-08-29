couplingR = 13/2;
couplingHexLength = 10;
couplingHexR=5/2+0.25*0;

couplingdLength = 10;
couplingDR = 3/2+0.20;
couplingDRD = 2.5/2+0.15;
couplingL = couplingHexLength+couplingdLength;

bearingIR = 6/2;
bearingOR = 14/2;
bearingH = 5;

motorFlatR = 10/2;
motorR = 12/2;
motorBR = 5/2;
motorBRL = 1.3;
motorL = 15;
gearBoxL = 9.5;

shaftL = 9.5;
shaftR1 = 3/2;
shaftR2 = 2.5/2;

module coupling(){
    color([0,1,0])
    difference(){
        cylinder(couplingL,couplingR, couplingR);
        translate([0,0,-1])cylinder(couplingHexLength+1, couplingHexR,couplingHexR,$fn=6);
        translate([0,0,couplingHexLength-1]) dCylinder(couplingdLength+2, couplingDR,couplingDRD);;
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

module bearing(){
    color([0,0,1])
    difference(){
        cylinder(bearingH, bearingOR, bearingOR);
        translate([0,0,-1])
        cylinder(bearingH+2, bearingIR, bearingIR);
    }
}

module motor(){
    dCylinder(shaftL, shaftR1, shaftR2);
    translate([0,0,shaftL+gearBoxL]){
        doubleFlatCylinder(motorL, motorR, motorFlatR);
        translate([0,0,motorL]) cylinder(motorBRL, motorBR, motorBR); 
    }
    translate([-motorR, -motorFlatR,shaftL]) cube([2*motorR, 2*motorFlatR, gearBoxL]);
}

module assembly(){
    coupling();
        translate([0,0,couplingL]){
            bearing();
            translate([0,0,bearingH-shaftL]) motor();
    }
}
difference(){
assembly();
    translate([-50,0,-1])cube(100);
}