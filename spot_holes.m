addheader = false;

holes = [0, 0;
         12.125, 0;
        -12.125, 0;
         0, 12.125;
         0, -12.125];

F = 75;   %.. plunge feed rate
d = 3.25; %.. plunge depth

N = 18;

clc;

if (addheader)
    
    fprintf('N%d G21 (absolute)\n'); N = N + 1;
    fprintf('N%d G90 (metric)\n'); N = N + 1;
end

for h = [1 : 1 : size(holes, 1)]

	fprintf('N%d G00 Z1\n', N); N = N + 1;
    fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
    fprintf('N%d G00 X%.4f Y%.4f\n', N, holes(h, 1), holes(h, 2)); N = N + 1;
    fprintf('N%d G00 Z0\n', N); N = N + 1;
    fprintf('N%d G01 Z%.4f F%.2f\n', N, -d, F); N = N + 1;
end

fprintf('N%d G00 Z1\n', N); N = N + 1;
fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
fprintf('N%d M30\n', N);