function [L,Rsigma,params,lmiMatrices] = linf_LMI(obsSys,eta,~)
    %S minus fault detection observer
    %
    % Syntax: [L,P,Q,W,beta] = sminusfdobserver(Asigma,Bsigma,Csigma,Dfault,eta)
    % This approach consider the residual with a R matrix for fault
    % isolation
    %
    % Long description
    tol = 1e-4;
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    Ef = obsSys.Efault; %Matrices of columns of terms with no fault
    
    % Cnorms = cellfun(@(Cs) norm(Cs,inf),C,'UniformOutput',false);
    %U = (norm(R,inf)^2)*max(Cnorms{:});
    n = size(A{1,1},1);
    p = size(C{1,1},1);
    
    p1 = size(Ef{1,1},2);
    
    
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    
    cEf = size(Ef{1,1},2);
    M = length(A); %(number of sets);
    
    % Putting the matrices matricial variables in cell structures
    P = sdpvar(cA,rA);
    W = sdpvar(rC,cC,'full');
    Ie = eye(cEf);
    
    n = rA;
    gamma2 = sdpvar(1,1);
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    RestrH = arrayfun(@(i) Hsigma{1,i}>=0,1:M,'UniformOutput',false);
    Restr = [P>=0.01, gamma2>=tol,[RestrH{:}]];
    %Creating matrix for LMI restriction
    
    %Linfty(Lone) restriction
    for j=1:M
        s11= P*A{1,j} + A{1,j}'*P + C{1,j}'*W + W'*C{1,j} + eta*P +...
            C{1,j}'*Hsigma{1,j}*C{1,j};
        s12=W'*Ef{1,j}+ C{1,j}'*Hsigma{1,j}*Ef{1,j};
        s21 = s12';
        s22 = -gamma2*Ie+Ef{1,j}'*Hsigma{1,j}*Ef{1,j};
        S = [s11,s12;s21,s22];
        Restr=[Restr, S <=-tol];
    end
    
    % Setting LMI solver
    opts=sdpsettings('solver','mosek','verbose',0);
    % opts=sdpsettings('solver','sedumi','verbose',0);
    
    % Solving LMIs
    optimize(Restr,(gamma2), opts);
    che = min(checkset(Restr));
    if che > 0
        disp('LMI feasible')
        feasible = 1;     
        gamma = sqrt(value(gamma2));
        P = value(P);
        W = value(W);
        L = -inv(P)*W';
        S = value(S);
        Hsigma = cellfun(@value,Hsigma,'UniformOutput',false);
        Rsigma = get_Rmatrices(Hsigma);
        lmiMatrices = get_lmiMatrices();
        params = get_params(feasible);      
    else
        disp('LMI unfeasible')
        feasible = 0;
        W=[];  P=[]; L=[]; gamma = 0; eta = 0;
        S = [];Hsigma = []; Rsigma = [];
        params= get_params(feasible);
        lmiMatrices = get_lmiMatrices();
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        params.omega_f = [];
        params.omega_fr= [];
        params.beta = [];
        params.muone =  [];
        if feasible           
            params.gamma = gamma;
            params.eta = eta;
            params.muzero = mu_lambda(C,Hsigma);
            params.muthree = mu_lambda(Ef,Hsigma);
            params.lambdaPmax= lambdamax(P);
            params.lambdaPmin= lambdamin(P);            
            params.omega_d = omegad(eta,P,gamma); 
            params.omega_dr = omegadr(gamma);
            params.omega_fd = 1./params.omega_d;
            params.omega_fdr =1./params.omega_dr;
        else
            params.beta = [];
            params.gamma = [];
            params.eta = [];
            params.muzero =[];
            params.muthree = [];
            params.lambdaPmax= [];
            params.lambdaPmin= [];  
            params.omega_d = [];
            params.omega_fd = [];
            params.omega_fdr = [];
        end
    end
    
    function lmiMatrices = get_lmiMatrices()
        lmiMatrices.P = P;
        lmiMatrices.W = W;
        lmiMatrices.S = S;
        lmiMatrices.L = L;
        lmiMatrices.Hsigma = Hsigma;
        lmiMatrices.Rsigma = Rsigma;
    end
    
    function omega_dr = omegadr(gamma)
        omega_dr = gamma*sqrt(p1);
    end
    
    function omega_d = omegad(eta,P,gamma)
        omega_d = sqrt((gamma^2-muthree)/...
            (n*(eta*lambdamax(P)+ muzero)));
    end
    
    
    
end


