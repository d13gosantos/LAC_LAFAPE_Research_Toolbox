function fhandle = setpaperfigsize(fhandle,heigth)
    %Set the size of a figure for journal or conference papers in IEEE format
    %Fixed length but optional Height in centimeters
    set(fhandle,'Units','centimeters');
    fhandle.Position(3) = 8.86; %Length of a paper figure (in cm)
    if ~exist('heigth','var')
        fhandle.Position(4) = 7.5;
    else
        fhandle.Position(4) = heigth;
    end
    
    %fhandle.Position(4) = heigth; %Height of a paper figure
    screenposition = get(fhandle,'Position');
    set(fhandle,...
        'Color','w','PaperUnits','centimeters',...
        'PaperPositionMode','Auto',...
        'PaperSize',screenposition(3:4));
end