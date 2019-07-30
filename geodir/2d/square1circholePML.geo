/* PML : 
  Intern [-L,L]x[-L,L]
  Extern [-LPML,LPML]x[-LPML,LPMP]
    with LPML=L+lPML
*/

DefineConstant[
  N = {10, Name "Input/Ini1Points1Points "},
  L = {10.0, Name "Input/2Internal PML"}, // Gamma_{99}
  lPML = {0.0, Name "Input/3PML thickness"},  // Gamma_{100}
  r = {1.0, Name "Input/4Squatterer Radius"} // Gamma_{10}
];
h = L/N;
If (lPML<=h)
  lPML=10*h;
EndIf

// Center Points of circle
Point(1) = {0, 0, 0, h}; 
Point(2) = {0,r, 0, h};
Point(3) = {0,-r, 0, h};
Point(4) = {r,0, 0, h};
Point(5) = {-r,0, 0, h};
// Points on square [-L,L]x[-L,L]
Point(10) = {L, -L, 0, h};
Point(11) = {L, L, 0, h};
Point(12) = {-L,L, 0, h};
Point(13) = {-L,-L, 0, h}; 
// Points on square [-LPML,LPML]x[-LPML,LPMP]
LPML=L+lPML;
Point(20) = {LPML, -LPML, 0, h};
Point(21) = {LPML, LPML, 0, h};
Point(22) = {-LPML,LPML, 0, h};
Point(23) = {-LPML,-LPML, 0, h}; 

Point(30) = {LPML, -L, 0, h};
Point(31) = {LPML, L, 0, h};
Point(32) = {-LPML, -L, 0, h};
Point(33) = {-LPML, L, 0, h};
Point(34) = {-L,LPML, 0, h};
Point(35) = {L,LPML, 0, h};
Point(36) = {-L,-LPML, 0, h};
Point(37) = {L,-LPML, 0, h};

Line(1) = {13, 10};
Line(2) = {10, 11};
Line(3) = {11, 12};
Line(4) = {12, 13};
Circle(5) = {4, 1, 2};
Circle(6) = {2, 1, 5};
Circle(7) = {5, 1, 3};
Circle(8) = {3, 1, 4};
Line Loop(9) = {4, 1, 2, 3};
Line Loop(10) = {6, 7, 8, 5};

Plane Surface(1) = {9, 10};

Line(11) = {30, 10};
Line(12) = {37, 10};
Line(13) = {37, 20};
Line(14) = {20, 30};
Line(15) = {11, 31};
Line(16) = {31, 21};
Line(17) = {21, 35};
Line(18) = {35, 11};
Line(19) = {12, 34};
Line(20) = {34, 22};
Line(21) = {22, 33};
Line(22) = {33, 12};
Line(23) = {13, 32};
Line(24) = {32, 23};
Line(25) = {23, 36};
Line(26) = {36, 13};
Line(27) = {36, 37};
Line(28) = {30, 31};
Line(29) = {35, 34};
Line(30) = {33, 32};
Line Loop(31) = {28, -15, -2, -11};
Plane Surface(10) = {31};
Line Loop(33) = {3, 19, -29, 18};
Plane Surface(11) = {33};
Line Loop(35) = {22, 4, 23, -30};
Plane Surface(12) = {35};
Line Loop(37) = {1, -12, -27, 26};
Plane Surface(13) = {37};
Line Loop(39) = {11, -12, 13, 14};
Plane Surface(20) = {39};
Line Loop(41) = {17, 18, 15, 16};
Plane Surface(21) = {41};
Line Loop(43) = {20, 21, 22, 19};
Plane Surface(22) = {43};
Line Loop(45) = {23, 24, 25, 26};
Plane Surface(23) = {45};


Physical Surface(1) = {1};
Physical Line(10) = {8, 5, 6, 7};
Physical Line(99) = {1, 2, 3, 4};
Physical Line(100) = {28, 16, 14, 17, 29, 20, 21, 30, 24, 25, 27, 13};
Physical Surface(221) = {10};
Physical Surface(222) = {21};
Physical Surface(212) = {11};
Physical Surface(202) = {22};
Physical Surface(201) = {12};
Physical Surface(200) = {23};
Physical Surface(210) = {13};
Physical Surface(220) = {20};
