function setylim(axhandle,y)
    %y is a matrix with all plots, each vector is a variable
    ymin  = min(min(y));
    ymax = max(max(y));
    if ymin < 0
        if ymax > 0
            ylim(axhandle,[ymin-0.20*abs(ymin) 1.20*ymax]);
        end
    else
        ylim(axhandle,[0 1.20*ymax]);
    end
end