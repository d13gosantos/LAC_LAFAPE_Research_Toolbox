function savesimfigs(fighandle,varargin)
    %Save a figure in multiple formats with desired name
    %handle.name if empty and a folder
       
    p = inputParser;
    
    defaultfigname = fighandle.Name;
    defaultfolder = pwd;
    defaultformats = {'tex','pdf','fig','jpg','eps'};
    defaultfolders = {'TEX','PDF','FIG','JPG','EPS'};
    
    addParameter(p,'figname',defaultfigname,@ischar);
    addParameter(p,'figfolder',defaultfolder,@ischar);
    addParameter(p,'figformats',defaultformats,@iscell);
    addParameter(p,'formatsFolders',defaultfolders,@iscell);
    
    parse(p,varargin{:});
    figname = p.Results.figname;
    figfolder = p.Results.figfolder;
    formatsFolders  = p.Results.formatsFolders;
    figformats = p.Results.figformats;

    foldersPath = cellfun(@(formats) fullfile(figfolder,formats),...
        formatsFolders,'UniformOutput',false);
    
    cellfun(@(folder) makefolder(folder),...
            foldersPath,'UniformOutput',false);
    cellfun(@(figformat,folder) savevalidation(figformat,folder),...  
        figformats,foldersPath,'UniformOutput',false); 
    
    function savevalidation(figformat,folder)
        if strcmp(figformat,'tex')
            matlab2tikz([folder '\' figname '.tex'] ,'figurehandle',...
                fighandle,'width','0.5\textwidth');
        else
            figname = regexprep(figname,'\{(\w*)\}','$1');%Remove character
            saveas(fighandle,fullfile(folder,figname),figformat);
        end
    end


end