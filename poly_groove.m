%{
 PURPOSE: This function generates the g-code for a generic closed pocket comprised of 
          lines and curves

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

 - P0:   the origin point (relative to machine zero height).

 - Ps:   The points of the poly shape

 - Rs:   Radii of each intermediate step 

 - Ds:   Orientation of curve
 			- = 0: straight lines
 			- < 0: counter-clockwise curves
 			- > 0: clockwise curves

 - Ix:   X inflation thickness (+ or -).

 - Iy:   Y inflation thickness (+ or -).

 - dr:   inflation increment.

 - h:    the depth of the groove in millimeters.

 - dz:   the depth increment in millimeters.
 
 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function [N] = poly_groove(file, N, b, Fd, Fls, P0, Ps, Rs, Ds, Ix, Iy, dr, h, dz, addheader, startatorigin, addfooter)

	%.. error checking
	if (dz == 0)
		N = -1;
		return;
	end

	if (size(Ps, 1) ~= length(Rs) + 1)
		N = -1;
		return;
    	end

	if (size(Ps, 1) ~= length(Ds) + 1)
		N = -1;
		return;
	end

	if (size(Ps, 1) ~= length(Fls) + 1)
		N = -1;
		return;
	end
    
	if (dr <= 0)
		N = -1;
		return;
	end

	%.. headers
	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

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

	%.. cutting groove
	closed = true;

	if (Ps(1, 1) ~= Ps(end, 1) | Ps(1, 2) ~= Ps(end, 2))
		closed = false;
	end

	zinc = ceil(h / dz);
	ZS = linspace(h / zinc, h, zinc);

	xdiv = abs(Ix / (dr * b));
	xdiv = ceil(xdiv);

	ydiv = abs(Iy / (dr * b));
	ydiv = ceil(ydiv);

	rdiv = xdiv;
	if ydiv > rdiv
		rdiv = ydiv;
	end

	Ixs = linspace(0, Ix, rdiv);
	Iys = linspace(0, Iy, rdiv);

	if (Ix == 0 & Iy == 0)

		rdiv = 1;
		Ixs = 0;
		Iys = 0;
	end

	for Z = ZS

		for i = [1 : 1 : rdiv]

			X = Ps(1, 1);
			Y = Ps(1, 2);

			IX = Ixs(i);
			IY = Iys(i);

			if (~closed)
				fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;
			end

			fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0 + X + IX, Y0 + Y + IY); N = N + 1;

			if (~closed)
				fprintf(file, 'N%d G00 Z%.4f\n', N, -Z + Z0 + dz); N = N + 1;
			end

			fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, -Z + Z0, Fd); N = N + 1;

			for p = [2 : 1 : size(Ps, 1)]
				
				X  = Ps(p, 1);
				Y  = Ps(p, 2);
				R  = Rs(p - 1);
                		D  = Ds(p - 1);
                		Fl = Fls(p - 1);
                
				if (D == 0)
					fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, X0 + X + IX, Y0 + Y + IY, Fl); N = N + 1;
				elseif (D < 0)
					fprintf(file, 'N%d G03 X%.4f Y%.4f R%.4f F%.2f\n', N, X0 + X + IX, Y0 + Y + IY, R, Fl); N = N + 1;
				elseif (D > 0)
					fprintf(file, 'N%d G02 X%.4f Y%.4f R%.4f F%.2f\n', N, X0 + X + IX, Y0 + Y + IY, R, Fl); N = N + 1;
				end
			end
		end
	end

	%.. footers
	if (addfooter)

		fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end
