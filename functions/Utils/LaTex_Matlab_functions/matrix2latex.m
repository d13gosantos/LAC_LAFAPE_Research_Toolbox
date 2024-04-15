function matrix2latex = matrix2latex(matrix,digit)
    %Converts a Matrix (to latex with mformat -'d' = decimal
    %For future releases implement a variable argument to define the math
    %operator to encapsule the matrix as [.( or {
    % https://www.mathworks.com/help/symbolic/numeric-to-symbolic-conversion-1.html
    %-https://www.mathworks.com/matlabcentral/answers/95028-how-can-i-create-a-latex-table-from-a-matlab-array
    %- latex_table = latex(vpa(sym(A),precision))
    % Prints in function \matrixtwo or \matrixthree in LaTex (not build-in)
    if nargin == 2
        if isa(matrix, 'sym')
            matrix2latex = change2brackets(indexsym2tex(vpa(matrix,digit))); %Converts to decimal
        else
            matrix2latex = change2brackets(padronize(matrix,digit));
        end
    else
        if isa(matrix, 'sym')
            %matrix2latex = change2brackets(indexsym2tex(matrix));
            matrix2latex = change2brackets(removemathrm(matrix));
        else
            matrix2latex = change2brackets(latex(sym(matrix)));
        end
    end
end

function matrixOut = padronize(matrix,digit)
    %Padronize the results for latex representation
    matrixOut = vpa(sym(matrix),digit);
    matrixOut = latex(matrixOut);
    matrixOut = regexprep(matrixOut,'e([-]\d*)','\\times 10^{$1}');
    matrixOut = regexprep(matrixOut,'e[+](\d*)','\\times 10^$1');
end
function newTex = change2brackets(texStr)
    %Prints matrix with brackets
    %newTex = strrep(strrep(texStr,'\left(','\ensuremath{\left['),'\right)','\right]}');
    newTex = strrep(strrep(texStr,'\left(','\left['),'\right)','\right]');
end

function texMatrix = indexsym2tex(symMatrix)
    %Converts any symbol with _ to the format name_{}
    %Needs symbolic matrix to convert
    texMatrix = latex(symMatrix);
    for i = 1:size(symMatrix,1)
        for j = 1:size(symMatrix,2)
            texMatrix = format2tex(texMatrix,symMatrix,i,j);
        end
    end
end

function texMatrix = removemathrm(symMatrix)
    %Converts any symbol with _ to the format name_{}
    %Needs symbolic matrix to convert
    texMatrix = regexprep(latex(symMatrix),'\\mathrm(\w*)','$1');
end

function format2tex = format2tex(texMatrix,symMatrix,i,j)
    %Format to tex pattern
    format2tex = strrep(texMatrix,latex(symMatrix(i,j)),texlabel(symMatrix(i,j)));
end






