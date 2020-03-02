%.. Example Code

addpath('~/Documents/CAM-scripts');

clc;

%.. 5mm CUTTING BIT

N = 1;
b = 5;

Fd = 20;
Fl = 150;

file = fopen('~/Desktop/example.tap','w');

%.. facing top of part
Z0 = -0.25;

N = surface_face(file, N, b, Fd, Fl, [0, 0, Z0], 0.75, 50, 50, true, true, false);

%.. cutting square pocket
N = square_pocket(file, N, b, Fd, Fl, [1, 1, Z0], 10, 5, 25, 30, 10, 1, false, true, false);

%.. cutting circular pockets
N = circular_pocket(file, N, b, Fd, Fl, [20, 20, Z0], 1, 5, 0.7, 5, 1, false, false, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [20, -20, Z0], 1, 5, 0.7, 5, 1, false, false, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [-20, 20, Z0], 1, 5, 0.7, 5, 1, false, false, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [-20, -20, Z0], 1, 5, 0.7, 5, 1, false, false, true, false);

%.. adding bolt holes
holes = [];

for theta = linspace(0, 360, 7)

	holes(end+1, :) = [20*cosd(theta), 20*sind(theta)];
end

N = drill_holes(file, N, Fd, holes, Z0, 10, false, true, true);

fclose(file);