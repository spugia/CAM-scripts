addpath('../fundamentals/');

clc;

%.. BACKSIDE

%.. 3/8" CUTTING BIT

N = 1;
b = 9.525;

Fd = 150;
Fl = 150;

dz = 3;

file = fopen('/Volumes/NO NAME/steven/camera_bottom1.tap','w');
N =   square_pocket(file, N, b, Fd, Fl, [0, 0, 0], 110, 65, 1, dz, false, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -1], 0, 28, 30, dz, false, false, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -1], 35, 100, 30, dz, false, false, true, true);

fclose(file);

N = 1;
dz = 5;

file = fopen('/Volumes/NO NAME/steven/camera_bottom2.tap','w');
N =   square_pocket(file, N, b, Fd, Fl, [-110/2+15, 0, -1], 30, 65, 30, dz, false, true, true, false);
fclose(file);

file = fopen('/Volumes/NO NAME/steven/camera_bottom3.tap','w');
N =   square_pocket(file, N, b, Fd, Fl, [110/2-15, 0, -1], 30, 65, 30, dz, false, false, true, true);
fclose(file);