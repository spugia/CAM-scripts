%{
 PURPOSE: This function generates the g-code for machining a circular shaped pocket.
          The geometry consists of an outer circle and an optional inner circle with 
          the cutting space in between them.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

                      ,,ggddY""""Ybbgg,,
                 ,agd""'              `""bg,
              ,gdP"      Outer Circle      "Ybg,
            ,dP"                             "Yb,
          ,dP"         _,,ddP"""Ybb,,_         "Yb,
         ,8"         ,dP"'         `"Yb,         "8,
        ,8'        ,d"                 "b,        `8,
       ,8'        d"                     "b        `8,
       d'        d'                       `b        `b
       8         8                         8         8
       8         8       Inner Circle      8         8
       8         8                         8         8
       8         Y,                       ,P         8
       Y,         Ya                     aP         ,P
       `8,         "Ya                 aP"         ,8'
        `8,          "Yb,_         _,dP"          ,8'
         `8a           `""YbbgggddP""'           a8'
          `Yba                                 adP'
            "Yba                             adY"
              `"Yba,                     ,adP"'
                 `"Y8ba,             ,ad8P"'
                      ``""YYbaaadPP""''

 INPUTS:

 - file: the file that the g-code should be writen to.
         note: the file will not be closed at the end of the function.

 - N:    the current line number to start counting from. If the file already 
         contains 50 g-code then pass 'N' as '50' so the new code will be ordered
         correctly.

 - b:    the diameter of the cutting bit in millimeters.

 - Fd:   the plunging feed rate for the mill in mm/min.

 - Fls:  the translational feed rate for the mill in mm/min.. 
         Array of 3 values: inner edge, middle area, and outer edge.

 - P0:   the origin point that the pocket will be centered on (relative to machine zero).

 - Di:   the diameter of the inner circle (set to zero for no inner circle) in millimeters.

 - Do:   the diameter of the outer circle in millimeters.

 - dr:   radial increment as percentage of bit diameter (>= 0: inner to outer, < 0: outer to inner)

 - h:    how deep the pocket should be measured in millimeters.
 
 - dz:   how much the tool will increment in the 'Z' direction with 
         each pass measured in millimeters.

 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function [N] = circular_pocket(file, N, b, Fd, Fls, P0, Di, Do, dr, h, dz, addheader, startatorigin, addfooter)

	rdir = -1;
	if (dr < 0)
		rdir = 1;
	end

	dr = abs(dr);

	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	rinc = ceil((Do - Di) / 2 / (dr*b));
	zinc = ceil(h/dz);

	Ro = (Do - b) / 2;
	Ri = (Di + b) / 2;

	if (Di == 0)
		Ri = 0;
	end

	Zsafe = 1;

	if (addheader)

		fprintf(file, 'N%d G21 (millimeters)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (absolute dist)\n', N); N = N + 1;
		fprintf(file, 'N%d G91.1 (incremental arc)\n', N); N = N + 1;	
		fprintf(file, 'N%d G17 (XY plane)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	if rinc == 0
		rinc = 1;
	end

	zs = linspace(Z0 - h / zinc, Z0 - h, zinc);

	for n = [1 : 1 : length(zs)]

		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0+Ri); N = N + 1;
		
		if (n == 1) 
			fprintf(file, 'N%d G00 Z%.4f\n', N, Z0); N = N + 1;
		end

		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, zs(n), Fd); N = N + 1;

		rs = linspace(Ri, Ro, rinc);

		if (rdir < 0) 
			rs = flip(rs);
		end

		if (length(rs) > 1 && rs(1) == rs(2))
			rs = rs(1);
		end

		for r = rs

			Fl = Fls(2);

			if (r == Ri)
				F = Fls(1);
			elseif (r == Ro)
				F = Fls(2);
			end

			fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, X0, r + Y0, Fl);
			N = N + 1;

			if (r ~= 0)
				fprintf(file, 'N%d G03 X%.4f Y%.4f I%.4f J%.4f F%.2f\n', N, X0, r + Y0, 0, -r, Fl);
				N = N + 1;
			end
		end
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, rs(1) + Y0);
	end

	fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;

	if (addfooter)

		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end
