function [optparams,vectors,obsControlOpt] = optimizecontrol(obsSys,vartheta,etamax,etasteps,omegainfty)
    %Algorithm 1: Obtaining best bounds for the control 
    kmax = ceil((etamax-etasteps)/etasteps+1);
    etaVector = linspace(etasteps,etamax,kmax);
   % kmax = length(etaVector);
    omegaVec = omegainfty*ones(1,kmax);
    obsControl{kmax} = [];
    for k = 1:kmax
        obsControl{k} = obsclcontinuous2(obsSys,etaVector(k),vartheta,1);
        omegaVec(k) = obsControl{k}.params.omega;
    end
    [omegaOpt,kOpt] = min(omegaVec);
    etaOpt = etaVector(kOpt);
    obsControlOpt = obsControl{kOpt};
    vectors.omega = omegaVec;
    vectors.eta = etaVector; 
    optparams.eta = etaOpt;
    optparams.omega = omegaOpt;
    optparams.k = kOpt;
    
end