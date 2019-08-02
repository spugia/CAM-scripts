clc;

b  = 9.525;    %.. bit size
Lx = 110.00;   %.. X facing dimension
Lz = 26.5;      %.. facing depth
dz = 0.254;    %.. cut depth for each iteration
F  = 150;      %.. speed

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');

fprintf('N3 G00 Z1\n');
fprintf('N4 G00 X0 Y0\n');
fprintf('N5 G00 X%.4f Y0\n', -Lx/2+b/2);

N = 6;
div = Lz / dz;
div = round(div, 0);

left = true;

for z = linspace(0, -Lz, div)

	fprintf('N%d Z%.4f F%.2f\n', N, z, F);
	N = N + 1;

	x = -Lx/2+b/2;

	if ~left
		x = -x;
	end

	fprintf('N%d X%.4f F%.2f\n', N, x, F);
	N = N + 1;

	left = ~left;
end

fprintf('N%d G00 Z1\n', N);
N = N + 1;
fprintf('N%d G00 X0 Y0\n', N);
N = N + 1;
fprintf('N%d M30\n', N);