addpath('../fundamentals/');

clc;

%.. BACKSIDE

%.. 3/8" CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface1.tap','w');

N = 1;
b = 9.525;

Fd = 10;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 6, 85, 1.25, 0.25, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -1.25], 32.25, 85, 5.6, 0.25, false, true, true);

%.. 2 mm CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface2.tap','w');

N = 1;
b = 2;

Fd = 3;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 6, 0, 0.2, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 5, 5, 0.2, false, true, false);
N = linear_groove(file, N, Fd, Fl, [-3.5, 0], [-(32.5/2-3-2), 0], 0.5, 0.2, false, true, false);
N = linear_groove(file, N, Fd, Fl, [3.5, 0], [32.5/2-3-2, 0], 0.5, 0.2, false, true, false);
N = linear_groove(file, N, Fd, Fl, [0, 3.5], [0, 32.5/2-3-2], 0.5, 0.2, false, true, false);
N = linear_groove(file, N, Fd, Fl, [0, -3.5], [0, -(32.5/2-3-2)], 0.5, 0.2, false, true, false);
N = spot_holes(file, N, Fd, [-(32.5/2-3-2), 0; 32.5/2-3-2, 0; 0, 32.5/2-3-2; 0, -(32.5/2-3-2)], -1.25, 5, false, true, true);

%.. TOPSIDE

%.. 3/8" CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_frontface.tap','w');

N = 1;
b = 9.525;

Fd = 10;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 32.25-6, 6, 0.25, true, true, true);