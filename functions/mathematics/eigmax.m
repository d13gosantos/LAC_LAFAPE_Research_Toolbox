function eigMax = eigmax(P)
    if iscell(P)
        maxCell = cellfun(@eig_max,P,'UniformOutput',false);
        eigMax= max([maxCell{:}]);
    else
        eigMax = eig_max(P);
    end
    
end

function eigMax= eig_max(P)
    eigMax = max(eig(P));
end
