DefineConstant[
  N = {10, Name "Input/1Points "},
  R = {10.0, Name "Input/2External Radius"},
  r = {2.0, Name "Input/3Internal Radius"},
  RR = {15.0, Name "Input/4PML Radius"}
];
h = R/N;
Point(1) = {0, 0, 0, h}; 
Point(2) = {R, 0, 0, h};
Point(3) = {-R, 0, 0, h};
Point(4) = {0,R, 0, h};
Point(5) = {0,-R, 0, h};

Point(10) = {r, 0, 0, h}; 
Point(11) = {0, r, 0, h};
Point(12) = {-r, 0, 0, h}; 
Point(13) = {0, -r, 0, h}; 

If(RR>R)
  Point(22) = {RR, 0, 0, h};
  Point(23) = {-RR, 0, 0, h};
  Point(24) = {0,RR, 0, h};
  Point(25) = {0,-RR, 0, h};
EndIf

Circle(1) = {2, 1, 4};
Circle(2) = {4, 1, 3};
Circle(3) = {3, 1, 5};
Circle(4) = {5, 1, 2};
Circle(5) = {10, 1, 11};
Circle(6) = {11, 1, 12};
Circle(7) = {12, 1, 13};
Circle(8) = {13, 1, 10};
If(RR>R)
  Circle(21) = {22, 1, 24};
  Circle(22) = {24, 1, 23};
  Circle(23) = {23, 1, 25};
  Circle(24) = {25, 1, 22};
  Line Loop(20) = {21, 22, 23, 24};
EndIf

Line Loop(9) = {2, 3, 4, 1};
Line Loop(10) = {6, 7, 8, 5};
Plane Surface(1) = {9, 10};
Physical Line(1) = {1, 2, 3, 4};
Physical Line(2) = {6, 7, 8, 5};
Physical Surface(1) = {1};
If(RR>R)
  Plane Surface(2) = {9, 20};
  Physical Surface(2) = {2};
  Physical Line(3) = {22, 23, 24, 21};
EndIf
