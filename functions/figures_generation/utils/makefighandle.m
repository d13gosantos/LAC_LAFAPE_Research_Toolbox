function [newfighandle,stHandle,handleParameters,position] = makefighandle(fighandle)
    %Creates a new figure struct based on a previous one
    stHandle = get(fighandle); %Original struct
    structhandle = stHandle;
    
    %Change axes properties - zero Axes
    %structhandle.Children = gobjects(0);
    newfighandle = figure;
    position = 0; %Return the position parameter
    structhandle.Parent = newfighandle.Parent;
    
    %Remove read-only properties
    readOnlyFields = {'Children','Number','Type','BeingDeleted'};
    %It is optional to keep or don't
    set(newfighandle,'Units',stHandle.Units);
    
    %structhandle.CurrentAxes = gobjects(); %For empty axes
    undesiredFields = {'CurrentAxes','CurrentCharacter',...,
        'Units','Position','OuterPosition','InnerPosition'};
    
    %undesiredFields = {'CurrentAxes','CurrentCharacter'};
    fields2remove = [readOnlyFields,undesiredFields];
    structhandle = rmfield(structhandle,fields2remove);
    
    handleFields = fieldnames(structhandle);
    handleValues = struct2cell(structhandle);
    %concatenate parameters
    handleParameters = cellfun(@(x,y) [{x},{y}], ...
        handleFields,handleValues, 'UniformOutput',false);
    handleParameters = [handleParameters{:}];
    
    set(newfighandle,handleParameters{:});
    
    %Configure units before
    set(newfighandle,'PaperUnits',stHandle.PaperUnits,'Position',...,
        stHandle.Position,'OuterPosition',stHandle.OuterPosition);
end