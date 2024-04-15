function  [fhandle,lgnd,phandle] = plotmultiplefigs(fhArray,phArray,...
                                                axhArray,xname,yname)
    %Results from multple data and the same x vector unit (e.g. time (s))  
    % Create figure
    %Gets all the information of the first figure
    %Results from multple data and the same x vector unit (e.g. time (s))
    % Create figure
    %Receives handles from previous figures
    %Zoom will be implemented later
    %Gets all the information of the first figure
    %Usefull to plot data with the same range in x-axis but with different
    %amount
    fhandle = makefighandle(fhArray{1});
    set(fhandle,'Visible','on');
    axes1 = axes('Parent',fhandle);
    
    hold(axes1,'on');
    cellfun(@(p) plot(p.XData,p.YData,'LineWidth',p.LineWidth,...,
        'Color',p.Color,'LineStyle',p.LineStyle), ...
        phArray,'UniformOutput',false);
    phandle = gca;
    hold off;
    
    xlabel(axes1,xname,'FontName','Latin Modern Roman','Interpreter',...
        'latex','Fontsize',14);
    ylabel(axes1,yname,'FontName','Latin Modern Roman','Interpreter','latex',...
        'Fontsize',14);
    
    % Set the remaining axes properties
    %ylim(axeshandle,[min(data)-5 1.20*max(data)]);
    xlims = cellfun(@(ax) ax.XLim,axhArray,'UniformOutput',false);
    xlims_max =  cell2mat(cellfun(@max,xlims,'UniformOutput',false));
    xlims_min =  cell2mat(cellfun(@min,xlims,'UniformOutput',false));
    xlim(axes1,[min(xlims_min) max(xlims_max)]);
    ylims = cellfun(@(ax) ax.YLim,axhArray,'UniformOutput',false);
    ylims_max =  cell2mat(cellfun(@max,ylims,'UniformOutput',false));
    ylims_min =  cell2mat(cellfun(@min,ylims,'UniformOutput',false));
    ylim(axes1,[min(ylims_min) max(ylims_max)]);
    setExponent(axes1);
    box(axes1,'off');
    grid(axes1,'off');
    
    set(fhandle, 'Units','centimeters');
    screenposition = get(fhandle,'Position');
    
    set(fhandle,...
        'Color','w','PaperUnits','centimeters',...
        'PaperPositionMode','auto',...
        'PaperSize',screenposition(3:4));
    
    set(axes1,'TickLabelInterpreter','latex',...,
        'LineWidth',1,'FontSize',12);
    
    %figlegend = legend(axes1,['$' param '$'],'Interpreter','latex');
    
    legends = cellfun(@(ax) ax.Legend.String{:},...
        axhArray,'UniformOutput',false);
    lgnd = legend(axes1,legends{:}) ;
    set(lgnd,'visible','on','Interpreter','latex',...
        'FontSize',14,...
        'FontName','Latin Modern Roman',...
        'Location','best',...,
        'Color','none');
    
%     hold(axes1,'off');
%     if min(ylims_max) < 0.10*max(ylims_max)
%         plotZoom();
%     end



end





