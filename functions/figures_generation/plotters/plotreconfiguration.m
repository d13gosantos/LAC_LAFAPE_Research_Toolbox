% function [fighandle,plothandle,axeshandle] = plotreconfig(obj,param,varargin)
%     %Param corresponds to a timeseries parametetr
%     savefile = savesimfigparser(varargin{:});
%
%     [fighandle,plothandle,axeshandle] = plotts(obj.SimTimeSeries,param);
%     if obj.ReconfigSwitch == 1
%         rname = 'Reconfiguration';
%         rcolor = 'b';
%         rline = '-';
%     else
%         rname = 'No reconfiguration';
%         rcolor = 'r';
%         rline = '--';
%     end
%     lr = legend(axeshandle,rname);
%     set(lr,'visible','on');
%     set(plothandle,'Color',rcolor,'LineStyle',rline);
%
%     %Verifies if user wants to save file
%     fname = obj.SimTimeSeries.Name;
%     figfolder = obj.FigPath;
%     figname = [fighandle.Name '_' fname];
%     fighandle.Name = figname;
%     if strcmp(savefile,'y')
%         savesimfigs(fighandle,'figname',figname,'figfolder',figfolder);
%     end
%
% end