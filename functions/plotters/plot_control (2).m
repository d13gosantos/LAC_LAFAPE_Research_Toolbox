%Plot the results of similation
%%
%Print the results
%close all;
%%
modelName = 'cukModelStateSpaceWithcontrol';
f_s = fbounds;
t_f = [0.1,0.1,0.1];
out = sim(modelName);
%%
obsOut = out;
faultStr = 'Offset_fault';
figPath = [pwd '\Figures'];
time = obsOut.tout;
omegaLine = optparams.omega*ones(length(time),1);

[hC,pC,axC] = plotfigure(time,obsOut.xinorm.Data,...,
    'xinorm',...
    'Time (s)','$||x-x_e||$','on');
set(pC, 'LineStyle', '-', 'LineWidth', 0.25, 'Color', [0 0 0]);
hold on
pOmega = line(axC,time,omegaLine,'LineStyle','--', 'LineWidth', 1, 'Color',...
            [0 0 0],'DisplayName','$\omega$');
pfault = line(axC,time,obsOut.fsnorm.Data,'LineStyle', '-', 'LineWidth', 2, 'Color',...
            [1 0 0],'DisplayName','$f_s$');
xBox = [axC.XLim(1) axC.XLim(2) axC.XLim(2) axC.XLim(1)];
yBox = [axC.YLim(1) axC.YLim(1) omega omega];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
xiXlim = [0.0999 0.1001];
xiYlim = [0 0.6];
%All axis or specific plot
plotZoom(hC,xiXlim,xiYlim);
setlegend([pC pOmega pfault],{'$||x-x_e||$','$\omega$','$||f_s||$'},'on','best','horizontal');
%set(axC,'XLim',[0 0.12]);
 axC.YLabel.String  ='';
 setpaperfigsize(hC,4.0); 
% subplot(2,1,1,axC);
% axDelta  = axes('Parent',hC);
% setpaperaxes(axDelta,'Time (s)','$\delta_{a}$');
% 
% subplot(2,1,2,axDelta);
%%
savesimfigs(hC,'figname',[hC.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});

%%
[hDelta,pDelta,axDelta] = plotfigure(time,obsOut.delta.Data,...,
    'delta',...
    'Time (s)','$\delta_a$','on');
setpaperfigsize(hDelta,3.5); %Set the figure size
%%
savesimfigs(hDelta,'figname',[hDelta.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});
% stateString = {'i_{L1}','i_{L2}','v_{C1}','v_{C2}'};
% stateStringeq = {'i_{L1e}','i_{L2e}','v_{C1e}','v_{C2e}'};
% legState = arrayfun(@(i) ['$x_' num2str(i) '(t)$'],1:n,...
%     'UniformOutput',false);
% %System with nominal behaviohr
% hsArray = cell(1,n);
% psArray = cell(1,n);
% axsArray = cell(1,n);

