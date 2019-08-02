%{
holes = [0, 0;
         15, 15;
         -15, 15;
         -15, -15;
         15, -15;
         -9.525, 30;
         9.525, 30;
         30, 9.525,
         30, -9.525;
         -9.525, -30;
         9.525, -30;
         -30, 9.525,
         -30, -9.525];
%}

%%{
holes = [50.655, -37.92;
         50.655, 37.92;
        -50.655, -37.92;
        -50.655, 37.92];
%%}

F = 3;   %.. plunge feed rate
d = 2.5; %.. plunge depth

clc;

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');

N = 3;

for h = [1 : 1 : size(holes, 1)]

	fprintf('N%d G00 Z1\n', N);
	N = N + 1;
    fprintf('N%d G00 X0 Y0\n', N);
    N = N + 1;
    fprintf('N%d G00 X%.4f Y%.4f\n', N, holes(h, 1), holes(h, 2));
    N = N + 1;
    fprintf('N%d G00 Z0\n', N);
    N = N + 1;
    fprintf('N%d G01 Z%.4f F%.2f\n', N, -d, F);
    N = N + 1;
end

fprintf('N%d G00 Z1\n', N);
N = N + 1;
fprintf('N%d G00 X0 Y0\n', N);
N = N + 1;
fprintf('N%d M30\n', N);