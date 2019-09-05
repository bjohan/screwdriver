use <threads.scad>
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



couplingR = bearingOR;
couplingHexLength = 10;
couplingHexR=5/2+0.20;

couplingdLength = 10;
couplingDR = 3/2+0.20;
couplingDRD = 2.5/2+0.15;
couplingL = couplingHexLength+couplingdLength;

bodyIR = couplingR+0.15;
bodyT = 2;
bodyOR = bodyIR+bodyT;
bodyL = couplingL + bearingH + gearBoxL + motorL;

endCapL = 5;

printTol = 0.4;

switchBodyLength = 20;
switchBodyW = 11;
switchPinLength = 3;
switchW = switchBodyW + switchPinLength;

module coupling(){
    color([0,1,0])
    difference(){
        union(){
            cylinder(couplingL,couplingR, couplingR);
            cylinder(couplingL+bearingH-2,bearingIR, bearingIR);
        }
        translate([0,0,-1])cylinder(couplingHexLength+1, couplingHexR,couplingHexR,$fn=6);
        translate([0,0,couplingHexLength-1]) dCylinder(couplingdLength+2+bearingH, couplingDR,couplingDRD);;
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

module body(){
    difference(){
        union(){
            cylinder(bodyL, bodyOR, bodyOR);
            metric_thread (diameter= bodyOR*2+2.17, pitch=2, length=endCapL);
        }
        //translate([0,0,-1]) cylinder(couplingL+bearingH+1, bodyIR, bodyIR);
        placeBearing() minkowski(){ hull() {bearing();} sphere(printTol);};
        minkowski() { hull(){ coupling(); } sphere(printTol*2);}
        
        placeMotor() minkowski(){
            motor();
            translate([0,0,-0.1]) cylinder(0.2,0.5, 0.5);
        }
        
        minkowski(){
            hull(){
                placeMotor() gearBox();
                gearBox();
            }
            translate([0,0,-0.1])cylinder(0.2,printTol, printTol);
        }
    }
}

module placeBearing(){
    translate([0,0,couplingL]) children();
}

module placeMotor(){
    placeBearing() translate([0,0,bearingH-shaftL]) children();
}

module assembly(){
    coupling();
    placeBearing() bearing();
    placeMotor() motor();
    body();
    endCap();
}

module endCap(){
    endCapR = bodyOR+2.17+bodyT-2;
    difference(){
        translate([0,0,-bodyT])cylinder(endCapL+bodyT, endCapR, endCapR);
        metric_thread (diameter= bodyOR*2+2.17+1, pitch=2, length=endCapL+1, internal=true);
        translate([0,0,-bodyT-1]) cylinder( bodyT+2, couplingHexR, couplingHexR, $fn = 20);
    }
}



module cutAwayAssembly(){
    difference(){
    assembly();
        translate([-50,0,-10])cube(100);
    }
}

module switchPanel(){
    r = 6.5/2;
    difference(){
    cube([30, switchBodyLength, 3]);
    translate([6,10,-1])cylinder(10, r, r);
    translate([30-6,10,-1])cylinder(10, r, r);
    }
}

module microSwitchLever(){
    translate([0,-2,0])
    color([0.3, 0.3, 0.3])
    difference(){
        cube([28,2,4]);
        translate([0.4, 0.4, -1])cube([28,2,6]);
    }
}

module microSwitch(){
    color([0,0,0])
    difference(){
        cube([20, 11, 6]);
        translate([0,0,-1]){
            translate([5,8,0])
            cylinder(8,2.5/2,2.5/2);
            translate([15,8,0])
            cylinder(8,2.5/2,2.5/2);
        }
    }
    color([1,0,0]) translate([7,0,0])cylinder(4,1,1);
    translate([4,1.2,0]) rotate([0,0,-10]) microSwitchLever();
    color([0.3, 0.3, 0.3]) translate([0,11,1.5]){
        translate([1.5,0,0])cube([.5,4,3]);
        translate([9,0,0])cube([.5,4,3]);
        translate([18,0,0])cube([.5,4,3]);
    }
}

translate([0,switchW/2,bodyL+5]){
translate([-0.3,0,switchBodyLength]) rotate([180,0,0]) rotate([0,-90,0]) microSwitch();
translate([0.3+6,0,switchBodyLength])rotate([180,0,0]) rotate([0,-90,0]) microSwitch();
}




//switchPanel();
//coupling();
//endCap();
//rotate([180,0,0]) body();
//cutAwayAssembly();
assembly();