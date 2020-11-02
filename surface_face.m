%{
 PURPOSE: This function generates the g-code for facing the top surface of a work peice.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

 ---------------------
 |                   |
 |                   |
 |                   |
 |                   | Ly
 |                   |
 |                   |
 |                   |
 ---------------------
          Lx

 INPUTS:

 - file: the file that the g-code should be writen to.
         note: the file will not be closed at the end of the function.

 - N:    the current line number to start counting from. If the file already 
         contains 50 g-code then pass 'N' as '50' so the new code will be ordered
         correctly.

 - b:    the diameter of the cutting bit in millimeters.

 - Fd:   the plunging feed rate for the mill.
         note: the maximum that the minimill can do is 150 mm/min.

 - Fl:   the translational feed rate for the mill.
         note: the maximum that the minimill can do is 150 mm/min.

 - P0:   the origin point (relative to machine zero) which the facing operation
         will be performed relative to.

 - dr:   how much the tool with increment in the 'X' direction with each pass.
         This is measured as a percentage of the tool bit diameter.

 - Lx:   the length of the facing square in the 'X' direction in millimeters.
 
 - Ly:   the length of the facing square in the 'Y' direction in millimeters.

 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function N = surface_face(file, N, b, Fd, Fl, P0, dr, Lx, Ly, addheader, startatorigin, addfooter)

	if (Lx < 0)
		return;
	end

	if (Ly < 0)
		return;
	end

	if (dr < 0)
		return;
	end

	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	xs = linspace(-Lx/2, Lx/2, ceil(Lx / (dr*b)));
	y = -Ly/2;

	flip = false;

	fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, xs(1) + X0, y + Y0, Fl); N = N + 1;	
	fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, Z0, Fd); N = N + 1;	

	for x = xs

		fprintf(file, 'N%d G01 X%.4f F%.2f\n', N, x + X0, Fl);

		if (flip)
			fprintf(file, 'N%d G01 Y%.4f F%.2f\n', N, y + Y0, Fl);
		else
			fprintf(file, 'N%d G01 Y%.4f F%.2f\n', N, -y + Y0, Fl);
		end

		N = N + 1;
		flip = ~flip;
	end

	if (addfooter)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end