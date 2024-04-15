function mkcolorarea(axhandle,ymin,ymax,color)
    %Create a colorfull area above a certain ylimit given by ymin and ymax
    %Gray by default
    xBox = [axhandle.XLim(1) axhandle.XLim(2) axhandle.XLim(2) axhandle.XLim(1)];
    yBox = [ymin ymin ymax ymax];
    if ~exist('color','var')
        boxColor = 'black';
    else
        boxColor = color;
    end
    patch(xBox, yBox, boxColor, 'FaceColor', boxColor, 'FaceAlpha', 0.1,...
            'LineStyle','none','DisplayName','');
end