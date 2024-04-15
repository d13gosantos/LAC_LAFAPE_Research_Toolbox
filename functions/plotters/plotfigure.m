function [fhandle,phandle,axhandle] = plotfigure(x,y,figname,xname,yname,...,
        visible,legends)
    %Plot a specified parameter in a struct
    %Defines if the plot result will be saved
    %INPUT: VECTOR, VECTOR
    %matrix2plot = downsample([x y],downrate);
    %Include a parser for the legends and for visibility
    
    fhandle = figure('Name',figname,'visible',visible,'DefaultAxesFontSize',10);
    axhandle  = axes('Parent',fhandle);
    setpaperaxes(axhandle,xname,yname,8);
%     axhandle = axes('Parent',fhandle,'TickLabelInterpreter','latex',...,
%         'LineWidth',1,'FontSize',10);
    
    hold(axhandle,'on');
    %Test if y is a vector or matrix
    if min(size(y)) > 1
        phandle = plot(x,y,'LineWidth',1.5);
    else
        phandle = plot(x,y,'LineWidth',1.5,'Color',[0 0 0]);
    end
    
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



