%{
 PURPOSE: This function generates the g-code for machining a square shaped pocket.
          The geometry consists of an outer square and an optional inner square with 
          the cutting space in between them.

 y
 ^  
 |  TOP VIEW
 |
 * ----> x
Z

 ---------------------
 |                   |
 |      --------     |
 |      |      |     |
 |      |      | Lyi | Lyo
 |      |      |     |
 |      --------     |
 |        Lxi        |
 ---------------------
          Lxo

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

 - P0:   the origin point (relative to machine zero) that the square will be centered on.

 - Lxi:  the length of the inner square in the 'X' direction in millimeters.

 - Lxo:  the length of the outer square in the 'X' direction in millimeters.
 
 - Lyi:  the length of the inner square in the 'Y' direction in millimeters.
 
 - Lyo:  the length of the outer square in the 'Y' direction in millimeters.
 
 - dr:   the radial increment as a function of bit diameter

 - h:    the depth of the pocket in millimeters

 - dz:   the depth that the mill will cut off in the 'Z' direction with each 
         layer in millimeters.

 - cutcorners: a flag to indicate whether the header code should be added to the file.
               Do this if this operation is the first in a sequence.

 - addheader: a flag to indicate whether the header code should cut out the rounded corners 
              of the pocket.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function N = square_pocket(file, N, b, Fd, Fls, P0, Lxi, Lyi, Lxo, Lyo, dr, h, dz, cutcorners, addheader, startatorigin, addfooter)

    if (length(Fls) ~= 3)
       N = -1;
       return;
    end

	if ((Lxo-Lxi)/2 < b)
		N = -1;
		return;
	end

	if ((Lyo-Lyi)/2 < b)
		N = -1;
		return;
	end

	if (Lxo <= Lxi | Lyo <= Lyi)
		N = -1;
		return;
	end

	if (dr <= 0)
		N = -1;
		return;
	end

	X0 = P0(1);
	Y0 = P0(2);
	Z0 = P0(3);

	if (dz > h)
		dz = h;
	end

    zinc = ceil(h/dz);
    dz = linspace(Z0 - h / zinc, Z0 - h, zinc);

	if (addheader)

		fprintf(file, 'N%d G21 (millimeters)\n', N); N = N + 1;
		fprintf(file, 'N%d G90 (absolute dist)\n', N); N = N + 1;
		fprintf(file, 'N%d G91.1 (incremental arc)\n', N); N = N + 1;	
		fprintf(file, 'N%d G17 (XY plane)\n', N); N = N + 1;
	end

	if (startatorigin)
		
		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, X0, Y0); N = N + 1;
	end

	xdiv = (Lxo-Lxi) / 2 / (dr * b);
	xdiv = ceil(xdiv);

	ydiv = (Lyo-Lyi) / 2 / (dr * b);
	ydiv = ceil(ydiv);

	rdiv = xdiv;
	if ydiv > rdiv
		rdiv = ydiv;
	end

	xs = linspace(Lxi/2+b/2, Lxo/2-b/2, rdiv);
	ys = linspace(Lyi/2+b/2, Lyo/2-b/2, rdiv);

	if (rdiv == 2 & xs(1) == xs(2) & ys(1) == ys(2))

		rdiv = 1;
		xs = xs(1);
		ys = ys(1);
	end

	orders = [-1, 1; 1, 1; 1, -1; -1, -1; -1, 1];

	for z = dz

		fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, orders(1, 1)*xs(1)+X0, orders(1, 2)*ys(1)+Y0); N = N + 1;
        
        if (z == dz(1))
           
            fprintf(file, 'N%d G00 Z%.4f\n', N, Z0); N = N + 1;
        end
        
		fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, z, Fd); N = N + 1;
        
		for r = [1 : 1 : rdiv]

			x = xs(r);
			y = ys(r);

			for o = [1 : 1 : size(orders, 1)]

                Fl = Fls(2);
                
                if (r == rdiv)
                    Fl = Fls(3);
                elseif (r == 1)
                    Fl = Fls(1);
                end
                
				fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, x*orders(o, 1) + X0, y*orders(o, 2) + Y0, Fl); N = N + 1;

				if cutcorners & r == rdiv & o ~= 1

					fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, (x+b/4)*orders(o, 1) + X0, (y+b/4)*orders(o, 2) + Y0, Fl); N = N + 1;
					fprintf(file, 'N%d G01 X%.4f Y%.4f F%.2f\n', N, x*orders(o, 1) + X0, y*orders(o, 2) + Y0, Fl); N = N + 1;
				end
			end
		end
	end

	if (addfooter)

		fprintf(file, 'N%d G00 Z1\n', N); N = N + 1;
		fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
		fprintf(file, 'N%d M30\n', N);
	end
end
