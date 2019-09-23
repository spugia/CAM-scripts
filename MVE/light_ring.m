addpath('../fundamentals/');

clc;

%.. BACKSIDE

%.. 2mm CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface1.tap','w');

N = 1;
b = 2;

Fd = 3;
Lx = 23;
Ly = 22;

holes = [0, 0; Lx, Ly; Lx, -Ly; -Lx, Ly; -Lx, -Ly];

N = spot_holes(file, N, Fd, holes, 0, 2, true, true, true);

fclose(file);

%.. 3/8" CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface2.tap','w');

N = 1;
b = 9.525;

Fd = 10;
Fl = 150;

Z0 = 0.1;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 52, 0.85, Z0, Z0, true, true, true, true);

fclose(file);

file = fopen('/Volumes/NO NAME/steven/light_backface3.tap','w');

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -Z0], 49, 82.5, 0.95, 5.5, 0.3, true, true, true, true);

fclose(file);

%.. 2 mm CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface4.tap','w');

N = 1;
b = 2;
Fd = 3;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0],    0, 10, 0.6, 0.5, 0.15, true, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -0.5], 0, 5, 0.75, 2, 0.15, false, false, true, false);

R = 26;

n = 1;
N = 8;

holes = zeros(n, 2);

for theta = [0 : 360 / N : 360*(1-1/N)]

	holes(n, :) = [R*sind(theta), R*cosd(theta)];

	N = linear_groove(file, N, Fd, Fl, [0, 0], holes(n, :), 0, 0.5, 0.15, false, true, false);

	n = n + 1;
end

N = spot_holes(file, N, Fd, holes, -0.3, 2, false, true, true);

fclose(file);

%.. FRONT SIDE

%.. 3/8" CUTTING BIT

N = 1;
b = 9.525;

Fd = 10;
Fl = 150;

file = fopen('/Volumes/NO NAME/steven/light_topface.tap','w');

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 49-6, 0.9, 12.2-1.5, 0.25, true, true, true, true);

fclose(file);

%circular_pocket(file, N, b, Fd, Fl, P0, Di, Do, dr, h, dz, face, addheader, startatorigin, addfooter)
%linear_groove(file, N, Fd, Fl, P1, P2, Z0, h, dz, addheader, startatorigin, addfooter)
%spot_holes(file, N, F, holes, Z0, dz, addheader, startatorigin, addfooter)