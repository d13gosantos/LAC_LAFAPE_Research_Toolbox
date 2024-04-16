function newtexcommand = newtexcommand(commandName, texStr,nparams,optionalparam)
%Converts matrix in a LaTex variable
    switch nargin 
        case 4
            newtexcommand = ['\newcommand{\' commandName '}[' nparams '][' optionalparam ']{' texStr '}'];
        case 3
            newtexcommand = ['\newcommand{\' commandName '}[' nparams ']{' texStr '}'];
        case 2
            newtexcommand = ['\newcommand{\' commandName '}{' texStr '}'];
        otherwise
            newtexcommand = ['\newcommand{\X}{' texStr '}'];
    end
end