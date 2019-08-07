clc;

cutcorners = false;

b   = 9.525;     %.. bit size
Lx  = 45;    %.. square length (X)
Ly  = 45; %62.1;    %.. square length (Y)
h   = 3.75;   %.. square depth
Fl  = 150;   %.. linear feedrate
Fd  = 3;    %.. plunge feedrate
zinc = 0.3;     %.. depth increment
rinc = 1.6; %.. radial increment (percent of bit)

X0 = 0;
Y0 = 0;
Z0 = 0;

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');
fprintf('N3 G00 Z1\n');

N = 4;

zdiv = h / zinc;
zdiv = round(zdiv, 0);

xdiv = Lx / (rinc * b);
xdiv = round(xdiv, 0);

ydiv = Ly / (rinc * b);
ydiv = round(ydiv, 0);

rdiv = xdiv;
if ydiv > rdiv
	rdiv = ydiv;
end

xs = linspace(0, Lx/2 - b/2, rdiv);
ys = linspace(0, Ly/2 - b/2, rdiv);

orders = [-1, 1; 1, 1; 1, -1; -1, -1; -1, 1];

for z = linspace(Z0 - h / zdiv, Z0 - h, zdiv - 1)

	fprintf('N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	fprintf('N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;

	for r = [1 : 1 : rdiv]

		x = xs(r);
		y = ys(r);

		for o = [1 : 1 : size(orders, 1)]

			fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', N, x*orders(o, 1) + X0, y*orders(o, 2) + Y0, Fl); N = N + 1;
		end
	end
end

if (cutcorners)

	xmax = X0 + Lx/2;
	ymax = Y0 + Ly/2;

	for o = [1 : 1 : size(orders, 1)]

		fprintf('N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
		fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', xmax*orders(o, 1), ymax*orders(o, 2), Fl); N = N + 1;
	end
end

fprintf('N%d G00 Z1\n', N); N = N + 1;
fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
fprintf('N%d M30', N);