function [Lsigma,Rsigma,params,lmiMatrices] = faultobserver_LMI_out(obsSys,eta,Q)
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
    D = obsSys.Dfault;
    Ef = obsSys.Efault; %Matrices of columns of terms with no fault
    
    % Cnorms = cellfun(@(Cs) norm(Cs,inf),C,'UniformOutput',false);
    %U = (norm(R,inf)^2)*max(Cnorms{:});
    n = size(A{1,1},1);
    p = size(C{1,1},1);
    q = 1; %Size of residual %Scalar function
    %Sizes of fault and remaining faults vector
    p1 = size(Ef{1,1},2);
    p2 = size(D{1,1},2);
    
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cD = size(D{1,1},2);
    cEf = size(Ef{1,1},2);
    M = length(A); %(number of sets);
    
    % Putting the matrices matricial variables in cell structures
    P = sdpvar(cA,rA);
    %W = sdpvar(rC,cC,'full');
    Wsigma = arrayfun(@(i) sdpvar(rC,cC,'full'),1:M,'UniformOutput',false);
    Id = eye(cD);
    Ie = eye(cEf);
    %Cnorms = cellfun(@(Cs) norm(Cs,inf),Csigma,'UniformOutput',false);
    
    n = rA;
    gamma2 = sdpvar(1,1);
    beta2 = sdpvar(1,1);
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    RestrH = arrayfun(@(i) Hsigma{1,i}>=0,1:M,'UniformOutput',false);
    Restr = [P>=0.001, gamma2>=tol,[RestrH{:}],beta2>=tol];
    %Creating matrix for LMI restriction
    %S_ restriction
    for j=1:M
        t11= P*A{1,j} + A{1,j}'*P + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} ...
            + eta*P - C{1,j}'*Hsigma{1,j}*C{1,j};
        t12=Wsigma{1,j}'*D{1,j} - C{1,j}'*Hsigma{1,j}*D{1,j};
        t21 = t12';
        t22 = beta2*Id - Q - D{1,j}'*Hsigma{1,j}*D{1,j};
        T = [t11,t12;t21,t22];
        Restr=[Restr,T<=-tol, C{1,j}'*Hsigma{1,j}*C{1,j} - eta*P<= tol,...
            beta2*Id - Q>=0, D{1,j}'*Hsigma{1,j}*D{1,j}-q*(Q'*Q) <= 0];
    end
    
    %Linfty(Lone) restriction
    for j=1:M
        s11= P*A{1,j} + A{1,j}'*P + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} + eta*P +...
            C{1,j}'*Hsigma{1,j}*C{1,j};
        s12=Wsigma{1,j}'*Ef{1,j}+ C{1,j}'*Hsigma{1,j}*Ef{1,j};
        s21 = s12';
        s22 = -gamma2*Ie+Ef{1,j}'*Hsigma{1,j}*Ef{1,j};
        S = [s11,s12;s21,s22];
        Restr=[Restr, S <=-tol];
    end
    
    % Setting LMI solver
    %opts=sdpsettings('solver','mosek','verbose',0);
     opts=sdpsettings('solver','sedumi','verbose',0);
    
    % Solving LMIs
    optimize(Restr,(gamma2-beta2), opts);
    che = min(checkset(Restr));
    if che > 0
        disp('LMI feasible')
        feasible = 1;
        beta = sqrt(value(beta2));
        gamma = sqrt(value(gamma2));
        P = value(P);
        Wsigma = cellfun(@value,Wsigma,'UniformOutput',false);%value(W);
        Lsigma = cellfun(@(W) -inv(P)*W',Wsigma,'UniformOutput',false);
        T = value(T);
        S = value(S);
        Hsigma = cellfun(@value,Hsigma,'UniformOutput',false);
        Rsigma = get_Rmatrices(Hsigma);
        lmiMatrices = get_lmiMatrices();
        muzero = mu_lambda(C,Hsigma);
        muone =  mu_lambda(D,Hsigma);
        muthree = mu_lambda(Ef,Hsigma);
        params = get_params(feasible);
        obsSys.Lsigma = Lsigma;
        obsSys.Rsigma = Rsigma;
        obsSys.params = params;
        obsSys.lmiMat = lmiMatrices;
    else
        disp('LMI unfeasible')
        feasible = 0;
        Wsigma=[];  P=[]; Lsigma=[]; beta = 0; gamma = 0; eta = 0;
        T =[];
        S = [];Hsigma = []; Rsigma = [];
        params= get_params(feasible);
        lmiMatrices = get_lmiMatrices();
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        if feasible
            params.beta = beta;
            params.gamma = gamma;
            params.eta = eta;
            params.muzero = mu_lambda(C,Hsigma);
            params.muone =  mu_lambda(D,Hsigma);
            params.muthree = mu_lambda(Ef,Hsigma);
            params.lambdaPmax= lambdamax(P);
            params.lambdaPmin= lambdamin(P);
            params.omega_f = omegaf(eta,P,beta,Q);
            params.omega_d = omegad(eta,P,gamma);
            params.omega_fr = omegafr(beta,Q);
            params.omega_dr = omegadr(gamma);
            params.omega_fd = params.omega_f./params.omega_d;
            params.omega_fdr = params.omega_fr./(lambdamax(Q)*params.omega_dr);
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
            params.omega_d = [];
            params.omega_fd = [];
            params.omega_fr= [];
            params.omega_fdr = [];
        end
    end
    
    function lmiMatrices = get_lmiMatrices()
        lmiMatrices.P = P;
        lmiMatrices.Q = Q;
        lmiMatrices.Wsigma = Wsigma;
        lmiMatrices.T = T;
        lmiMatrices.S = S;
        lmiMatrices.Lsigma = Lsigma;
        lmiMatrices.Hsigma = Hsigma;
        lmiMatrices.Rsigma = Rsigma;
    end
    
    function omega_fr = omegafr(beta,Q)
        omega_fr = sqrt((beta^2 - p2*lambdamax(Q))/q);
    end
    
    function omega_dr = omegadr(gamma)
        omega_dr = gamma*sqrt(p1);
    end
    
    function omega_f = omegaf(eta,P,beta,Q)
        omega_f = sqrt((muone+p2*lambdamax(Q) - beta^2)/...
            (eta*lambdamax(P) - muzero));
    end
    
    function omega_d = omegad(eta,P,gamma)
        omega_d = sqrt((gamma^2-muthree)/...
            (n*(eta*lambdamax(P)+ muzero)));
    end
    
    
    
end


