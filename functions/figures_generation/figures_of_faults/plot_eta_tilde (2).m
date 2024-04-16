%Plot the results of similation
%%
%Print the results
close all;
obsOut = out;
numObs = length(obsOut);
faultStr = 'Offset_fault';
figPath = [pwd '\Figures'];
legFaults = arrayfun(@(i) ['$f_' -num2str(i) '(t)c$'],1:numObs,...
    'UniformOutput',false);
%%

% for i = 1:numObs
%     [hOmegafdr{i},pOmegafdr{i},axOmegafdr{i}] = plotfigure(outParams{i}.eta,outParams{i}.omega_fdr,...,
%         'Eta_optmization','\eta',['\omega_{fdr}^{' num2str(i) '}'],[],'off');
%     set(pOmegafdr{i},'LineStyle', lineVec{i}, 'LineWidth', 1.5, 'Color', rgbVec{i});
%     set(axOmegafdr{i},'xLim',[0 12]);
%    [hOmegafr{i},pOmegafr{i},axOmegafr{i}]= plotfigure(outParams{i}.eta,outParams{i}.omega_fr,...
%                                                'Eta_{fr}','\eta',...
%                                                 ['\Omega_{fr}^{' num2str(i) '}'],[],'off');
%     set(pOmegafr{i}, 'LineStyle', lineVec{i}, 'LineWidth', 2, 'Color', rgbVec{i});
%     [hOmegadr{i},pOmegadr{i},axOmegadr{i}] = plotfigure(outParams{i}.eta,...
%                                                 outParams{i}.omega_dr,'Eta_{dr}','\eta',...
%                                   ['\Omega_{dr}^{' num2str(i) '}'],[],'off');
%       set(pOmegadr{i}, 'LineStyle', lineVec{i}, 'LineWidth', 2, 'Color', rgbVec{i});
% end


%Plot the values for eta
rgbVec= {[0 0 1],[0 1 0],[1 0 0],[0 0 0]};
lineVec = {'-','--','-.',':'};
hOmegafdr{i} = cell(1,numObs);
pOmegafdr{i}=cell(1,numObs);
axOmegafdr{i}=cell(1,numObs);
hOmegafr{i} = cell(1,numObs);
pOmegafr{i}=cell(1,numObs);
axOmegafr{i}=cell(1,numObs);
hOmegadr{i} = cell(1,numObs);
pOmegadr{i}=cell(1,numObs);
axOmegadr{i}=cell(1,numObs);

% for i = 1:numObs
%     [hOmegafdr{i},pOmegafdr{i},axOmegafdr{i}] = plotfigure(outParams{i}.eta,outParams{i}.omega_fdr,...,
%         'Eta_optmization','\eta',['\omega_{fdr}^{' num2str(i) '}'],[],'off');
%     set(pOmegafdr{i},'LineStyle', lineVec{i}, 'LineWidth', 1.5, 'Color', rgbVec{i});
%     set(axOmegafdr{i},'xLim',[0 12]);
%    [hOmegafr{i},pOmegafr{i},axOmegafr{i}]= plotfigure(outParams{i}.eta,outParams{i}.omega_fr,...
%                                                'Eta_{fr}','\eta',...
%                                                 ['\Omega_{fr}^{' num2str(i) '}'],[],'off');
%     set(pOmegafr{i}, 'LineStyle', lineVec{i}, 'LineWidth', 2, 'Color', rgbVec{i});
%     [hOmegadr{i},pOmegadr{i},axOmegadr{i}] = plotfigure(outParams{i}.eta,...
%                                                 outParams{i}.omega_dr,'Eta_{dr}','\eta',...
%                                   ['\Omega_{dr}^{' num2str(i) '}'],[],'off');
%       set(pOmegadr{i}, 'LineStyle', lineVec{i}, 'LineWidth', 2, 'Color', rgbVec{i});
% end
%%
[hOmegafdrF,lgndOmegafdrF,pOmegafdrF] = plotResults(hOmegafdr,pOmegafdr,...
                                            axOmegafdr,'$ \eta $','$ \Omega_{fdr} $');
plotZoom(hOmegafdrF,[7 7.9],[300 350])

[hOmegafrF,lgndOmegafrF,pOmegafrF] = plotResults(hOmegafr,pOmegafr,...
                                            axOmegafr,'$ \eta $','$ \Omega_{fr} $');
plotZoom(hOmegafrF,[7 9],[0.995 1.001])
[hOmegadrF,lgndOmegadrF,pOmegadrF] = plotResults(hOmegadr,pOmegadr,...
                                            axOmegadr,'$ \eta $','$ \Omega_{dr} $');
plotZoom(hOmegadrF,[7 7.9],[0.0029 0.0035])
%%

savesimfigs(hOmegafdrF,'figname',[hOmegafdrF.Name],...
      'figfolder',fullfile(figPath),...
      'formatsFolders',{'JPG','FIG','PDF','EPS'},...
      'figformats',{'jpg','fig','pdf','eps'});
  
savesimfigs(hOmegafrF,'figname',[hOmegafrF.Name],...
      'figfolder',fullfile(figPath),...
      'formatsFolders',{'JPG','FIG','PDF','EPS'},...
      'figformats',{'jpg','fig','pdf','eps'});
  
savesimfigs(hOmegadrF,'figname',[hOmegadrF.Name],...
      'figfolder',fullfile(figPath),...
      'formatsFolders',{'JPG','FIG','PDF','EPS'},...
      'figformats',{'jpg','fig','pdf','eps'});
 