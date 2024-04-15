function [DsigmaArray, EsigmaArray] = dosmatrices(Fsigma,p)
    %Create a number of matrices for fault isolation, where each Dmatrix is
    %a column of F
    DsigmaArray = cell(1,p);
    EsigmaArray= cell(1,p);
    for i = 1:p
        DsigmaArray{i} = cellfun(@(D) D(:,i),Fsigma, 'UniformOutput',false);
        EsigmaArray{i} = cellfun(@(D) D(:,[1:i-1 i+1:end]),Fsigma,'UniformOutput',false);
    end
end