%Script to plot results using the function plotfigure

%% Plot single function
clear;
t = 1:100;
y = @(t) sin(t);
figname = 'sin_function';
xname = 'Time (s)';
yname = 'sin(t)';
visible = 'on';
legends = '$\sin(t)$';
[fhandle,phandle,axhandle] = plotstyledfigure(t,y(t),'FigureStyle','IEEE','FigureName',figname,...
                                               'xlabel',xname,'ylabel',yname,...,
                                                'Visible',visible,'Legend',legends);
%% Plot figure with more than on y data
t = 1:100;
y = @(t) sin(t);
figname = 'sin_and_cos_functions';
xname = 'Time (s)';
yname = '';
visible = 'on';
legends = {'$\sin(t)$','$\cos(t)$'};
[fhandle2,phandle2,axhandle2] = plotstyledfigure(t,[y(t);cos(t)],'FigureName',figname,...
                                               'xlabel',xname,...,
                                                'Visible',visible,'Legend',legends);
                                            
%% Plot scatter
t = 1:100;
figname = 'line_t';
xname = 'Time (s)';
visible = 'on';
legends = '$line(t)$';
[fhandle3,phandle3,axhandle3] = plotscatter(t,t,'FigureName',figname,...
                                               'xlabel',xname,...,
                                                'Visible',visible,'Legend',legends);

%% Plot multiple lines in the same axis

%% Plot multiple lines in different subplots (number of subplots equals number of handles)


%% Plot two different line sets in two axis (number of handles = 2)



