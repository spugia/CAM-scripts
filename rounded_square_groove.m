%{
 PURPOSE: This function generates the g-code for a square groove with chamfered edges.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

   ----------------
  *                *
 |                   |
 |                   |
 |                   | Ly
 |                   |
 |                   |
  *                 *  R
   ----------------
          Lx

 INPUTS:

 - file: the file that the g-code should be writen to.
         note: the file will not be closed at the end of the function.

 - N:    the current line number to start counting from. If the file already 
         contains 50 g-code then pass 'N' as '50' so the new code will be ordered
         correctly.

 - Fd:   the plunging feed rate for the mill.
         note: the maximum that the minimill can do is 150 mm/min.

 - Fl:   the translational feed rate for the mill.
         note: the maximum that the minimill can do is 150 mm/min.

 - Lx:   the width of the square in the x-direction.

 - Ly:   the width of the square in the y-direction.

 - R:    the radius of the corner round

 - Z0:   the origin height (relative to machine zero height).

 - h:    the depth of the groove in millimeters.

 - dz:   the depth increment in millimeters.
 
 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function [N] = rounded_square_groove(file, N, Fd, Fl, Lx, Ly, R, Z0, h, dz, addheader, startatorigin, addfooter)

	if (Lx <= 0)
		N = -1;
		return;
	end

	if (Ly <= 0)
		N = -1;
		return;
	end

	if (R <= 0)
		N = -1;
		return;
	end

	if (R >= Lx/2 | R >= Ly/2)
		N = -1;
		return;
	end

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
		fprintf(file, 'N%d G91.1 (incremental IJ mode)\n', N); N = N + 1;
	end

	if (startatorigin)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
	end

	zdiv = h / dz;
	zdiv = round(zdiv, 0);

	orders =  [-1 1; 1 1; 1 1; 1 -1; 1 -1; -1 -1; -1 -1; -1 1];
	rorders = [ 1 0; 1 0; 0 1; 0  1; 1  0;  1  0;  0  1;  0 1];

	for z = linspace(Z0, Z0-h, zdiv)

		fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, ...
			(Lx/2 - R*rorders(1, 1))*orders(1, 1), ...
			(Ly/2 - R*rorders(1, 2))*orders(1, 2), Fl); N = N + 1;

		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;

		for o = [2:8, 1]

			if mod(o, 2) == 0
				fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, ...
					(Lx/2 - R*rorders(o, 1))*orders(o, 1), ...
					(Ly/2 - R*rorders(o, 2))*orders(o, 2), Fl); N = N + 1;

			else

				fprintf(file, 'N%d G02 X%.4f Y%.4f R%.4f F%.2f\n', N, ...
					(Lx/2 - R*rorders(o, 1))*orders(o, 1), ...
					(Ly/2 - R*rorders(o, 2))*orders(o, 2), R, Fl); N = N + 1;
			end
		end
	end

	if (addfooter)
	
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end