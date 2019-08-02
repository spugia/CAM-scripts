clc;

b = 9.525;   %.. bit size
L = 20.00;  %.. facing dimensions
inc = 0.5;  %.. increment
h = 2;      %.. cut depth
F = 100;     %.. speed
passes = 1;  %.. number of passes

fprintf('N1 G21 (absolute)\n');
fprintf('N2 G90 (metric)\n');

fprintf('N3 G00 Z1\n');
fprintf('N4 G00 X%.4f Y%.4f\n', -L, -L);
fprintf('N5 G01 Z%.4f F%.2f\n', -h, F);

N = 5;

for p = [1 : passes] 
	for x = [-L : b * inc : L]

		for y = [-L, L]
			
			fprintf('N%d G01 X%.4f Y%.4f F%.2f\n', N, x, y, F);
			N = N + 1;
		end
	end
end

fprintf('N%d G00 Z1\n', N);
N = N + 1;
fprintf('N%d G00 X0 Y0\n', N);
fprintf('M30\n');