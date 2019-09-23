use <threads.scad>
bearingIR = 6/2;
bearingOR = 14/2;
bearingH = 5;

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



couplingR = bearingOR;
couplingHexLength = 10;
couplingHexR=5/2+0.20;

couplingdLength = 10;
couplingDR = 3/2+0.20;
couplingDRD = 2.5/2+0.15;
couplingL = couplingHexLength+couplingdLength;




printTol = 0.4;

switchBodyLength = 20;
switchBodyW = 11;
switchPinLength = 3;
switchW = switchBodyW + switchPinLength;
switchOffset = 5;
switchBodyOR = 11;

dcDcX = 17;
dcDcY = 11;
dcDcZ = 34;

dcDcChargerOffset = 3;

electronicR = switchBodyOR;
electronicL =dcDcZ+dcDcChargerOffset+3;

bodyIR = couplingR+0.15;
bodyT = 2;
bodyOR = bodyIR+bodyT;
driveTrainBodyL = couplingL + bearingH + gearBoxL + motorL;
bodyL = driveTrainBodyL+switchBodyLength+switchOffset;

endCapL = 5;



module coupling(){
    color([0,1,0])
    difference(){
        union(){
            translate([0,0,radBearingH]){
                cylinder(couplingL-radBearingH,couplingR, couplingR);
                cylinder(couplingL+bearingH-2-radBearingH,bearingIR, bearingIR);
                
            }
            cylinder(radBearingH, radBearingIR, radBearingIR);
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

module body(){
    difference(){
        union(){
            cylinder(driveTrainBodyL, bodyOR, bodyOR);
            metric_thread (diameter= bodyOR*2+2.17, pitch=2, length=endCapL);
            
            translate([0,0,driveTrainBodyL])  tube(switchOffset, bodyT, bodyOR, switchBodyOR);
            translate([0,0,driveTrainBodyL+switchOffset]) tube(switchBodyLength, bodyT, switchBodyOR, switchBodyOR);
            placeElectronicsBody() electronicsBody();
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
        
        placeSwitch() switchCavityHole();
        
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
    placeSwitch() microSwitch();
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
        rotate([0,0,-90-45])translate([-50,0,-10])cube(100);
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

module microSwitch(body = true, lever = true, pins = true, angle = -10){
    if(body){
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
    }
    if(lever){
        color([1,0,0]) translate([7,0,1])cylinder(4,1,1);
        translate([4,1.2,1]) rotate([0,0,angle]) microSwitchLever();
    }
    
    if(pins){
        color([0.3, 0.3, 0.3]) translate([0,11,1.5]){
            translate([1.5,0,0])cube([.5,4,3]);
            translate([9,0,0])cube([.5,4,3]);
            translate([18,0,0])cube([.5,4,3]);
        }
    }
}

module switchCavity(){
    hull(){
        microSwitch(body=false, pins=false);
        microSwitch(body=false, pins=false, angle = 0);
    }
    hull(){
        microSwitch(lever = false);
        translate([-100,0,0])microSwitch(lever = false);
    }
}

module switchCavityHole(tol =0.3 ){
    minkowski(){
        switchCavity();
        sphere(tol);
            
        }
            
}

module placeSwitch(){
    translate([0,switchW/2,driveTrainBodyL+switchOffset]){
        translate([-0.3,0,switchBodyLength]) rotate([180,0,0]) rotate([0,-90,0]) children();
        translate([0.3+6,0,switchBodyLength])rotate([180,0,0]) rotate([0,-90,0]) children();
    }   
}


module battery(){
    color([0,0,1])
    cylinder(50, 7, 7);
}

module chargerPcb(cel=0){
    color([0,1,0]) translate([-11, -9,0])cube([22,18,1.6]);
    color([0.5,0.5,0.5]) translate([-11-1-cel, -4,1.6])cube([9+cel,8,4]);
}

module chargerPcbCavity(el){
    chargerPcb(el);

}

module dcDcVolume(){
    
module electronicsBody(){
}
    color([0,1,0]) translate(-[dcDcX/2, dcDcY/2, 0]) cube([dcDcX, dcDcY, dcDcZ]);
}


module placeElectronicsBody(){
    translate([0,0,bodyL]) children();
}

module electronicsBody(){
    
    difference(){
        union(){
            tube(electronicL, bodyT, electronicR, electronicR);
            difference(){
                translate([0,0,electronicL-endCapL])metric_thread(diameter= electronicR*2+2.17, pitch=2, length=endCapL);
                cylinder(electronicL, electronicR-bodyT, electronicR-bodyT);
            }
        }
        dcDcVolume();
    }
}


radBearing();

//battery();

////microSwitch();



//switchPanel();
//coupling();
//endCap();
//rotate([180,0,0]) body();
cutAwayAssembly();
//assembly();