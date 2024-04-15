function [obsSys,Dfault, Efault] = dosmatrices(obsSys,Dsigma,p)
    %Create a number of matrices for fault isolation, where each Dmatrix is
    %a column of D
    Dfault = cell(1,p);
    Efault= cell(1,p);
    for i = 1:p
        Dfault{i} = cellfun(@(D) D(:,i),Dsigma, 'UniformOutput',false);
        Efault{i} = cellfun(@(D) D(:,[1:i-1 i+1:end]),Dsigma,'UniformOutput',false);
        obsSys{i}.Dfault = Dfault{i};
        obsSys{i}.Efault = Efault{i};
    end
end