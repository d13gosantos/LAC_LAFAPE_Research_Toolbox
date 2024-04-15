function [etaMax,outParams,Lopt,RsigmaOpt] = feasability_test(lmifunc,obsSys,Q,eta_steps,etaMax)
    %Tests the feasability of the solutions in the LMI of the observers
    %
    %%%%%
    %Run the observer and tests if the solution is feasible. With the value
    %of the max eigenvalue of Q matrix and the other parameters, check the
    %sensitiviness
    j = 1;
    eta = eta_steps;
    etaArray(j) = eta;%First eta > 0 

    omega_dr = [];
    omega_fr= [];
    omega_fdr = [];
    unfeasCount = 0; %Counts how many time the is unfeasible   
    unfeasMax = 1.1;
    unfeasArray = [];
    %Obtain all the parameters while unfeasibality counter is less than a
    %value
    while((unfeasCount < unfeasMax)&&(eta <= etaMax))
        [~, ~, params,~] = lmifunc(obsSys,eta,Q);    
        if params.feasible
            %Attributes only if the solution is feasible
            etaArray(j) = eta;
            omega_fr(j) = params.omega_fr;
            omega_dr(j) = params.omega_dr;
            omega_fdr(j) = params.omega_fdr;
            j = j + 1;
            eta = eta + eta_steps;
            disp(eta);
            unfeasCount = 0;
        else
             %Something to solve a bug. If has a sequence of unfeasibility
            unfeasCount = unfeasCount + eta_steps;
            unfeasArray = [unfeasArray eta];
            eta = eta + eta_steps;
            continue;
        end
    end
    
    outParams.eta = etaArray;
    outParams.unfeasArray = unfeasArray;
    outParams.omega_fr = omega_fr;
    outParams.omega_dr = omega_dr; 
    outParams.omega_fdr = omega_fdr;
    [omega_fdr_max,omega_fdr_Idx] = max(omega_fdr);  
    etaMax =  max(etaArray(omega_fdr == omega_fdr_max));
    outParams.maxIdx = omega_fdr_Idx;
    outParams.etaMax = etaMax;
    outParams.maxOmega_fdr = omega_fdr_max;
    
    [Lopt, RsigmaOpt, optParams,lmiMat] = lmifunc(obsSys,etaMax,Q);
    outParams.L = Lopt;
    outParams.Rsigma = RsigmaOpt;
    outParams.optParams = optParams;
    outParams.lmiMat = lmiMat;

end
