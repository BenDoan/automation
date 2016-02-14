width = 52;
length = 71;
height = 30;
zbreak = 10;

holes = [
    [22,31.8],
    [22,-31.8],
    [-22,31.8],
    [-22,-31.8]];
hd = 2.5;
th = 2;
joins = [[24.25,42],[24.25,-42],[-32,0]];
jd = 3.5;
jl = 10;
$fn=15;
rotate([0,0,0])difference(){
difference(){
translate([0,0,height/2-zbreak])difference(){
    union(){
        cube([width+2*th,length+2*th,height+2*th],center=true);
        translate([0,0,zbreak-height/2])hull()for(h=joins){
            translate([h[0],h[1],0])
            cylinder(jl,d=jd+2*th,center=true);
        }
    }
    cube([width,length,height],center=true);
    for(h=holes){
        translate([h[0],h[1],-height/2])
        cylinder(th*3,d=hd,center=true);
    }
    for(h=joins){
        translate([h[0],h[1],0])
        cylinder(height,d=jd,center=true);
    }
}
translate([width/2,0,20])cube([14,50,40],center=true);
translate([-width/2,-length/2,20])cube([58,50,40],center=true);
}
translate([0,0,100.001])cube([200,200,200],center=true);
}