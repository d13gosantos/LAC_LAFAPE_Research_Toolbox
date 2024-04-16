function mkgrayarea(axhandle,ymax)
    %Create a gray area above a certain ylimit given by ymax
    xBox = [axhandle.XLim(1) axhandle.XLim(2) axhandle.XLim(2) axhandle.XLim(1)];
    yBox = [axhandle.YLim(1) axhandle.YLim(1) ymax ymax];
    patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
end