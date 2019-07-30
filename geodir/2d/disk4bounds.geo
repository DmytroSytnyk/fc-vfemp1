// gmsh -2 -setnumber N 3 -string "Mesh.SecondOrderLinear=1;" -order 4 -format mesh disk4bounds.geo
// N=1;
Include "options01_data.geo"; // set N as constant
h = 1/N;
R=1.;
// Center Points of circle
Point(1) = {0, 0, 0, h}; 
Point(2) = {R, 0, 0, h};
Point(3) = {-R, 0, 0, h};
Point(4) = {0,R, 0, h};
Point(5) = {0,-R, 0, h};
Circle(1) = {2, 1, 4};
Circle(2) = {4, 1, 3};
Circle(3) = {3, 1, 5};
Circle(4) = {5, 1, 2};
Line Loop(5) = {2, 3, 4, 1};
Plane Surface(1) = {5};
Physical Line(1) = {1};
Physical Line(2) = {2};
Physical Line(3) = {3};
Physical Line(4) = {4};
Physical Surface(1) = {1};

