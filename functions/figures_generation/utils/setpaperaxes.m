function axhandle = setpaperaxes(axhandle,xname,yname,fontSize)
    %Set axis for IEEE format
    %fhandle = gcf

 
    if ~exist('fontSize','var')
        FontSize = 10 ;
    else 
       FontSize = fontSize;
    end
    
   set(axhandle,'TickLabelInterpreter','latex',...,
        'LineWidth',1,'FontSize',FontSize);
    xlabel(axhandle,xname,'FontName','Latin Modern Roman',...
        'Interpreter','latex','FontSize',FontSize);
    ylabel(axhandle,yname,'FontName',...
        'Latin Modern Roman','Interpreter','latex','FontSize',FontSize);
    setgrid(axhandle);
end