function setlegend(handle,legends,varargin)%visible,location,orientation
    % setlegend(handle,legends) Defines the default legend
    
    %Define parser
    lParser = inputParser;
    defaultVisible = 'off';
    defaultLocation = 'best';
    defaultOrientation = 'vertical';
    
    addParameter(lParser,'Visible',defaultVisible,@ischar);
    addParameter(lParser,'Location',defaultLocation,@ischar);
    addParameter(lParser,'Orientation',defaultOrientation,@ischar);  
    parse(lParser,varargin{:});
    
    Visible = lParser.Results.Visible;
    Location = lParser.Results.Location;
    Orientation  = lParser.Results.Orientation;
   
    figlegend = legend(handle,legends,'Interpreter','latex');
    set(figlegend,'Visible',Visible,'Interpreter','latex',...
        'FontSize',8,...
        'FontName','Latin Modern Roman',...
        'Location',Location,...
        'Orientation',Orientation);
    %      'Color','none',...);
end
