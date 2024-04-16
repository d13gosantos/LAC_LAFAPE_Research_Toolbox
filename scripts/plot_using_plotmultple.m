%Script to plot results using the multiples plots

%% Plot single function
clear;
t = 1:100;
y = @(t) sin(t);
figname = 'sin_function';
xname = 'Time (s)';
yname = 'sin(t)';
visible = 'on';
legends = '$\sin(t)$';
[fhandle,phandle,axhandle] = plot_paperFigure(t,y(t),'PaperStyle','IEEE','FigName',figname,...
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
[fhandle2,phandle2,axhandle2] = plot_paperFigure(t,[y(t);cos(t)],'FigName',figname,...
                                               'xlabel',xname,...,
                                                'Visible',visible,'Legend',legends);