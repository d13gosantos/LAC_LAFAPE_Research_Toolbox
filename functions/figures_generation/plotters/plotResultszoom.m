function  [fhandle,lgnd,phandle] = plotResultszoom(fhArray,phArray,...
                                                    axhArray,xlimZoom,ylimZoom)
    %Function to zoom the figure
    %Results from multple data and the same x vector unit (e.g. time (s))
    % Create figure
    %Gets all the information of the first figure
    fhandle = makefighandle(fhArray{1});
    set(fhandle,'Visible','on');
    axes1 = axes('Parent',fhandle);
    
    hold(axes1,'on');
    cellfun(@(p) plot(p.XData,p.YData,'LineWidth',p.LineWidth,...,
        'Color',p.Color,'LineStyle',p.LineStyle), ...
        phArray,'UniformOutput',false);
    phandle = gca;
    hold off;
    
    xlabel(axes1,'Time (s)','FontName','Latin Modern Roman','Interpreter',...
        'latex','Fontsize',14);
    ylabel(axes1,[],'FontName','Latin Modern Roman','Interpreter','latex',...
        'Fontsize',14);
    %     ylabel(axes1,['$' axeshandleArray{1}.YLabel.String '$'],'FontName',...
    %         'Latin Modern Roman',...,
    %             'Interpreter','latex','Fontsize',14);
    
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
    hold(axes1,'off');
    
    if min(ylims_max) < 0.10*max(ylims_max)
       plotZoom(fhandle,xlimZoom,ylimZoom);      
    end
    
    %     if ~isempty(figPath)
    %         savesimfigs(fhandle,'figname',fhandle.Name,...
    %             'figfolder',fullfile(figPath),'figformats',{'jpg','fig','pdf'});
    %     end
%     if ~isempty(figPath)
%         savesimfigs(fhandle,'figname',[fhArray{1}.Name],...
%             'figfolder',fullfile(figPath,'_Comparations'),...
%             'formatsFolders',{'JPG','FIG','PDF'},...
%             'figformats',{'jpg','fig','pdf'});
%     end
    
%     function plotZoom()
%         axes2 = axes('Parent',fighandle,...
%             'Position',[0.195714285714286 0.281086231538828,...
%             0.272857142857143 0.248487374940448]);
%         hold(axes2,'on');
%         
%         cellfun(@(p) plot(p.XData,p.YData,'LineWidth',p.LineWidth,...,
%             'Color',p.Color,'LineStyle',p.LineStyle), ...
%             plothandleArray,'UniformOutput',false);
%         %     phandle = findobj()
%         xlim(axes2,xlimZoom);
%         ylim(axes2,ylimZoom);
%         setExponent(axes2);
%         box(axes2,'on');
%         hold(axes2,'off');
%         % Set the remaining axes properties
%         set(axes2,'FontSize',12,'LineWidth',1,'TickLabelInterpreter','latex');
%     end
      
    
end



