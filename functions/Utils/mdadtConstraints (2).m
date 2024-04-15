 function constraints = mdadtConstraints(var,mu)
        %Make all the constraints for a mode=dependent switching control
        %law
        M = length(var);
        constraints{M*(M-1)} = {};
        k = 1;
        for i=1:M
            for j=1:M
                if i ~=j
                    constraints{k} = var{i} <= mu{i}*var{j};
                    k = k+1;
                end
            end
        end
        constraints = [constraints{:}];
    end