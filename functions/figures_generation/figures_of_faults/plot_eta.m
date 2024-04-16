%Plot the results of similation
%%
%Print the results
close all;
faultStr = 'Offset_fault';
figPath = [pwd '\Figures'];
%Plot the values for eta
[hOmega,pOmega,axOmega] = plotscatter(vectors.eta,vectors.omega,...,
    'Eta_optmization','$\eta$','$\omega$','on');
%set(pOmega,'LineStyle','none', 'LineWidth',0.5,'Color',[0 0 1],'Marker','*','MarkerSize',2.5);
omegaXlim = [optparams.eta-6*etasteps optparams.eta+5*etasteps];
omegaYlim = [0.9999*optparams.omega 1.001*optparams.omega];
%omegaYlim = [0.80*optparams.omega 1.1*optparams.omega];
omegaXTick = [83.5 85.5 87.5];
setpaperfigsize(hOmega,3.0);
plotzoomscatter(hOmega,pOmega,omegaXlim,omegaYlim,omegaXTick);
%set(axOmega,'xLim',[0 12]);


%%
savesimfigs(hOmega,'figname',[hOmega.Name],...
    'figfolder',fullfile(figPath),...
    'formatsFolders',{'JPG','FIG','PDF','EPS'},...
    'figformats',{'jpg','fig','pdf','eps'});
