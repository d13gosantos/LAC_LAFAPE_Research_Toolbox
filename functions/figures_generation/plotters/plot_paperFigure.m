function [fhandle,phandle,axhandle] = plot_paperFigure(x,y,varargin) %figname,xname,yname,...,
    %visible,legends
    % plot_paperFigure Plots a figure in a format of a specified paper with
    % different styles
    figParams = parse_paperFigure(varargin{:});
    figname = figParams.FigName;
    xlabel = figParams.xlabel;
    ylabel = figParams.ylabel;
    visible  = figParams.Visible;
    legends  = figParams.Legend;
    defaultAxSize = figParams.defaultAxSize;   
    
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



