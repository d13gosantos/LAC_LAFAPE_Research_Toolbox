%Plot the results of similation
%%
%Print the results
close all;
faultStr = 'Offset_fault';
figPath = [pwd '\Figures'];

%Plot the residual evaluated
%The fault k means that all sensors has faults except k
obsRes = out;
numObs = p;
uncertType = 2;
uncertFreq = 100; %10ms%
%%
sNum = 1;
t_f = [.2,.1,.1]; %Time of fault occurrence for each fault;
f_s = [fboundsmin(1),fbounds(2),fbounds(3)];
out1 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'full'; %uncertainties and df;
[hJ1,pJ1,axJ1] = plotresidual(out1,jthVec,sNum,fType,uncertFreq);
%%
savesimfigs(hJ1,'figname',[hJ1.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});
%%
sNum = 2;
t_f = [.1,.2,.1]; %Time of fault occurrence for each fault;
f_s = [fbounds(1),fboundsmin(2),fbounds(3)];
out2 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'full'; %uncertainties and df;
[hJ2,pJ2,axJ2] = plotresidual(out2,jthVec,sNum,fType,uncertFreq);
zommJ2Xlim = [0.19 0.21];
zoomJ2Ylim = [0 2];
    %     %All axis or specific plot
%axZoomJ2 = plotZoom(hJ2,zommJ2Xlim,zoomJ2Ylim);
lJ2 = legend(axJ2,'Location','northwest');

%%
savesimfigs(hJ2,'figname',[hJ2.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});

%%
sNum = 3;
t_f = [.1,.1,.2]; %Time of fault occurrence for each fault;
f_s = [fbounds(1),fbounds(2),fboundsmin(3)];
out3 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'full'; %uncertainties and df;
[hJ3,pJ3,axJ3] = plotresidual(out3,jthVec,sNum,fType,uncertFreq);
zommJ3Xlim = [0.19 0.21];
zoomJ3Ylim = [0 2];
%axZoomJ2 = plotZoom(hJ3,zommJ3Xlim,zoomJ3Ylim);
lJ3 = legend(axJ3,'Location','northwest');
%%
savesimfigs(hJ3,'figname',[hJ3.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});
%%
sNum = 1;
uncertType = 2;
t_f = [.2,.1,.1]; %Time of fault occurrence for each fault;
f_s = [fboundsmin(1),0,0];
outf1 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'single'; %uncertainties and df;
[hJf1,pJf1,axJf1] = plotresidual(outf1,jthVec,sNum,fType,uncertFreq);
%%
savesimfigs(hJf1,'figname',[hJf1.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});
%%
sNum = 2;
t_f = [.1,.2,.1]; %Time of fault occurrence for each fault;
f_s = [0,fboundsmin(2),0];
outf2 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'single'; %uncertainties and df;
[hJf2,pJf2,axJf2] = plotresidual(outf2,jthVec,sNum,fType,uncertFreq);
zommJf2Xlim = [0.19 0.21];
zoomJf2Ylim = [0 2];
    %     %All axis or specific plot
%axZoomJ2 = plotZoom(hJ2,zommJ2Xlim,zoomJ2Ylim);
lJf2 = legend(axJf2,'Location','northwest');

%%
savesimfigs(hJf2,'figname',[hJf2.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});

%%
sNum = 3;
t_f = [.1,.1,.2]; %Time of fault occurrence for each fault;
f_s = [0,0,fboundsmin(3)];
out3 = sim('cukModelStateSpaceWithcontrol');
%%
fType  = 'single'; %uncertainties and df;
[hJf3,pJf3,axJf3] = plotresidual(out3,jthVec,sNum,fType,uncertFreq);
zommJ3Xlim = [0.19 0.21];
zoomJ3Ylim = [0 2];
%axZoomJ2 = plotZoom(hJ3,zommJ3Xlim,zoomJ3Ylim);
lJf3 = legend(axJf3,'Location','northwest');
%%
savesimfigs(hJf3,'figname',[hJf3.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});


