b = 9.525;

R = 25 + b/2

X1 = 0;
Y1 = R;

X2 = 0;
Y2 = -R;

h   = 10;    %.. square depth
Fl  = 150;   %.. linear feedrate
Fd  = 150;    %.. plunge feedrate
zinc = 2;  %.. depth increment

clc;

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');
fprintf('N3 G00 Z1\n');
fprintf('N4 G00 X%.4f Y%.4f\n', X1, Y1);

N = 5;

zdiv = h / zinc;
zdiv = round(zdiv, 0);

atone = true;

for z = linspace(-h / zdiv, -h, zdiv - 1)

	fprintf('N%d G01 Z%.4f F%.4f\n', N, z, Fd); N = N + 1;
	
	if (atone)

		fprintf('N%d G03 X%.4f Y%.4f R%.4f F%.2f\n', N, X2, Y2, R, Fl); N = N + 1;
	else 

		fprintf('N%d G02 X%.4f Y%.4f R%.4f F%.2f\n', N, X1, Y1, R, Fl); N = N + 1;
	end

	atone = ~atone;
end

fprintf('N%d G00 Z1\n', N); N = N + 1;
fprintf('N%d G00 X0 Y0\n', N); N = N + 1;
fprintf('N%d M30', N);