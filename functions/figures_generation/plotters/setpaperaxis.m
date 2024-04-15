function axhandle = setpaperaxis(fhandle,xname,yname,fontSize)
    %Set axis for IEEE format
    %fhandle = gcf
    axhandle = axes('Parent',fhandle,'TickLabelInterpreter','latex',...,
        'LineWidth',1,'FontSize',10);
    
    if ~exist('fontSize','var')
        set(axhandle,'FontSize',10);
    else 
        set(axhandle,'FontSize',fontSize)
    end
    xlabel(axhandle,xname,'FontName','Latin Modern Roman',...
        'Interpreter','latex','FontSize',10);
    ylabel(axhandle,yname,'FontName',...
        'Latin Modern Roman','Interpreter','latex','FontSize',10);

end