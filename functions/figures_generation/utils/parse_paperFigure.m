function [figParams, figParser] = parse_paperFigure(varargin)
    %PARSE_PAPERFIGURE Summary of this function goes here
    %   Detailed explanation goes here
     %Define parser
    figParser = inputParser;
    default_PaperStyle = 'IEEE';
    default_figname = 'Figure_1';
    default_xlabel = '';
    default_ylabel = '';
    default_visible = 'on';
    default_legends = '';
    
    addParameter(figParser,'PaperStyle',default_PaperStyle,@ischar);
    addParameter(figParser,'FigName',default_figname,@ischar);
    addParameter(figParser,'xlabel',default_xlabel,@ischar);
    addParameter(figParser,'ylabel',default_ylabel,@ischar);
    addParameter(figParser,'Visible',default_visible,@ischar);
    
    lValidationFcn = @(x) iscell(x) || ischar(x);
    addParameter(figParser,'Legend',default_legends,lValidationFcn);
    
    parse(figParser,varargin{:});
    
    figParams.figParser = parse_paperFigure(varargin{:});
    figParams.PaperStyle = figParser.Results.PaperStyle;
    figParams.figname = figParser.Results.FigName;
    figParams.xlabel = figParser.Results.xlabel;
    figParams.ylabel = figParser.Results.ylabel;
    figParams.visible  = figParser.Results.Visible;
    figParams.legends  = figParser.Results.Legend;
    
     switch PaperStyle
        case 'IEEE'
            defaultAxSize = 8;
        case 'Elsevier'
            defaultAxSize = 7.5;
        otherwise
            defaultAxSize = 8;      
     end
     figParams.defaultAxSize = defaultAxSize;
end

