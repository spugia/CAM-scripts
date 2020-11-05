%{
 PURPOSE: This function generates the g-code for linear pocket groove between
          two points.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

		P2

      O
     *
    *
   *
  *
 O

 P1

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

 - P1:   the first end point of the groove.

 - P2:   the second end point of the groove.

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