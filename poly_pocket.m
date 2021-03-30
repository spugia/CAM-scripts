%{
 PURPOSE: This function generates the g-code for a generic closed pocket comprised of 
          lines and curves

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

 - P0:   the origin point (relative to machine zero height).

 - Ps:   The points of the poly shape

 - Rs:   Radii of each intermediate step 
 			- = 0: straight lines
 			- < 0: concave lines
 			- > 0: convex lines

 - h:    the depth of the groove in millimeters.

 - dz:   the depth increment in millimeters.
 
 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function [N] = poly_pocket(file, N, Fd, Fl, P0, Ps, Rs, h, dz, addheader, startatorigin, addfooter)

	%.. error checking
	if (Fl < 0 | Fd < 0)
		N = -1;
		return;
	end

	if (dz == 0)
		N = -1;
		return;
	end

	if (size(Ps, 1) ~= length(Rs) - 1)
		N = -1;
		return;
	end

	%.. headers
	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	zinc = ceil(h/dz);

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
		fprintf(file, 'N%d G91.1 (absolute arc)\n', N); N = N + 1;	
        fprintf(file, 'N%d G17 (IJ arc mode)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	%.. cutting pocket
	ZS = linspace(h / zinc, h, zinc - 1);

	for Z = ZS

		X = Ps(1, 1);
		Y = Ps(1, 2);

		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0 + X, Y0 + Y) N = N + 1;
		fprintf(file, 'N%d G01 Z%.4f %.2F\n', Z + Z0, Fd); N = N + 1;

		for p = [1 : 1 : size(Ps, 1)]
			
			X = Ps(p, 1);
			Y = Ps(p, 2);

			if (P == 0)
				fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, X0 + X, Y0 + Y, Fl); N = N + 1;
			else
				
			end
		end
	end

	%.. footers
	if (addfooter)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end