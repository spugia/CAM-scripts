%{
 PURPOSE: This function generates the g-code for drilling a series of holes.


 INPUTS:

 - file: the file that the g-code should be writen to.
         note: the file will not be closed at the end of the function.

 - N:    the current line number to start counting from. If the file already 
         contains 50 g-code then pass 'N' as '50' so the new code will be ordered
         correctly.

 - Fd:   the plunging feed rate for the mill.
         note: the maximum that the minimill can do is 150 mm/min.

 - holes: a 2 x N array of coordinates of the holes that will be drilled
          where the first column is the 'X' coordinates and the second
          column is the 'Y' coordinates.

 - Z0:   the origin height (relative to machine zero height).

 - h:    the drilling depth.

 - addheader: a flag to indicate whether the header code should be added to the file.
              Do this if this operation is the first in a sequence.

 - startatorigin: a flag to indicate whether the machine should move to the origin before
                  starting the machining operation. In general it is a good idea to do this.

 - addfooter: a flag to indicate whether the footer code should be added to the file.
              Do this if the operation is the last in a sequence.
%}

function [N] = drill_holes(file, N, Fd, holes, Z0, h, addheader, startatorigin, addfooter)

    Zsafe = 1;
    
    if (addheader)

        fprintf(file, 'N%d G21 (millimeters)\n', N); N = N + 1;
        fprintf(file, 'N%d G90 (absolute dist)\n', N); N = N + 1;
        fprintf(file, 'N%d G91.1 (incremental arc)\n', N); N = N + 1;   
        fprintf(file, 'N%d G17 (XY plane)\n', N); N = N + 1;
    end

    if (startatorigin)

        fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;
        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
    end

    for n = [1 : 1 : size(holes, 1)]

        fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;
        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
        fprintf(file, 'N%d G00 X%.4f Y%.4f\n', N, holes(n, 1), holes(n, 2)); N = N + 1;
        fprintf(file, 'N%d G00 Z%.4f\n', N, Z0); N = N + 1;
        fprintf(file, 'N%d G01 Z%.4f F%.2f\n', N, Z0-h, Fd); N = N + 1;
    end

    fprintf(file, 'N%d G00 Z%.4f\n', N, Zsafe); N = N + 1;

    if (addfooter)

        fprintf(file, 'N%d G00 X0 Y0\n', N); N = N + 1;
        fprintf(file, 'N%d M30\n', N);
    end
end
