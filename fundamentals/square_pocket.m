function N = square_pocket(file, N, b, Fd, Fl, P0, Lx, Ly, h, zdiv, cutcorners, addheader, startatorigin, addfooter)

	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	if (zdiv > h)
		zdiv = h;
	end

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	xdiv = Lx / 2 / (0.9 * b);
	xdiv = ceil(xdiv);

	ydiv = Ly / 2 / (0.9 * b);
	ydiv = ceil(ydiv);

	rdiv = xdiv;
	if ydiv > rdiv
		rdiv = ydiv;
	end

	xs = linspace(0, Lx/2 - b/2, rdiv);
	ys = linspace(0, Ly/2 - b/2, rdiv);

	orders = [-1, 1; 1, 1; 1, -1; -1, -1; -1, 1];

	fprintf(file, 'N%d G00 Z%.4f\n', N, Z0); N = N + 1;

	for z = [Z0 - zdiv : -zdiv : Z0 - h]

		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;

		for r = [1 : 1 : rdiv]

			x = xs(r);
			y = ys(r);

			for o = [1 : 1 : size(orders, 1)]

				fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, x*orders(o, 1) + X0, y*orders(o, 2) + Y0, Fl); N = N + 1;
			end
		end

		if (cutcorners)

			xmax = X0 + Lx/2;
			ymax = Y0 + Ly/2;

			for o = [1 : 1 : size(orders, 1) - 1]

				fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
				fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, xmax*orders(o, 1), ymax*orders(o, 2), Fl); N = N + 1;
			end
		end
	end

	if (addfooter)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end