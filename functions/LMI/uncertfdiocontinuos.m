function [obsSysOut,Lsigma,Rsigma,params,lmiMat] = uncertfdiocontinuos(obsSys,eta,Q,mu,xibound)
    %S minus fault detection observer
    
    
    
    %%%%%%%%%%%% Q is equivalent to S in the paper %%%%%%%%%%%
    %Tolerance of parameters affect the solutions of the lmi
    %     lmitol = 1e-6;%tolerance for LMI
    %lmitol = sdpvar(1,1);
    %Restr = lmitol>=1e-6;
    lmitol = 1e-6;
    
    M = length(obsSys.Asigma); %(number of sets);
    %assign(epslon_b,lmitol);
    %gamma = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
%     beta = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    gamma =sdpvar(1,1);
    beta =sdpvar(1,1);
    theta_a = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epslon_a = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    theta_b = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epslon_b = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    theta_c = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epslon_c = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    pizero = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
%     cellfun(@(var) assign(var,lmitol),gamma,'UniformOutput',false);
%     cellfun(@(var) assign(var,lmitol),beta,'UniformOutput',false);
    cellfun(@(var) assign(var,lmitol),epslon_a,'UniformOutput',false);
    
    opts=sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more
    %factiblity but sedumi solves for a better solution
    %opts=sdpsettings('solver','sedumi','verbose',0);
    %opts = sdpsettings('verbose',1);
    
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    D = obsSys.Dfault;
    Ef = obsSys.Efault; %Matrices of columns of terms with no fault
    %
    %     D = cellfun(@(d) 2*d,obsSys.Dfault,'UniformOutput',false);
    %     Ef = obsSys.Efault; %Matrices of columns of terms with no fault
    xe = equilibrium(A,obsSys.bsigma,0.6);
    dfbound  = obsSys.dfbound;
    fbound =obsSys.fbound;
    %Uncertain matrices
    Mb = obsSys.Mbsigma;
    Nb = obsSys.Nbsigma;
    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    Mc = obsSys.Mcsigma;
    Nc = obsSys.Ncsigma;
    kappa = obsSys.kappaVec;
    %Dimensions
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
    cMb = size(Mb{1,1},2);
    cMa = size(Ma{1,1},2);
    [rMc,cMc]  = size(Mc{1,1});
    [rNa,cNa] = size(Na{1,1});
    [rNb,cNb] = size(Nb{1,1});
    [rNc,cNc]= size(Nc{1,1});
    
    % Putting the matrices matricial variables in cell structures
    P =  sdpvar(cA,rA);
    assign(P,lmitol*eye(cA,rA));
    %P = sdpvar(cA,rA);
    %W = sdpvar(rC,cC,'full');
    Wsigma = arrayfun(@(i) sdpvar(rC,cC,'full'),1:M,'UniformOutput',false);
    Id = eye(cD);
    Ie = eye(cEf);
    
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    % Rsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    RestrH = arrayfun(@(i) [Hsigma{1,i}>=lmitol*eye(p),epslon_a{i}>=lmitol,epslon_b{i}>=lmitol],1:M,'UniformOutput',false);
    RestrP = P>=lmitol*eye(cA);
    RestrH = [RestrH{:}];
%             constraints = arrayfun(@(i) [beta{i}>=lmitol],...
%             1:M,'UniformOutput',false);
%         constraints = [constraints{:},beta2>=lmitol];
    RestrParams = [beta>=lmitol,gamma>=lmitol];
    RestrMat = [RestrP,RestrH,RestrParams];
    RestrMat = [RestrH];
    beta2 = sdpvar(1,1);
    SminusObjective = 0;
    LinftyObjective = 0;
    LuncertObjective = 0;
    S = [];
    T = [];
    
    RestrLuncert = [];
    RestrLinfty = [];
    RestrSminus = [];
    %[T,RestrSminus,SminusObjective] = LuncertSminus();
    %     [Suncert,RestrLuncert,LuncertObjective] = LuncertNormComplete();
    %%Including all uncertainties
    pip = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    [T,W2,c2,RestrSminus,SminusObjective] = Sminus();
    %     [S,RestrLinfty,LinftyObjective] = Linfty();%Attenuation considering H = R'R
    [S,W,c,RestrLinfty,LinftyObjective] = LinftyUncert();%Attenuation considering H = R'R
    

    % Solving LMIs
    Restr = [RestrMat,RestrSminus,RestrLinfty]; %Necessary for dwell time restrictions
    objective = LinftyObjective+SminusObjective;
    %objective = -logdet(P);
    diagnostics = optimize(Restr,objective, opts);
    [primal,~]=checkset(Restr);
    che = min(round(primal*10^8));
    % che = all(diagnostics.problem,'all');
    obsSysOut = obsSys;
    if che >= 0
        disp('LMI feasible')
        feasible = 1;
        lmiMat.Q = Q;
        lmiMat.T = value(T);
        lmiMat.S = value(S);
        P = value(P);
        lmiMat.P = P;
        lmiMat.Wsigma = cellfun(@value,Wsigma,'UniformOutput',false);%value(W);
        Lsigma = cellfun(@(W) -inv(P)*W',lmiMat.Wsigma,'UniformOutput',false);
        lmiMat.Lsigma = Lsigma;
        Hsigma= cellfun(@value,Hsigma,'UniformOutput',false);
        lmiMat.Hsigma = Hsigma;
        Rsigma = cellfun(@(H) sqrtm(H),lmiMat.Hsigma,'UniformOutput',false);
        lmiMat.Rsigma = Rsigma;
        W = value(W);
        W2 = value(W2);
        c = cellfun(@value,c,'UniformOutput',false);
        c2 = cellfun(@value,c2,'UniformOutput',false);
        ckappa =  mkconvcombination(kappa,c);
        c2kappa =  mkconvcombination(kappa,c2);
        nu = inv(W)*ckappa;
        nu2 = inv(W2)*c2kappa;
        
        muzero = mu_lambda(C,Hsigma);
        muone =  mu_lambda(D,Hsigma);
        muthree = mu_lambda(Ef,Hsigma);
        params = get_params(feasible);
        obsSysOut.Lsigma = Lsigma;
        obsSysOut.Rsigma = Rsigma;
        obsSysOut.params = params;
        obsSysOut.lmiMat = lmiMat;
        obsSysOut.P = P;
        obsSysOut.lmiMat.c = c;
        obsSysOut.lmiMat.c2 = c2;
        obsSysOut.lmiMat.ckappa = ckappa;
        obsSysOut.lmiMat.c2kappa = c2kappa;
        obsSysOut.Hsigma = Hsigma;
        obsSysOut.lmiMat.W = W;
        obsSysOut.lmiMat.W2 = W2;
        obsSysOut.params.cwc = ckappa'*inv(W)*ckappa;
        obsSysOut.params.cwc2 = c2kappa'*inv(W2)*c2kappa;
         obsSysOut.params.cwc2 = c2kappa'*inv(W2)*c2kappa;
         obsSysOut.threshold = sqrt((ckappa'*inv(W)*ckappa + (params.gamma)^2*dfbound^2+params.epslon_a{1}*eigmax(Na{1}'*Na{1})*xibound^2));
       
    else
        disp('LMI unfeasible')
        feasible = 0;
        Wsigma=[];  P=[]; Lsigma=[]; params.beta = 0; params.gamma = 0;
        T =[];
        S = [];Hsigma = []; Rsigma = [];
        params= get_params(feasible);
        lmiMat = get_lmiMatrices();
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        if feasible
            params.eta = eta;
%             params.beta = cellfun(@(x) sqrt(value(x)),beta,'UniformOutput',false);
%             params.gamma = cellfun(@(x) sqrt(value(x)),gamma,'UniformOutput',false);

            params.beta = sqrt(value(beta));
            params.gamma = sqrt(value(gamma));
            params.epslon_b = cellfun(@value,epslon_b,'UniformOutput',false);
            params.pip = cellfun(@value,pip,'UniformOutput',false);
            params.epslon_a = cellfun(@value,epslon_a,'UniformOutput',false);
            params.epslon_c = cellfun(@value,epslon_c,'UniformOutput',false);
            params.theta_b = cellfun(@value,theta_b,'UniformOutput',false);
            params.theta_a = cellfun(@value,theta_a,'UniformOutput',false);
            params.theta_c = cellfun(@value,theta_c,'UniformOutput',false);
            params.pizero = cellfun(@value,pizero,'UniformOutput',false);
            params.muzero = mu_lambda(C,Hsigma);
            params.muone =  mu_lambda(D,Hsigma);
            params.muthree = mu_lambda(Ef,Hsigma);
            params.eiPmax= eigmax(P);
            params.eigPmin= eigmin(P);
            params.beta2 = value(beta2);
            params.nu = nu;
            params.nu2 = nu2;
        else
            params.beta = [];
            params.gamma = [];
            params.eta = [];
            params.muzero =[];
            params.muone =  [];
            params.muthree = [];
            params.lambdaPmax= [];
            params.lambdaPmin= [];
        end
    end
    
    function lmiMat = get_lmiMatrices()
        lmiMat.P = P;
        lmiMat.Q = Q;
        lmiMat.Wsigma = Wsigma;
        lmiMat.T = T;
        lmiMat.S = S;
        lmiMat.Lsigma = Lsigma;
        lmiMat.Hsigma = Hsigma;
        lmiMat.Rsigma = Rsigma;
    end
    
    function [T,W2,c2,constraints,objective] = Sminus()
        %S_ restriction
             
        for j=1:M
            t11= P*A{1,j} + A{1,j}'*P + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} ...
                + eta*P -C{1,j}'*Hsigma{1,j}*C{1,j};
            t12= Wsigma{1,j}'*D{1,j} - C{1,j}'*Hsigma{1,j}*D{1,j};        
            t22 = beta*Id -D{1,j}'*Hsigma{1,j}*D{1,j}; 
            T{j} = [t11,t12;
                t12',t22];
        
            rT1 = size(T{j},1);
            c2{j} = [P*Ma{j}*Na{j}*xe;...
                zeros(rT1-cA,1)];            
            %             constraints=[constraints,T{j}<=-lmitol,...
            %             E2{j} <=-lmitol];
            
        end
        [rT,cT] = size(T{1});
        W2  =  sdpvar(rT,cT);
        for j = 1:M
            e12 = C{1,j}'*Hsigma{1,j}*D{1,j};
%             e13 = zeros(cA,1);
%             e14 = zeros(cA,cT);
%             e23 = zeros(cD,1);
%             e24 = zeros(cD,cT);
%             E2{j}=[eta*P-C{1,j}'*Hsigma{1,j}*C{1,j},e12,e13,e14;
%                     e12',-D{1,j}'*Hsigma{1,j}*D{1,j}+eigmax(Q)*Id+beta*eye(cD),e23,e24;
%                     e13',e23',-(epslon_b{j}*eigmax(Na{j}'*Na{j})*xibound^2)*Id+eigmax(Q), c2{j}'; 
%                     e14',e24', c2{j},W2];   
         E2{j}=[eta*P-C{1,j}'*Hsigma{1,j}*C{1,j}-1*P,e12;
                    e12',-D{1,j}'*Hsigma{1,j}*D{1,j}+1*eigmax(Q)*Id+beta*eye(cD)];  
        end
        constT = cellfun(@(s,e) [s<=-W2,e>=lmitol],T,E2,'UniformOutput',false);
        %constT = cellfun(@(t) t<=-W2,T,'UniformOutput',false);
        constraints= [[constT{:}],W2>=lmitol*eye(rT)];
        
      %  constraints = [constraints, mdadtConstraints(beta,mu)];
        
        objective = -beta;
        %  objective = 0;
    end
    
    function [S,W,c,constraints,objective] = LinftyUncert()
                 
        for j=1:M
            s11= P*A{1,j} + A{1,j}'*P + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} + eta*P...
                +C{j}'*Hsigma{j}*C{j};
            s12= Wsigma{1,j}'*Ef{1,j}+ C{1,j}'*Hsigma{1,j}*Ef{1,j};
            s13 = P*Ma{1,j};
            s22 = -gamma*Ie+Ef{1,j}'*Hsigma{1,j}*Ef{1,j};
            s23 = zeros(cEf,cMa);
            s33 = -epslon_a{j}*eye(cMa);
            S{j} = [s11 s12 s13 ;
                s12' s22 s23 ;
                s13' s23' s33];
            rS1 = size(S{j},1);
            c{j} = [P*Ma{j}*Na{j}*xe;...
                zeros(rS1-cA,1)];
        end
        [rS,cS] = size(S{1});
        W  =  sdpvar(rS,cS);
       
        
        for j =1:M
            E{j} = [(1- gamma*dfbound^2-epslon_a{j}*eigmax(Na{j}'*Na{j})*xibound^2)*eye(size(c{j},2)) c{j}';c{j} W];
        end

        constS = cellfun(@(s,e) [s<=-W;e>=lmitol],S,E,'UniformOutput',false);
        %constS = cellfun(@(s) s<=-W,S,'UniformOutput',false);
        constraints= [[constS{:}],W>=lmitol*eye(rS)];

        objective=gamma;
    
    end
    
    
    
    
    
    
    
    
end


