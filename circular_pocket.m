clc;

addheader = true;
startatorigin = true;
addfooter = true;

N = 1;             %.. starting line number

X0   = 0;           %.. circle center (X)
Y0   = 0;           %.. circle center (Y)
Z0   = 0;               %.. surface plane

Do   = 23.25;        %.. outer pocket diameter
Di   = 0;           %.. inner pocket diameter
h    = 0.0254*2;     %.. pocket depth

b    = 9.525;           %.. bit size
Fd   = 150;           %.. z feedrate
Fl   = 150;         %.. linear feed rate

rinc = 2; %round(Do/(1.5*b), 0); %.. number of radial division
dinc = 2;           %.. number of z divisions

Ro = (Do - b) / 2;
Ri = (Di + b) / 2;

if (Di == 0)
	Ri = 0;
end

if (addheader)

	fprintf('N%d G21 (absolute)\n', N); N = N + 1;
	fprintf('N%d G90 (metric)\n', N); N = N + 1;
end

if (startatorigin)
	fprintf('N%d G00 Z1\n', N); N = N + 1;
	fprintf('N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
end

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

if (addfooter)

	fprintf('N%d G00 Z1\n', N); N = N + 1;
	fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
	fprintf('N%d M30', N);
end