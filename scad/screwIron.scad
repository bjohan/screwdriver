include <driveLine.scad>
bodyRMin=sqrt(motorFlatR*motorFlatR+motorR*motorR);
wiringSpace = 3;
bodyWidth = driveTrainBodyL;
bodyHeight = driveTrainBodyL + wiringSpace;
bodyT = 2;

fitClearance = 0.2;
freeClearance = 0.4;
screwR = 3/2;
screwTowerR = screwR+2;



module stadiumVolume(r,h,s){
    hull(){
        cylinder(h,r,r);
        translate([s,0,0])cylinder(h,r,r);
    }
}
module stadiumShell(r, h,s, t){
    difference(){
        translate([0,0,-t]) stadiumVolume(r+t, h+2*t, s);
        stadiumVolume(r, h, s);
    }
    //cylinder(h,r,r);
    //translate([s,0,0])cylinder(h,r,r);
}


module halfVolume(){
    d = 300;
    translate([-d, 0, -d]) cube([2*d,d, 2*d]);
}

module frontHalf(){
    intersection(){
        halfVolume();
        children();
    }
}

module backHalf(){
    difference(){
        children();
        halfVolume();
        
    }
}

module mainBodyCorpus(){
    stadiumShell(bodyRMin, bodyHeight, bodyWidth, bodyT);
    cylinder(driveTrainBodyL-bodyT, bodyRMin, bodyRMin);
    translate([0,-bodyRMin,0]) cube([bodyRMin,bodyRMin*2,driveTrainBodyL-bodyT]);
    placeScrewTowers() screwTower();
}


module driveLineAssemblyCutOut(){
    rotate([0,0,90]){
    minkowski(){
        sphere(fitClearance);
        placethrustBearing() thrustBearing();
    }
    
        minkowski(){
        sphere(fitClearance);
        
        placeMotor() motor();
        
    }
    
    
        minkowski(){
        sphere(fitClearance);
        
        radBearing();
    }
    
    minkowski(){
        sphere(freeClearance);
        coupling();
    }
}
}





module mainBody(){
    
    difference(){
        mainBodyCorpus();
        cylinder(driveTrainBodyL, couplingHexR*1.5, couplingHexR*1.5);
        
        driveLineAssemblyCutOut();
        translate([0,0,-2*bodyT])cylinder(3*bodyT,couplingHexR,couplingHexR);
        
        placeScrewTowers() screw();
        
        translate([bodyWidth/2,bodyRMin,bodyHeight-11]) rotate([-90,90,180])chargerPcb(10);
        
        translate([bodyWidth/2,bodyRMin-0.4,bodyHeight/6]){ 
            /*rotate([-90,0,0]){
                minkowski(){
                    sphere(fitClearance);
                    union(){
                        switch(); 
                        switchBackBore(10);
                    }
                }
            }
            translate([0,0,bodyHeight/3]){ 
                rotate([-90,0,0]){
                    minkowski(){
                        sphere(fitClearance);
                        union(){
                            switch();
                            switchBackBore(10);
                        }
                    }
                }
            }*/
        }
        
    }
}


module screwTower(){
    rotate([90,0,0])translate([0,0,-bodyRMin])cylinder(bodyRMin*2, screwTowerR, screwTowerR);
}


module screw(){
    
    rotate([90,0,0])translate([0,0,0])cylinder(bodyRMin*2, screwR, screwR);
    rotate([-90,0,0])translate([0,0,0])cylinder(bodyRMin*2, screwR+freeClearance, screwR+freeClearance,$fn=10);
}


module placeScrewTowers(){
    translate([bodyRMin+screwTowerR,0,2]) children();
    translate([bodyRMin+screwTowerR,0,driveTrainBodyL-screwTowerR-bodyT]) children();
    translate([bodyRMin+screwTowerR+30,0,2]) children();
    translate([bodyRMin+screwTowerR+30,0,driveTrainBodyL-screwTowerR-bodyT]) children();
}


module centerCube(v){
    translate([-v[0]/2, -v[1]/2,0]) cube(v);
}

module switch(){
    bv1 = [6, 3.7, 1.5];
    bv2 = [4, 3, 0.4];
    bv3 = [2.5, 1.3, 0.6];
    pin = [8, 0.5, 0.5];
    centerCube(pin);
    centerCube(bv1);
    translate([0,0,bv1[2]]){
        centerCube(bv2);
        translate([0,0,bv2[2]]){
            centerCube(bv3);
        }
    }
    
}

module switchBackBore(l){
    bv1 = [6, 3.7, l];
    pin = [8, 0.5, l];
    translate([0,0,-l]){
        centerCube(pin);
        centerCube(bv1);
    }
}
module chargerPcb(cel=0){
    color([0,1,0]) translate([-11, -9,0])cube([22,18,1.6]);
    color([0.5,0.5,0.5]) translate([-11-1-cel, -4,1.6])cube([9+cel,8,4]);
}


frontHalf() mainBody();
//rotate([90,0,0]) backHalf() mainBody();

//rotate([-90,0,0]) frontHalf() mainBody();
//rotate([90,0,0]) backHalf() mainBody();
//driveLineAssembly();

//cylinder(driveTrainBodyL, bodyRMin,bodyRMin);