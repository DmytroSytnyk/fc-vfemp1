Include "options01_data.geo";
R=10.;
h = R/N;

Function CreateCircle
  // Center Points of circle (cx,cy) with radius r
  Point(np) = {cx, cy, 0, h}; 
  Point(np+1) = {cx+r, cy, 0, h};
  Point(np+2) = {cx,cy+r, 0, h};
  Point(np+3) = {cx-r, cy, 0, h};
  Point(np+4) = {cx,cy-r, 0, h};
  Circle(np)   = {np+1, np, np+2};
  Circle(np+1) = {np+2, np, np+3};
  Circle(np+2) = {np+3, np, np+4};
  Circle(np+3) = {np+4, np, np+1};
  Physical Line(np) = {np, np+1, np+2, np+3};
Return

// Center Points of circle (-1,-2) with radius 2
cx=-1;cy=-2;r=2;np=10;
Call CreateCircle;

// Center Points of circle (0,3) with radius 0.5
cx=0;cy=3;r=0.5;np=20;
Call CreateCircle;

// Center Points of circle (2,0) with radius 0.5
cx=2;cy=0;r=0.5;np=30;
Call CreateCircle;

// Center Points of circle (0,0) with radius 10
cx=0;cy=0;r=10;np=1;
Call CreateCircle;

Line Loop(34) = {2, 3, 4, 1};
Line Loop(35) = {11, 12, 13, 10};
Line Loop(36) = {22, 23, 20, 21};
Line Loop(37) = {32, 33, 30, 31};
Plane Surface(1) = {34, 35, 36, 37};
Physical Surface(1) = {1};
