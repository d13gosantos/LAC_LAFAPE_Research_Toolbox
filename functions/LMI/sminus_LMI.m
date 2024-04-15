function [L,Rsigma,params,lmiMatrices] = sminus_LMI(obsSys,eta,Q)
    %S minus fault detection observer
    %
    % Syntax: [L,P,Q,W,beta] = sminusfdobserver(Asigma,Bsigma,Csigma,Dfault,eta)
    % This approach consider the residual with a R matrix for fault
    % isolation
    %
    % Long description
    tol = 1e-6;
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    D = obsSys.Dfault; %Matrices of columns of terms with no fault
    
    % Cnorms = cellfun(@(Cs) norm(Cs,inf),C,'UniformOutput',false);
    %U = (norm(R,inf)^2)*max(Cnorms{:});
    n = size(A{1,1},1);
    p = size(C{1,1},1);
    % Cnorms = cellfun(@(Cs) norm(Cs,inf),Csigma,'UniformOutput',false);
    %U = (norm(R,inf)^2)*max(Cnorms{:});
    
    q = 1; %Size of residual %Scalar function
    %Sizes of fault and remaining faults vector
    p2 = size(D{1,1},2);
    
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cD = size(D{1,1},2);
    M = length(A); %(number of sets);
    
    % Putting the matrices matricial variables in cell structures
    P = sdpvar(cA,rA);
    W = sdpvar(rC,cC,'full');
    Id = eye(cD);
    beta2 = sdpvar(1,1);
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    RestrH = arrayfun(@(i) Hsigma{1,i}>=0,1:M,'UniformOutput',false);
    Restr = [P>=0.01, [RestrH{:}],beta2>=tol];
    %Creating matrix for LMI restriction
    %S_ restriction
    for j=1:M
        t11= P*A{1,j} + A{1,j}'*P + C{1,j}'*W + W'*C{1,j} ...
            + eta*P - C{1,j}'*Hsigma{1,j}*C{1,j};
        t12=W'*D{1,j} - C{1,j}'*Hsigma{1,j}*D{1,j};
        t21 = t12';
        t22 = beta2*Id - Q - D{1,j}'*Hsigma{1,j}*D{1,j};
        T = [t11,t12;t21,t22];
        Restr=[Restr,T<=-tol, C{1,j}'*Hsigma{1,j}*C{1,j} - eta*P<= tol,...
            beta2*Id - Q>=0, D{1,j}'*Hsigma{1,j}*D{1,j}-q*(Q'*Q) <= 0];
    end
    
    
    % Setting LMI solver
    opts=sdpsettings('solver','mosek','verbose',0);
    % opts=sdpsettings('solver','sedumi','verbose',0);
    
    % Solving LMIs
    optimize(Restr,(-beta2), opts);
    che = min(checkset(Restr));
    if che > 0
        disp('LMI feasible')
        feasible = 1;
        beta = sqrt(value(beta2));
        
        P = value(P);
        W = value(W);
        L = -inv(P)*W';
        T = value(T);
        
        Hsigma = cellfun(@value,Hsigma,'UniformOutput',false);
        Rsigma = get_Rmatrices(Hsigma);
        lmiMatrices = get_lmiMatrices();
        params = get_params(feasible);  
    else
        disp('LMI unfeasible')
        feasible = 0;
        W=[];  P=[]; L=[]; beta = 0; eta = 0;
        T =[];
        S = [];Hsigma = []; Rsigma = [];
        params= get_params(feasible);
        lmiMatrices = get_lmiMatrices();
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        params.omega_d = [];
        params.omega_fd = [];
        params.muthree = [];
        params.gamma = [];
        if feasible
            params.beta = beta;
            params.eta = eta;
            params.muzero = mu_lambda(C,Hsigma);
            params.muone =  mu_lambda(D,Hsigma);
            params.lambdaPmax= lambdamax(P);
            params.lambdaPmin= lambdamin(P);
            params.omega_f = omegaf(eta,P,beta,Q);
            
            params.omega_fr = omegafr(beta,Q);
            params.omega_fd = params.omega_f;
            params.omega_fdr = params.omega_fr./(lambdamax(Q));
        else
            params.beta = [];
            params.gamma = [];
            params.eta = [];
            params.muzero =[];
            params.muone =  [];
            params.muthree = [];
            params.lambdaPmax= [];
            params.lambdaPmin= [];
            params.omega_f = [];
            params.omega_fr= [];
            params.omega_fdr = [];
        end
    end
    
    function lmiMatrices = get_lmiMatrices()
        lmiMatrices.P = P;
        lmiMatrices.Q = Q;
        lmiMatrices.W = W;
        lmiMatrices.T = T;
        lmiMatrices.L = L;
        lmiMatrices.Hsigma = Hsigma;
        lmiMatrices.Rsigma = Rsigma;
    end
    
    function omega_fr = omegafr(beta,Q)
        omega_fr = sqrt((beta^2 - p2*lambdamax(Q))/q);
    end
    
    function omega_f = omegaf(eta,P,beta,Q)
        omega_f = sqrt((muone+p2*lambdamax(Q) - beta^2)/...
            (eta*lambdamax(P) - muzero));
    end
    
    
    
    
    
end


