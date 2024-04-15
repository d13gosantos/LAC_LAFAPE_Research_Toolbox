%Plot the results of similation
%%
%Used only if the simulation is made by using ode3 or ode45. Not useful for
%simulink simulations!!

%Print the results
close all;
obsOut = out;
numObs = p;
faultStr = 'Offset_fault';
figPath = [pwd '\Figures'];
legFaults = arrayfun(@(i) ['$f_' -num2str(i) '(t)c$'],1:numObs,...
    'UniformOutput',false);
fType = 'single';
numObs = length(obsOut);
hJfinal = cell(1,numObs);
lgndFinal = cell(1,numObs);
pJfinal = cell(1,numObs);

if strcmp(fType,'single')
    resString = 'Residual_faults_obsv';
    normString = '||f||';
    normItem = 'norm_f';
    faultNumStr = '_faultNum_';
else
    resString = 'Residual_remaining_obsv';
    normString = '||d_f||';
    normItem = 'norm_df';
    faultNumStr = '_noFaultNum_';
end

% for i = 1:numObs
%Plot the residual evaluated
%The fault k means that all sensors has faults except k
time = obsOut{i}.t;
%Residual signal evaluated
[hJ,pJ,axJ] = plotfigure(time,obsOut{i}.J,...,
    [resString num2str(i) faultNumStr num2str(i),...
    '_faultType_' faultStr],...
    'Time (s)',['J_' num2str(i)],[],'off');
set(pJ, 'LineStyle', '-', 'LineWidth', 2, 'Color', [0 0 1]);
[hf,pf,af] = plotfigure(time,obsOut{i}.(normItem),...,
    ['Norm_faults_obsv' num2str(i) '_faultNum_' num2str(i),...
    '_faultType_' faultStr],...
    'Time (s)',normString,[],'off');
pf.LineStyle = '--';
pf.LineWidth = 2.5;
pf.Color = [1 0 0];
%pf.LineWidth = 1;
Jth = repmat(thVec(i),length(time),1);
[hJth,pJth,axJth] = plotfigure(time,Jth,...,
    ['Threshold_mult_faults_obsv' num2str(i) '_faultNum_' num2str(i),...
    '_faultType_' faultStr],...
    'Time (s)',['J_{th}^{' num2str(i) '}'],[],'off');
pJth.LineStyle = ':';
pJth.Color = [0 0 0];
fighandleArray = {hJ,hf,hJth};
plothandleArray = {pJ,pf,pJth};
axeshandleArray = {axJ,af,axJth};
ylimZoom = [0 1.20*thVec];
[hJfinal,lgndFinal,pJfinal] = plotResultszoom(fighandleArray,plothandleArray,...
    axeshandleArray,xlimZoom,ylimZoom);
% close all;


[hJsingle,lgndJsingle,pJsingle] = plotresidual(obsSim,faultStr,thVec,[0.149 0.151],'single');
%%
% for k = 1:p %Length of multiple fauls simulated
%     %Faults %Observer number is fixed because is the same fault
%     [hf,pf,axf] = plotfigure(obsOut{k}{1}.t,obsOut{k}{1}.f,...,
%         ['Fault_signals' num2str(1) '_faultNum_' num2str(k),...
%         '_faultType_' faultStr],...
%         'Time (s)',['$f(t)$'],[pwd '\Figures'],'on',legFaults);
%
%     close all;
% end
%%

%%
cellfun(@(hJsingle) savesimfigs(hJsingle,'figname',[hJsingle.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'}),hJsingle,'UniformOutput',false);
%%
legFaults = arrayfun(@(i) ['$f_' num2str(i) '(t)$'],1:numObs,...
    'UniformOutput',false);
[hJmult,lgndJmult,pJmult] = plotresidual(obsTh,faultStr,thVec,[0.10 0.45],'mult');

%%
cellfun(@(hJfinal) savesimfigs(hJfinal,'figname',[hJfinal.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'}),hJmult,'UniformOutput',false);

