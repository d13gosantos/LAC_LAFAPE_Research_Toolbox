function optDeltaResults = computeMaxdelta(optResults,fmin)
    % computeMaxdelta Returns the maximum delta for given lmiParams
    
    %Solver settings
    lmitol = 10^-9;
    opt_settings = sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more
    
    %% Given parameters and matrices
    % Parameters
    epsilonx_sigma = optResults.epsilonx_sigma;
    omega0 = optResults.omega0;
    epsilonx = optResults.epsilonx;
    dfmax = optResults.dfmax;
    beta= optResults.beta;
    gamma = optResults.gamma;
    
    %Matrices
    M = optResults.estErrors_ez.Msigma;
    N = optResults.estErrors_ez.Nsigma;
    P = optResults.P;
    nSys = length(M);
    
    %% Optimization variables
    
    
    alpha = sdpvar(1,1);
    delta = sdpvar(1,1);
    
    
    %% LMI global constraints
    
    alpha_constraint_1 = [alpha>=0,alpha<=1];
    delta_constraint_1 = [delta>=0,delta<=1];
    %fmin_constraint = beta*(fmin)^2-(1+sqrt(2))^2*gamma*dfmax^2>=0;
    
    %% LMI local constraints
    alpha_constraint_2 = alpha <=(beta*(fmin)^2-(1+sqrt(2))^2*gamma*dfmax^2)/...
        ((1+sqrt(2))^2*(epsilonx*omega0^2));
    
    %delta constraints
    dLmi{1,nSys} = [];
    
    for i = 1:nSys
        dLmi12 = delta*P*M{i}*N{i};
        dLmi{i} = [-alpha*epsilonx_sigma{i}^(-1)*P*M{i}*M{i}'*P,dLmi12;
            dLmi12',-alpha*epsilonx_sigma{i}*N{i}'*N{i}];
    end
    rD = size(dLmi{1},1);
    delta_constraintsArray = cellfun(@(dlmi) dlmi<=-lmitol*eye(rD),dLmi,'UniformOutput',false);
    delta_constraint_2 = [delta_constraintsArray{:}];
    
    alpha_constraints = [alpha_constraint_1,alpha_constraint_2];
    delta_constraints = [delta_constraint_1,delta_constraint_2];
    
    opt_constraints = [alpha_constraints,delta_constraints];
    
    opt_objective = -delta;
    
    optimize(opt_constraints,opt_objective, opt_settings);
    [primal,~]=checkset(opt_constraints);
    che = min(round(primal*10^8));
    if che >= 0
        optDeltaResults.alpha = value(alpha);
        optDeltaResults.delta = value(delta);
    else
        optDeltaResults.alpha = -100;
        optDeltaResults.delta = -100;
    end
    
    optDeltaResults.dLmi = dLmi;
    optDeltaResults.SensorNumber = optResults.SensorNumber;
    optDeltaResults.optResults = optResults;
end