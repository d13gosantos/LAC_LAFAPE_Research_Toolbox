function [obsSysOut,Lsigma,Rsigma,params,lmiMat] = calculateFDIGainsForUsas(obsSys,eta,omegazero,alpha,isNxKnown,omegabar)
    %S minus fault detection observer
    if nargin < 4
        isNxKnow = 0;
        omegabar = 100;
    end
    %Hardcoded
    
    %%%%%%%%%%%% Q is equivalent to S in the paper %%%%%%%%%%%
    %Tolerance of parameters affect the solutions of the lmi
    
    lmitol = 1e-8;
    
    M = length(obsSys.Asigma); %(number of sets);
    
    gamma =sdpvar(1,1);
    beta =sdpvar(1,1);
    theta_a = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epsilon_x = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    
    cellfun(@(var) assign(var,lmitol),theta_a,'UniformOutput',false);
    cellfun(@(var) assign(var,lmitol),epsilon_x,'UniformOutput',false);
    
    opts=sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more
    %factiblity but sedumi solves for a better solution
    %opts=sdpsettings('solver','sedumi','verbose',0);
    %opts = sdpsettings('verbose',1);
    
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    D = obsSys.Dfault;
    Ef = obsSys.Efault; %Matrices of columns of terms with no fault
    
    dmax  = obsSys.dmax;
    fbound =obsSys.fbound;
    fmin = obsSys.fmin;
    %     dmaxs = obsSys.dmaxs;
    %Uncertain matrices
    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    
    xe = obsSys.xe;
    %Dimensions
    p = size(C{1,1},1);
    
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cD = size(D{1,1},2);
    cEf = size(Ef{1,1},2);
    cMa = size(Ma{1,1},2);
    % [rNa,cNa] = size(Na{1,1});
    
    % Putting the matrices matricial variables in cell structures
    P =  sdpvar(cA,rA);
    gamma2 = sdpvar(1,1);
    assign(P,lmitol*eye(cA,rA));
    %P = sdpvar(cA,rA);
    %W = sdpvar(rC,cC,'full');
    Wsigma = arrayfun(@(i) sdpvar(rC,cC,'full'),1:M,'UniformOutput',false);
    
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    % Rsigma = arrayfun(@(i) sdpvar(p,p),1:M,'UniformOutput',false);
    RestrH = arrayfun(@(i) [Hsigma{1,i}>=lmitol*eye(p),theta_a{i}>=lmitol,epsilon_x{i}>=lmitol],1:M,'UniformOutput',false);
    RestrP = P>=lmitol*eye(cA);
    RestrH = [RestrH{:}];
    
    RestrParams = [beta>=lmitol,gamma>=lmitol,gamma2>=lmitol];
    RestrMat = [RestrP,RestrH,RestrParams];
    %RestrMat = [RestrH];
    beta2 = sdpvar(1,1);
    SminusObjective = 0;
    LinftyObjective = 0;
    LuncertObjective = 0;
    S = [];
    T = [];
    
    RestrLuncert = [];
    RestrLinfty = [];
    RestrSminus = [];
    
    
    [lmiMatSminus,RestrSminus,SminusObjective] = Sminus();
    [lmiMat,RestrLinfty,LinftyObjective] = LinftyUncert();%Attenuation considering H = R'R
    
    % Solving LMIs
   Restr = [RestrMat,RestrSminus,RestrLinfty,beta*fmin^2- gamma*dmax^2>=0]; %Necessary for dwell time restrictions
   %Restr = [RestrMat,RestrSminus,RestrLinfty]; %Necessary for dwell time restrictions
    %objective = LinftyObjective+SminusObjective;
    objective = SminusObjective;
    %objective = -logdet(P);
    optimize(Restr,objective, opts);
    [primal,~]=checkset(Restr);
    che = min(round(primal*10^8));
    
    % che = all(diagnostics.problem,'all');
    obsSysOut = obsSys;
    if che >= 0
        fprintf('The LMI is feasible, then the observer system %d is stable with eta = %d\n',obsSys.SensorNumber,eta);
        feasible = 1;
        lmiMat.T = value(lmiMatSminus.T);
        lmiMat.S = value(lmiMat.S);
        lmiMat.K = value(lmiMat.K);
        lmiMat.E = value(lmiMat.E);
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
        W2 = value(lmiMatSminus.W);
        
        params = get_params(feasible);
        obsSysOut.Lsigma = Lsigma;
        obsSysOut.Rsigma = Rsigma;
        obsSysOut.params = params;
        obsSysOut.lmiMat = lmiMat;
        obsSysOut.P = P;
        
        obsSysOut.Hsigma = Hsigma;
        obsSysOut.lmiMat.Wlinf = W;
        obsSysOut.lmiMat.WSminus = W2;
        obsSysOut.Jth = sqrt(eta);
    else
        fprintf('The LMI is unfeasible for observer system %d with eta = %d \n',obsSys.SensorNumber,eta);
        feasible = 0;
        Wsigma=[];  P=[]; Lsigma=[];
        T =[];
        S = []; Hsigma = []; Rsigma = [];
        params= get_params(feasible);
        lmiMat = get_lmiMatrices();
        params= get_params(feasible);
        lmiMat = get_lmiMatrices();
        obsSysOut.params = params;
        obsSysOut.lmiMat = lmiMat;
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        if feasible
            params.eta = eta;
            
            params.beta = value(beta);
            params.gamma = value(gamma);
            params.gammabar = sqrt(params.gamma);
            params.betabar = sqrt(params.beta);
            params.omegabar = omegabar;
            params.theta_a = cellfun(@value,theta_a,'UniformOutput',false);
            params.epsilon_x = cellfun(@value,epsilon_x,'UniformOutput',false);
                      
            if isNxKnown
                theta_a_bar = max([params.epsilon_x{:}]);
                epsilon_x_bar =theta_a_bar;
            else
                Nxsquare = cellfun(@(N) xe'*N'*N*xe,Na,'UniformOutput',false);
                Nsquare = cellfun(@(N) N'*N,Na,'UniformOutput',false);
                theta_a_bar = max([params.epsilon_x{:}])*eigmax(Nsquare);
                epsilon_x_bar = max([params.epsilon_x{:}])*eigmax(Nxsquare);
            end
            
          
            params.theta_a_bar = theta_a_bar;
            params.epsilon_x_bar = epsilon_x_bar;
            [jth,jthmax] = getthreshold(params.gamma,dmax,theta_a_bar,epsilon_x_bar,omegazero,alpha);
            params.jthmax = jthmax;
            params.jth =  jth;
            params.numax = sqrt(eta)/params.betabar;
            params.nujth = params.jth/params.betabar;
            
            params.nu = (params.gammabar*dmax)/params.betabar;
            params.eiPmax= eigmax(P);
            params.eigPmin= eigmin(P);
            params.beta2 = value(beta2);
        else
            params.beta = 10^(-9);
            params.betabar = 10^(-9);
            params.gamma =10^9;
            params.eta = eta;
            params.nujth = 10^9;
            params.theta_a_bar = 10^9;
            params.epsilon_x_bar = 10^9;
            params.eigPmax= [];
            params.eigPmin= [];
        end
    end
    
    function lmiMat = get_lmiMatrices()
        lmiMat.P = P;
        lmiMat.Wsigma = Wsigma;
        lmiMat.T = T;
        lmiMat.S = S;
        lmiMat.Lsigma = Lsigma;
        lmiMat.Hsigma = Hsigma;
        lmiMat.Rsigma = Rsigma;
    end
    
    function [lmiMat,constraints,objective] = Sminus()
        %S_ restriction
        
        for j=1:M
            t11= P*A{1,j}+A{1,j}'*P+C{1,j}'*Wsigma{1,j}+Wsigma{1,j}'*C{1,j} ...
                +eta*P-C{1,j}'*Hsigma{1,j}*C{1,j};
            t12= Wsigma{1,j}'*D{1,j}-C{1,j}'*Hsigma{1,j}*D{1,j};
            t22 = beta*eye(cD)-D{1,j}'*Hsigma{1,j}*D{1,j};
            T{j} = [t11,t12;
                t12',t22];
        end
        [rT,cT] = size(T{1});
        W2  =  sdpvar(rT,cT);
        for j = 1:M
            e12 = C{1,j}'*Hsigma{1,j}*D{1,j};
            E2{j}=[eta*P-C{1,j}'*Hsigma{1,j}*C{1,j}-P,e12;
                e12',D{1,j}'*Hsigma{1,j}*D{1,j}-beta*eye(cD)+1/fbound];
        end
        constT = cellfun(@(s,e) [s<=-W2,e>=lmitol],T,E2,'UniformOutput',false);
        constraints= [[constT{:}],W2>=lmitol*eye(rT)];
        lmiMat.W = W2;
        lmiMat.T = T;
        objective = -beta;
    end
    
    function [lmiMat,constraints,objective] = LinftyUncert()
        
        for j=1:M
            s11= P*A{1,j}+A{1,j}'*P+C{1,j}'*Wsigma{1,j}+Wsigma{1,j}'*C{1,j}+eta*P+C{j}'*Hsigma{j}*C{j};
            s12 = Wsigma{1,j}'*Ef{1,j}+ C{1,j}'*Hsigma{1,j}*Ef{1,j};
            s13 = P*Ma{1,j};
            s14 = P*Ma{1,j};
            s22 = -gamma*eye(cEf)+Ef{1,j}'*Hsigma{1,j}*Ef{1,j};
            s23 = zeros(cEf,cMa);
            s24 = zeros(cEf,cMa);
            s33 = -epsilon_x{j}*eye(cMa);
            s34 = zeros(cMa,cMa);
            s44 = -epsilon_x{j}*eye(cMa);
            S{j} = [s11 s12 s13 s14;
                s12' s22 s23 s24;
                s13' s23' s33 s34;
                s14' s24' s34' s44];
            rS1 = size(S{j},1);
            c{j} = [P*Ma{j}*Na{j}*xe;...
                zeros(rS1-cA,1)];
            k11 = -eta*P;
            k12 = Wsigma{1,j}'*Ef{1,j}+ C{1,j}'*Hsigma{1,j}*Ef{1,j};
            k22 = -gamma*eye(cEf)+Ef{1,j}'*Hsigma{1,j}*Ef{1,j};
            Ks{j} = [k11,k12;k12',k22];
        end
        [rS,cS] = size(S{1});
        [rK,cK] = size(Ks{1});
        W  =  sdpvar(rS,cS);
        K =  sdpvar(rK,cK);
        for j =1:M
            if isNxKnown
               E{j} = (eta-gamma*dmax^2-epsilon_x{j}*omegabar^2);  
            else
               E{j} = (eta-gamma*dmax^2-epsilon_x{j}*eigmax(Na{j}'*Na{j})*omegazero^2); 
            end    
        end
        %         for j =1:M
        %             E{j} = [(1 - gamma*dmax^2-theta_a{j}*eigmax(Na{j}'*Na{j})*xibound^2)*eye(size(c{j},2)) c{j}';c{j} W];
        %         end
        E2 = sdpvar(size(E{1},1),size(E{1},2));
        constS = cellfun(@(s,e,k) [s<=-W;e>=E2],S,E,'UniformOutput',false);
        % constS = cellfun(@(s,k) [s<=-W;k<=-K],S,Ks,'UniformOutput',false);
        %constS = cellfun(@(s) s<=-W,S,'UniformOutput',false);
        constraints= [[constS{:}],W>=lmitol*eye(rS),E2>=lmitol];
        lmiMat.W = W;
        lmiMat.K = K;
        lmiMat.S = S;
        lmiMat.c = c;
        lmiMat.E = E;
        objective=gamma;
        
    end
    
    
end


