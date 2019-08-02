clc;

X0   = 0;           %.. circle center (X)
Y0   = 0;           %.. circle center (Y)
Z0   = 0;               %.. surface plane

Do   = 21.75;        %.. outer pocket diameter
Di   = 0;           %.. inner pocket diameter
h    = 10;          %.. pocket depth

b    = 9.525;           %.. bit size
Fd   = 150;           %.. z feedrate
Fl   = 100;         %.. linear feed rate

rinc = Do/(1.5*b);           %.. number of radial division
dinc = h/3;           %.. number of z divisions

Ro = (Do - b) / 2;
Ri = (Di + b) / 2;

if (Di == 0)
	Ri = 0;
end

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');

fprintf('N3 G00 X%.4f Y%.4f Z1\n', X0, Y0);

N = 4;

for d = linspace(Z0 - (h / dinc), Z0 - h, dinc)

	fprintf('N%d G00 X%.4f Y%.4f\n', N, X0, Y0+Ri);
	N = N + 1;
	fprintf('N%d G01 Z%.4f F%.2f\n', N, d, Fd);
	N = N + 1;

	for r = linspace(Ri, Ro, rinc)

		fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', N, X0, r + Y0, Fl);
		N = N + 1;

		if (r ~= 0)
			fprintf('N%d G03 X%.4f Y%.4f I%.4f J%.4f F%.2f\n', N, X0, r + Y0, X0, Y0, Fl);
			N = N + 1;
		end
	end
end

fprintf('N%d G00 Z1\n', N);
N = N + 1;
fprintf('N%d G00 X0 Y0\n', N);
N = N + 1;
fprintf('N%d M30\n', N);