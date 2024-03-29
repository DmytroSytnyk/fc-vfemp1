h = 1/N;
L=10; // [0,L]x[-1,1]
r=0.3;

Point(1) = {0, 0, -1, h}; 
Point(2) = {0, L, -1, h};
Point(3) = {0, L, 1, h};
Point(4) = {0,0,1, h};

ip=newp;
For t In {1:4}
  ip=10*t;
  Point(ip) = {0,2*t, 0, h};
  ip+=1;
  Point(ip) = {0, 2*t, -r, h};
  ip+=1;
  Point(ip) = {0, 2*t, +r, h};
  ip+=1;
  Point(ip) = {0, 2*t-r, 0, h};
  ip+=1;
  Point(ip) = {0, 2*t+r, 0, h};
EndFor  
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(13) = {3, 4, 1, 2};
Line Loop(14) = {5, 6};
Line Loop(15) = {7, 8};
Line Loop(16) = {9, 10};
Line Loop(17) = {11, 12};

For t In {1:4}
  ipc=100*t;
  ip=10*t;
  Circle(ipc) = {ip+1, ip, ip+4};
  Circle(ipc+1) = {ip+4, ip, ip+2};
  Circle(ipc+2) = {ip+2, ip, ip+3};
  Circle(ipc+3) = {ip+3, ip, ip+1};
EndFor

Line Loop(404) = {400, 401, 402, 403};
Line Loop(405) = {301, 302, 303, 300};
Line Loop(406) = {201, 202, 203, 200};
Line Loop(407) = {100, 101, 102, 103};
Plane Surface(408) = {13, 404, 405, 406, 407};
Translate {L, 0, 0} {
  Duplicata { Surface{408}; }
}
Line(430) = {2, 54};
Line(431) = {3, 45};
Line(432) = {1, 50};
Line(433) = {4, 46};
Line Loop(434) = {431, -413, -430, 2};
Plane Surface(435) = {434};
Line Loop(436) = {433, 411, -432, -4};
Plane Surface(437) = {436};
Line Loop(438) = {431, 410, -433, -3};
Plane Surface(439) = {438};
Line Loop(440) = {430, -412, -432, 1};
Plane Surface(441) = {440};
Line(442) = {44, 73};
Line(443) = {41, 61};
Line(444) = {43, 63};
Line(445) = {42, 68};
Line Loop(446) = {443, -417, -442, -400};
Ruled Surface(447) = {446};
Line Loop(448) = {443, 414, -444, 403};
Ruled Surface(449) = {448};
Line Loop(450) = {444, 415, -445, 402};
Ruled Surface(451) = {450};
Line Loop(452) = {442, -416, -445, -401};
Ruled Surface(453) = {452};
Line(454) = {34, 81};
Line(455) = {31, 83};
Line(456) = {33, 88};
Line(457) = {32, 93};
Line(458) = {24, 101};
Line(459) = {103, 21};
Line(460) = {23, 108};
Line(461) = {113, 22};
Line(462) = {14, 133};
Line(463) = {11, 121};
Line(464) = {13, 123};
Line(465) = {12, 128};
Line Loop(466) = {300, 454, 418, -455};
Ruled Surface(467) = {466};
Line Loop(468) = {303, 455, 419, -456};
Ruled Surface(469) = {468};
Line Loop(470) = {420, -457, 302, 456};
Ruled Surface(471) = {470};
Line Loop(472) = {301, 457, 421, -454};
Ruled Surface(473) = {472};
Line Loop(474) = {200, 458, 422, 459};
Ruled Surface(475) = {474};
Line Loop(476) = {203, -459, 423, -460};
Ruled Surface(477) = {476};
Line Loop(478) = {202, 460, 424, 461};
Ruled Surface(479) = {478};
Line Loop(480) = {425, -458, 201, -461};
Ruled Surface(481) = {480};
Line Loop(482) = {100, 462, 429, -463};
Ruled Surface(483) = {482};
Line Loop(484) = {103, 463, 426, -464};
Ruled Surface(485) = {484};
Line Loop(486) = {102, 464, 427, -465};
Ruled Surface(487) = {486};
Line Loop(488) = {101, 465, 428, -462};
Ruled Surface(489) = {488};
Surface Loop(490) = {435, 439, 409, 437, 441, 408, 449, 447, 453, 451, 467, 473, 471, 469, 475, 481, 479, 477, 485, 483, 489, 487};
Physical Line(1) = {4};
Physical Line(2) = {411};
Physical Line(3) = {413};
Physical Line(4) = {2};
Physical Line(5) = {1};
Physical Line(6) = {432};
Physical Line(7) = {412};
Physical Line(8) = {430};
Physical Line(9) = {3};
Physical Line(10) = {433};
Physical Line(11) = {410};
Physical Line(12) = {431};
Physical Line(13) = {402, 401, 400, 403};
Physical Line(14) = {301, 300, 303, 302};
Physical Line(15) = {200, 203, 202, 201};
Physical Line(16) = {102, 101, 100, 103};
Physical Line(17) = {416, 415, 414, 417};
Physical Line(18) = {418, 421, 420, 419};
Physical Line(19) = {423, 422, 425, 424};
Physical Line(20) = {429, 428, 427, 426};
Physical Surface(10) = {447, 453, 449, 451};
Physical Surface(11) = {467, 473, 469, 471};
Physical Surface(12) = {475, 481, 479, 477};
Physical Surface(13) = {483, 489, 485, 487};
Physical Surface(1) = {408};
Physical Surface(2) = {435};
Physical Surface(3) = {409};
Physical Surface(4) = {437};
Physical Surface(5) = {439};
Physical Surface(6) = {441};
Volume(1) = {490};
Physical Volume(1) = {1};
