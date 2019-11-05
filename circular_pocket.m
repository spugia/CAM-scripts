function [N] = circular_pocket(file, N, b, Fd, Fl, P0, Di, Do, dr, h, dz, face, addheader, startatorigin, addfooter)

	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	rinc = ceil((Do - Di) / 2 / (dr*b));
	dinc = ceil(h/dz);

	Ro = (Do - b) / 2;
	Ri = (Di + b) / 2;

	if (Di == 0)
		Ri = 0;
	end

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
		fprintf(file, 'N%d G91.1 (incremental IJ mode)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	if (face)

		ds = linspace(Z0, Z0 - h, dinc);

	else 

		ds = linspace(Z0 - h / dinc, Z0 - h, dinc - 1);
	end

	if rinc == 0
		rinc = 1;
	end

	for d = ds

		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0+Ri); N = N + 1;
		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, d, Fd); N = N + 1;

		for r = linspace(Ri, Ro, rinc)

			fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, X0, r + Y0, Fl);
			N = N + 1;

			if (r ~= 0)
				fprintf(file, 'N%d G03 X%.4f Y%.4f I%.4f J%.4f F%.2f\n', N, X0, r + Y0, 0, -r, Fl);
				N = N + 1;
			end
		end
	end

	if (addfooter)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end