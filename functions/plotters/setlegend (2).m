function setlegend(handle,legends,visible,location,orientation)
    if ~exist('visible','var')
        visible = 'off';
    end
    
    if ~exist('location','var')
        Location= 'best';
    else
        Location= location;
    end
    
     if ~exist('orientation','var')
        Orientation= 'vertical';
    else
        Orientation= orientation;
    end
 
    figlegend = legend(handle,legends,'Interpreter','latex');
    set(figlegend,'visible',visible,'Interpreter','latex',...
        'FontSize',8,...
        'FontName','Latin Modern Roman',...
        'Location',Location,...
        'Orientation',Orientation);
%      'Color','none',...);
end
