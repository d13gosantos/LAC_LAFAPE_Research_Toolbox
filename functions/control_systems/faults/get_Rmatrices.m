function Rsigma = get_Rmatrices(Hsigma)
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    Rsigma = cell(1,length(Hsigma));
    for j =1:length(Hsigma)
        Rbar = sqrt(diag(Hsigma{1,j}))';
        Rstar = Rbar;
        [rdiv,idx] = max(Rbar);
        if rdiv ~=0 
            for i = 1:length(Rbar)
                Rstar(1,i) = Hsigma{1,j}(idx,i)/rdiv;
            end
        end
        Rsigma{1,j} = Rstar;
    end
end

