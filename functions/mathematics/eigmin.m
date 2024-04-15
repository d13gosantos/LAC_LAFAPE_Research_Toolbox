function eigMin = eigmin(P)
    if iscell(P)
        minCell = cellfun(@eig_min,P,'UniformOutput',false);
        eigMin= min([minCell{:}]);
    else
        eigMin = eig_min(P);
    end
    
end

function eigMin= eig_min(P)
    eigMin = min(eig(P));
end
