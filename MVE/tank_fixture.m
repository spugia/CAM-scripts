addpath('../fundamentals/');

clc;

%.. Top

%.. 3/8in CUTTING BIT

N = 1;
b = 9.525;

Fd = 3;
Fl = 150;

file = fopen('~/Desktop/tank_fixture_38in_1.tap','w');
N = square_pocket(file, N, b, Fd, Fl, [0, 0, 0], 25.5, 25.5, 7.5, 0.335, true, true, true, true);
fclose(file);

file = fopen('~/Desktop/tank_fixture_38in_2.tap','w');
N = square_pocket(file, N, b, Fd, Fl, [0, 0, -7.5], 25.5, 25.5, 7.5, 0.335, true, true, true, true);
fclose(file);

%.. 3mm CUTTING BIT

N = 1;
b = 3;
bx = 29.8/2;

holes = [0 bx; 0 -bx; bx 0; -bx 0];

file = fopen('~/Desktop/tank_fixture_3mm.tap','w');

N = circular_pocket(file, N, b, Fd, Fl, [holes(1, :), 0], 0, 5, 0.9, 4.25, .25, false, true, true, false);
N = circular_pocket(file, N, b, Fd, Fl, [holes(2, :), 0], 0, 5, 0.9, 4.25, .25, false, false, false, false);
N = circular_pocket(file, N, b, Fd, Fl, [holes(3, :), 0], 0, 5, 0.9, 4.25, .25, false, false, false, false);
N = circular_pocket(file, N, b, Fd, Fl, [holes(4, :), 0], 0, 5, 0.9, 4.25, .25, false, false, false, false);

N = spot_holes(file, N, Fd, holes, -4.25, 2, true, true, true);

fclose(file);

%circular_pocket(file, N, b, Fd, Fl, P0, Di, Do, dr, h, dz, face, addheader, startatorigin, addfooter)
%linear_groove(file, N, Fd, Fl, P1, P2, Z0, h, dz, addheader, startatorigin, addfooter)
%spot_holes(file, N, F, holes, Z0, dz, addheader, startatorigin, addfooter)