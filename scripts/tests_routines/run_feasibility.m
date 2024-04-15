%%
%Get optimal parameters for the observer
%Fault in sensor 1
Lsigma =  cell(1,p);
Rsigma = cell(1,p);
params = cell(1,p);
lmiMat = cell(1,p);%Lmi Matrices
%Feasability test for multiples eta to find the optimized value. Must be
%done for all the sensors
eta_steps = 0.1;
etaCell = cell(1,p);
outParams = cell(1,p);
Qgiven = 1;
etaMax = 20;
for i = 1:p
    [etaCell{i},outParams{i},L{i},Rsigma{i}] = feasability_test(@faultobserver_LMI_out,...,
        obsSys{i},Qgiven,eta_steps,etaMax);
end
etaVec = [etaCell{:}];
%etaVec = [7.20 6.80 2.60] - Paper