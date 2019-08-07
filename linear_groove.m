clc;

Lx  = 38.1;     %.. groove length (X)
Ly  = 0;     %.. groove length (Y)
h   = 9.5/2;    %.. square depth
Fl  = 150;   %.. linear feedrate
Fd  = 10;    %.. plunge feedrate
zinc = 0.3;  %.. depth increment

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');
fprintf('N3 G00 Z1\n');
fprintf('N4 G00 X0 Y0\n');

N = 5;

zdiv = h / zinc;
zdiv = round(zdiv, 0);

out = true;

for z = linspace(-h / zdiv, -h, zdiv - 1)

	fprintf('N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;

	x = 0;
	y = 0;

	if out
		x = Lx;
		y = Ly;
	end

	fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', N, x, y, Fl); N = N + 1;

	out = ~out;
end

fprintf('N%d G00 Z1\n', N); N = N + 1;
fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
fprintf('N%d M30', N);