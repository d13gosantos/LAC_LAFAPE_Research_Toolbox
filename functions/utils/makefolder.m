function folderpath = makefolder(rootpath,varargin)
    %MAKESIMFOLDER Test if a folder exists in path. If so
    %Return the filepath. If not, create the folder and return
    %the path
    fpath = fullfile(rootpath,varargin{:});
    try
        mkdir(fpath);
        folderpath = fpath;
    catch 
        folderpath = fpath;
    end
    
end

