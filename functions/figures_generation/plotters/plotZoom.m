function axes2 = plotZoom(fhandle,xlimZoom,ylimZoom,XTick)
    %Creates another axis to zoom a figure
   
    figUnit = get(fhandle,'Units');
    axFontSize = fhandle.CurrentAxes.FontSize;    
    figpos = get(fhandle,'Position');
      axes2 = axes('Parent',fhandle,...
        'Units',figUnit,'Position',[0.30*figpos(1) 0.175*figpos(2),...
        0.30*figpos(3) 0.20*figpos(4)],'FontSize',axFontSize,...
        'LineWidth',1,'TickLabelInterpreter','latex');
 
 
    hold(axes2,'on');
    p = findobj(fhandle,'Type','Line');
    for i = 1:length(p)
        plot(axes2,p(i).XData,p(i).YData,'LineWidth',p(i).LineWidth,...,
            'Color',p(i).Color,'LineStyle',p(i).LineStyle,'Marker',p(i).Marker,...
            'MarkerSize',p(i).MarkerSize);
    end
    xlim(axes2,xlimZoom);
    ylim(axes2,ylimZoom);
    %setExponent(axes2);
    box(axes2,'on');
    hold(axes2,'off');
    % Set the remaining axes properties
    set(axes2,'FontSize',axFontSize,'LineWidth',1,'TickLabelInterpreter','latex');
    if exist('XTick','var')
        set(axes2,'XTick',XTick);
    end
    %set(lgn,'Location','best');
end