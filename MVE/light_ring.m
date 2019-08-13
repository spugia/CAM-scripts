addpath('../fundamentals/');

clc;

%.. BACKSIDE

%.. 3/8" CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface1.tap','w');

N = 1;
b = 9.525;

Fd = 10;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, 0], 0, 50, 0.3, 0.15, false, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -0.3], 50, 82.5, 5.5, 0.3, true, false, true, true);

fclose(file);

%.. 2 mm CUTTING BIT

file = fopen('/Volumes/NO NAME/steven/light_backface2.tap','w');

N = 1;
b = 2;
Fd = 3;
Fl = 150;

N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -0.3], 0, 8, 0.5, 0.15, true, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [0, 0, -0.8], 0, 5, 2, 0.15, false, false, true, false);

R = 25-3-1;

n = 8;

holes = zeros(n, 2);

for theta = [0 : 360 / n : 360*(1-1/n)]

	holes(n, :) = [R*sind(theta), R*cosd(theta)];

	N = linear_groove(file, N, Fd, Fl, [0, 0], holes(n, :), -0.3, 0.5, 0.15, false, true, false);
end

N = spot_holes(file, N, Fd, holes, -0.3, 2, false, true, true);

fclose(file);

%linear_groove(file, N, Fd, Fl, P1, P2, Z0, h, dz, addheader, startatorigin, addfooter)
%spot_holes(file, N, F, holes, Z0, dz, addheader, startatorigin, addfooter)