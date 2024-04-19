function [figParams, figParser] = parse_multiplefigures(varargin)
    %PARSE_PAPERFIGURE Summary of this function goes here
    %   Detailed explanation goes here
     %Define parser
    figParser = inputParser;
    default_FigureStyle = 'IEEE';
    default_figname = 'Figure_1';
    default_xlabel = '';
    default_ylabel = '';
    default_Visible = 'on';
    default_legends = '';
    default_axis = 1;
    
    addParameter(figParser,'FigureStyle',default_FigureStyle,@ischar);
    addParameter(figParser,'FigureName',default_figname,@ischar);
    addParameter(figParser,'xlabel',default_xlabel,@ischar);
    addParameter(figParser,'ylabel',default_ylabel,@ischar);
    addParameter(figParser,'Visible',default_Visible,@ischar);
    addParameter(figParser,'AxNumber',default_axis,@inumber);
    
    lValidationFcn = @(x) iscell(x) || ischar(x);
    addParameter(figParser,'Legend',default_legends,lValidationFcn);
    
    parse(figParser,varargin{:});
   
   % figParams.FigureStyle = figParser.Results.PaperStyle;
   % figParams.FigureName = figParser.Results.FigureName;
    figParams.xlabel = figParser.Results.xlabel;
    figParams.ylabel = figParser.Results.ylabel;
    figParams.Visible  = figParser.Results.Visible;
    figParams.AxNumber  = figParser.Results.AxNumber;
    %figParams.Legend  = figParser.Results.Legend;
    
%      switch figParams.FigureStyle
%         case 'IEEE'
%             defaultAxSize = 8;
%         case 'Elsevier'
%             defaultAxSize = 7.5;
%          case 'MATLAB'
%             defaultAxSize = 10;       
%         otherwise
%             defaultAxSize = 8;      
%      end
     %figParams.defaultAxSize = defaultAxSize;
end

