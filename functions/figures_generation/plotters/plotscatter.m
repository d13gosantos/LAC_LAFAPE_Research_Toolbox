function [fhandle,phandle,axhandle] = plotscatter(x,y,figname,xname,yname,...,
        visible,legends)
    %Plot a specified parameter in a struct
    %Defines if the plot result will be saved
    %INPUT: VECTOR, VECTOR
    %matrix2plot = downsample([x y],downrate);
    %Include a parser for the legends and for visibility
    
    fhandle = figure('Name',figname,'visible',visible);
    axhandle  = axes('Parent',fhandle);
    setpaperaxes(axhandle,xname,yname,8);
    
%     axhandle = axes('Parent',fhandle,'TickLabelInterpreter','latex',...,
%         'LineWidth',1,'FontSize',10);
    
    hold(axhandle,'on');
    if min(size(y)) > 1
        phandle = scatter(x,y,'filled');
        phandle.LineWidth = 0.1;
        phandle.MarkerEdgeColor= [0 0 0];
        phandle.Marker= '.';
        phandle.MarkerFaceColor = [0 0 0];
        
    else
        phandle = scatter(x,y);
        phandle.LineWidth = 0.1;
        phandle.MarkerEdgeColor= [0 0 0];
        phandle.Marker= '.';
        phandle.MarkerFaceColor = [0 0 0];
        
    end
    
    % s.MarkerFaceColor = [0 0.5 0.5];
    
%     xlabel(xname,'FontName','Latin Modern Roman',...
%         'Interpreter','latex','Fontsize',10);
%     ylabel(axhandle,yname,'FontName',...
%         'Latin Modern Roman','Interpreter','latex','Fontsize',10);
    
    % Set the remaining axes properties
    %
    
     setylim(axhandle,y); %Set the ylim to the maximum value
    
    xlim(axhandle,[min(min(x)) max(max(x))]);
    
    setpaperfigsize(fhandle); %Set the figure size
    
    set(axhandle,'LooseInset', max(get(axhandle,'TightInset'), 0.02))
    box(axhandle,'on');
    %setgrid(axhandle); %Set minor gridos
    
    if ~exist('legends','var')
        setlegend(axhandle,yname,'off');
    else
        setlegend(axhandle,legend(axhandle,legends{:}),'on');
    end
    
    hold(axhandle,'off');

   
end



