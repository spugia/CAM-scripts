%{
 PURPOSE: This function generates the g-code for a arc groove.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

                      ,,ggddY""""Ybbgg,,
                 ,agd""'              `""bg,
              ,gdP"           Arc         "Ybg,
            ,dP"                             "Yb,
          ,dP"                                 "Yb,
         ,8"                                     "8,
        ,8'                                       `8,
       ,8'                                         `8,
       d'                                           `b
       8                                             8
       8                                             8

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

 - P1:   first point.

 - P2:   second point

 - o:    orientation (+x upward -x downward)

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

function [N] = arc_groove(file, N, Fd, Fl, P1, P2, o, R, Z0, h, dz, addheader, startatorigin, addfooter)

	if (Fd <= 0 || Fl <= 0)
		N = -1;
		return;
	end

	if (R <= 0)
		N = -1;
		return;
	end

	if (addheader)

		fprintf(file, 'N%d G21 (absolute)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (metric)\n', N); N = N + 1;
		fprintf(file, 'N%d G17 (IJ arc mode)\n', N); N = N + 1;
	end

	if (startatorigin)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
	end

	zdiv = h / dz;
	zdiv = round(zdiv, 0);

	atone = true;

	fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, P2(1), P2(2)); N = N + 1;

	for z = linspace(Z0, Z0-h, zdiv)

		fprintf(file, 'N%d G01 Z%.4f F%.4f\n', N, z, Fd); N = N + 1;
		
		if (~atone)

			if (o < 0)
				fprintf(file, 'N%d G03 X%.4f Y%.4f R%.4f F%.2f\n', N, P2(1), P2(2), R, Fl); N = N + 1;
			else
				fprintf(file, 'N%d G02 X%.4f Y%.4f R%.4f F%.2f\n', N, P2(1), P2(2), R, Fl); N = N + 1;
			end
		else 

			if (o < 0)
				fprintf(file, 'N%d G02 X%.4f Y%.4f R%.4f F%.2f\n', N, P1(1), P1(2), R, Fl); N = N + 1;
			else
				fprintf(file, 'N%d G03 X%.4f Y%.4f R%.4f F%.2f\n', N, P1(1), P1(2), R, Fl); N = N + 1;
			end
		end

		atone = ~atone;
	end

	if (addfooter)
	
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end