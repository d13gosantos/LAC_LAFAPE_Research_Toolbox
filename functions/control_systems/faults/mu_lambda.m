function mu = mu_lambda(Msigma,Hsigma)
    %Calculates the maximum eigenvalue among all the matrices
    N = length(Msigma);
    MhM = arrayfun(@(i) Msigma{1,i}'*Hsigma{1,i}*Msigma{1,i},1:N,...,
        'UniformOutput',false);
    mu = cellfun(@eigmax,MhM,'UniformOutput',false);
    mu = max([mu{:}]);
end