function [N] = linear_groove(file, N, Fd, Fl, P1, P2, Z0, h, dz, addheader, startatorigin, addfooter)

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
	end

	if (startatorigin)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
	end

	zdiv = h / dz;
	zdiv = round(zdiv, 0);

	atone = true;

	fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, P1(1), P1(2)); N = N + 1;

	for z = linspace(Z0, Z0-h, zdiv)

		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;

		x = P1(1);
		y = P1(2);

		if atone

			x = P2(1);
			y = P2(2);
		end

		fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, x, y, Fl); N = N + 1;

		atone = ~atone;
	end

	if (addfooter)
	
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end