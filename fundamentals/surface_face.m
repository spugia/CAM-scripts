clc;

b = 9.525;     %.. bit size
Lx = 130.00;   %.. X facing dimension
Ly = 110.00;   %.. Y facing dimension
inc = 0.50;    %.. increment
h = 0.254;     %.. cut depth
F = 150;       %.. speed

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');

fprintf('N3 G00 Z1\n');
fprintf('N4 G00 X%.4f Y%.4f\n', 0, 0);
fprintf('N5 G00 X%.4f Y%.4f\n', -Lx/2+b/2, -Ly/2+b/2);
fprintf('N6 G01 Z%.4f F%.2f\n', -h, F);

N = 7;
div = Lx / (b*inc);
div = round(div, 0);

forward = true;

for x = linspace(-Lx/2 + b/2, Lx/2-b/2, div)

	y = Ly/2 - b/2;

	if ~forward
		y = -y;
	end

	fprintf('N%d G01 X%.4f F%.2f\n', N, x, F);
	N = N + 1;
	fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', N, x, y, F);
	N = N + 1;

	forward = ~forward;
end

fprintf('N%d G00 Z1\n', N);
N = N + 1;
fprintf('N%d G00 X0 Y0\n', N);
N = N + 1;
fprintf('N%d M30\n', N);