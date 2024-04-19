%Script to plot results using the multiples plots

%% Plot figure with more than on axis
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
                                            
                                            