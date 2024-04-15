function ax = setExponent(ax)
    ylimMax = abs(max(ax.YLim));
    if ylimMax == 0 
        exponent = 0;
%         elseif (ylimMax <= 1) 
%             exponent = ceil(log10(ylimMax)) - 1;
    else
        exponent = ceil(log10(ylimMax)) - 1;
    end
    ax.YAxis.Exponent = exponent;
end