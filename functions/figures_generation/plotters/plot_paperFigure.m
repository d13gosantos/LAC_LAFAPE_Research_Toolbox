function [fhandle,phandle,axhandle] = plot_paperFigure(x,y,varargin) %figname,xname,yname,...,
    %visible,legends
    % plot_paperFigure Plots a figure in a format of a specified paper with
    % different styles
    
    %Define parser
    lParser = inputParser;
    default_PaperStyle = 'IEEE';
    default_figname = 'Figure_1';
    default_xlabel = '';
    default_ylabel = '';
    default_visible = 'on';
    default_legends = '';
    
    addParameter(lParser,'PaperStyle',default_PaperStyle,@ischar);
    addParameter(lParser,'FigName',default_figname,@ischar);
    addParameter(lParser,'xlabel',default_xlabel,@ischar);
    addParameter(lParser,'ylabel',default_ylabel,@ischar);
    addParameter(lParser,'Visible',default_visible,@ischar);
    
    lValidationFcn = @(x) iscell(x) || ischar(x);
    addParameter(lParser,'Legend',default_legends,lValidationFcn);
    
    parse(lParser,varargin{:});
    
    PaperStyle = lParser.Results.PaperStyle;
    figname = lParser.Results.FigName;
    xlabel = lParser.Results.xlabel;
    ylabel = lParser.Results.ylabel;
    visible  = lParser.Results.Visible;
    legends  = lParser.Results.Legend;
    
    switch PaperStyle
        case 'IEEE'
            defaultAxSize = 8;
        case 'Elsevier'
            defaultAxSize = 7.5;
        otherwise
            defaultAxSize = 8;
            
    end
    
    fhandle = figure('Name',figname,'visible',visible,'DefaultAxesFontSize',10);
    axhandle  = axes('Parent',fhandle);
    setpaperaxes(axhandle,xlabel,ylabel,defaultAxSize);
    %     axhandle = axes('Parent',fhandle,'TickLabelInterpreter','latex',...,
    %         'LineWidth',1,'FontSize',10);
    
    hold(axhandle,'on');
    
    %Test if y is a vector or matrix
    switch min(size(y))
        case 1
            phandle = plot(x,y,'LineWidth',1.5,'Color',[0 0 0]);
        case 2
            if size(y,1) < size(y,2)
                phandle = plot(x,y(1,:),'k',x,y(2,:),'c','LineWidth',1.5);
            else
                phandle = plot(x,y(:,1),'k',x,y(:,2),'c','LineWidth',1.5);
            end
        otherwise
            phandle = plot(x,y,'LineWidth',1.5);
    end
    
    % Set the remaining axes properties
    %
    setylim(axhandle,y); %Set the ylim to the maximum value
    
    xlim(axhandle,[min(min(x)) max(max(x))]);
    
    setpaperfigsize(fhandle); %Set the figure size
    
    set(axhandle,'LooseInset', max(get(axhandle,'TightInset'), 0.02))
    box(axhandle,'on');
    %setgrid(axhandle); %Set minor gridos
    
    if strcmp(legends,'')
        setlegend(axhandle,ylabel,'Visible','off');
    else
        setlegend(axhandle,legends,'Visible','on');
    end
    
    hold(axhandle,'off');
    % legend(axhandle,legends)
end



