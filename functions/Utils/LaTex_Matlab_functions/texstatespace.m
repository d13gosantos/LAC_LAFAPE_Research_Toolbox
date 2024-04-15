function texstatespace = texstatespace(statespace,mformat)
    if isa(statespace,'cell')%Check if the statespace is a cell of matrices
        texstatespace = '';
        snames = ['ABCD'];
        for i = 1:length(statespace)
            texstatespace = [texstatespace newtexcommand(snames(i),matrix2latex(statespace{i})) char(10)];
            %Simbolic state space
        end
    else
        %is statespace
        texstatespace = texOut(nargin);
    end
    
    function texOut = texOut(args)
        %Generates tex function for the statespace matrix. Each matrix is a
        %latex variable such that A = \newcommand{\A}

        svalidation(args);
        latexA = matrix2latex(statespace.a,mformat);
        latexB = matrix2latex(statespace.b,mformat);
        latexC = matrix2latex(statespace.c,mformat);
        latexD = matrix2latex(statespace.d,mformat);

        texOut = [newtexcommand('A',latexA) char(10) newtexcommand('B',latexB) ...
            char(10) newtexcommand('C',latexC) char(10) newtexcommand('D',latexD)];

        function svalidation(vararg)
            %Validate the format of the paramaters
           if vararg == 1
                mformat = 'd';
            end
        end
    end
end






