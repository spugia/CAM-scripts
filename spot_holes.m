function [N] = spot_holes(file, N, F, holes, Z0, dz, addheader, startatorigin, addfooter)

    if (addheader)

        fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
        fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
        fprintf(file, 'N%d G91.1 (incremental IJ mode)\n', N); N = N + 1;
    end

    if (startatorigin)

        fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
    end

    for h = [1 : 1 : size(holes, 1)]

    	fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
        fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, holes(h, 1), holes(h, 2)); N = N + 1;
        fprintf(file, 'N%d G00 Z0\n', N); N = N + 1;
        fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, Z0-dz, F); N = N + 1;
    end

    if (addfooter)

        fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
        fprintf(file, 'N%d M30\n', N);
    end
end