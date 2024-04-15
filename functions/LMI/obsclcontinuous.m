function [obsSys,P,params,lmiMat] = obsclcontinuous(obsSys,eta,mu,delta_tau)
    %Uncert sampled observer based switched conrol law
    %Using a common P
    
    %Tolerance of parameters affect the solutions of the lmi
    %     lmitol = 1e-6;%tolerance for LMI
 
    lmitol = 1e-6;
    
    epslon_a = sdpvar(1,1);
    assign(epslon_a,lmitol);

    opts=sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more
    %factiblity but sedumi solves for a better solution
    %opts=sdpsettings('solver','sedumi','verbose',0);
    %opts = sdpsettings('verbose',1);
    
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    b = obsSys.bsigma;
    F = obsSys.Dsigma;
    
    %Uncertain matrices
    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    
    %Dimensions
    n = size(A{1,1},1);
    p = size(C{1,1},1);
    q = 1; %Size of residual %Scalar function
    %Sizes of fault and remaining faults vector
    M = length(A);
    xe = obsSys.xe;
    kappa = obsSys.kappaVec;
    gamma_f = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    theta = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epslon_one = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
     theta_b = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epslon_xe = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    cb = size(b{1},2);
    cF = size(F{1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cMa = size(Ma{1,1},2);
    cNa = size(Na{1,1},2);
    dfbound = obsSys.dfbound;
    M = length(A); %(number of sets);
    
    % Putting the matrices matricial variables in cell structures
    P = sdpvar(cA,rA);
    assign(P,lmitol*eye(cA,rA));
    Y = arrayfun(@(i) sdpvar(rC,cC,'full'),1:M,'UniformOutput',false);
    
    RestrP = P>=lmitol*eye(cA);
    
    RestrMat = RestrP;
    
    %LuncertObjective = 0;
    S = [];
    T = [];
    
    [S,W,c,RestrLuncert,LuncertObjective] = linftyObserver(); %Return the W and c matrix
    
    %LuncertObjective = 0;
    % Solving LMIs
    Restr = [RestrMat,RestrLuncert]; 
    %LuncertObjective = 0;
    diagnostics = optimize(Restr,-logdet(P), opts);
    
    [primal,~]=checkset(Restr);
    che = min(round(primal*10^8));
    if che >= 0
        disp('The LMI is feasible, then the observer system is stable')
        feasible = 1;
        lmiMat.T = value(T);
        lmiMat.S = value(S);
        P= value(P);
        c = cellfun(@value,c,'UniformOutput',false);
        Y = cellfun(@value,Y,'UniformOutput',false);
        G = cellfun(@(y) -inv(P)*y',Y,'UniformOutput',false);
        W = value(W);
        
       
        
        %obsSys.lmiMat.c{1}'*inv(obsSys.lmiMat.W)*obsSys.lmiMat.c{1} + obsSys.params.gamma_f{1}*0.5*xe(1) 
        obsSys.Lcsigma = G;
        obsSys.Gsigma = G;
        ckappa =  mkconvcombination(kappa,c);
        nu = inv(W)*ckappa;
        lmiMat = get_lmiMatrices();
        params = get_params(feasible);
        obsSys.P = P;
        obsSys.Y = Y;
        obsSys.params = params;
        obsSys.lmiMat = lmiMat;
    else
        disp('The LMI is unfeasible - unstable')
        feasible = 0;
        P=[];  P=[]; G = [];
        T =[];
        S = [];W=[]; c = []; nu = []; ckappa = [];
        params= get_params(feasible);
        lmiMat = get_lmiMatrices();
    end
    
    
    function lmiMat = get_lmiMatrices()
        lmiMat.P = P;
        lmiMat.Y = Y;
        lmiMat.T = T;
        lmiMat.S = S;
        lmiMat.G = G;
        lmiMat.W = W;
        lmiMat.c = c;
        lmiMat.nu = nu;
        lmiMat.ckappa = ckappa;
    end
    
    function params = get_params(feasible)
        params.feasible = feasible;
        if feasible
            params.eta = eta;
            params.lambdaPmax= eigmax(P);
            params.lambdaPmin= eigmin(P);
            params.epslon_one = cellfun(@value,epslon_one,'UniformOutput',false);
            params.theta_b = cellfun(@value,theta_b,'UniformOutput',false);
            params.theta = cellfun(@value,theta,'UniformOutput',false);
            params.gamma_f = cellfun(@value,gamma_f,'UniformOutput',false);
            
            
            params.gammafbar = sqrt(eigmax(params.gamma_f)/(eigmin(P)*abs(eigmin(eta))));
%             params.thetabar = sqrt(eigmax(params.theta)/(eigmin(P)*abs(eigmin(delta_tau))));
%             params.thetabbar = sqrt(eigmax(params.theta_b)/(eigmin(P)*abs(eigmin(delta_tau))));
            params.dwellTime = cellfun(@(mu,eta) log(mu)/eta,mu,eta,'UniformOutput',false);
            params.freq = cellfun(@(dwell) 1/dwell,params.dwellTime,'UniformOutput',false);
        else
            params.eta = [];
            params.lambdaPmax= [];
            params.lambdaPmin= [];
            params.dwellTime = [];
        end
    end
    
    
    function [S,W,c,constraints,objective]= linftyObserver()
        %Observer based switched control law
        %Linfty restriction for uncertainty considering N and not
        constraints = arrayfun(@(i) [gamma_f{i}>=lmitol,...
            epslon_one{i}>=lmitol,...
            theta{i}>=lmitol],1:M,'UniformOutput',false);
        constraints = [constraints{:}];
    
                for j=1:M
                    s11= P*A{1,j} + A{1,j}'*P + eta{1,1}*P...
                        +Y{j}'*C{j} + C{j}'*Y{j}+epslon_one{j}*Na{1,1}'*Na{1,1};
                    s12 = -C{j}'*Y{j};
                    s13 = Y{j}'*F{j};
                    s14 = P*Ma{j};    
                    s15 = P*Ma{j};    
                    s22 = P*A{1,j} + A{1,j}'*P + eta{1,1}*P+epslon_one{j}*Na{1,j}'*Na{1,j};
                    s23 = -Y{j}'*F{j};
                    s24 = zeros(cA,cMa);   
                    s25= zeros(cA,cMa);
                    s33 = -gamma_f{j}*eye(cF);
                    s34 = zeros(cF,cMa);
                    s35 = zeros(cF,cMa);
                    s44 = -2*epslon_one{j}*eye(cMa);
                    s45 = zeros(cMa,cMa);
                    s55 = -theta{j}*eye(cMa);
                    S{j} = [s11,s12,s13,s14,s15;
                        s12',s22,s23,s24,s25;
                        s13',s23',s33,s34,s35;
                        s14',s24',s34',s44,s45;
                        s15',s25',s35',s45',s55];
                     [rS1,cS1] = size(S{j});
                   c{j} = [P*Ma{j}*Na{j}*xe;...
                           zeros(rS1-cA,1)];
                   
                end
                
            [rS,cS] = size(S{1});
            W  =  sdpvar(rS,cS);
    
            for j =1:M
                E{j} = [(1 - gamma_f{j}*(dfbound)^2)*eye(size(c{j},2)) c{j}';c{j} W];
            end
            
            constS = cellfun(@(s,e) [s<=-W;e>=lmitol],S,E,'UniformOutput',false);
            %constS = cellfun(@(s) s<=-W,S,'UniformOutput',false);
            constraints= [constraints,[constS{:}],W>=lmitol*eye(rS)];
      
%         constraints = [constraints, mdadtConstraints(gamma_f,mu),...
%              mdadtConstraints(epslon_one,mu),mdadtConstraints(theta_b,mu)...
%              ,mdadtConstraints(theta,mu)];
 %       constraints = [constraints,mdadtConstraints(gamma_f,mu),mdadtConstraints(theta,mu)];
%         objective = [gamma_f{:}];
        objective = [];
        %objective= [epslon_one{:}]+[gamma_f{:}]+[theta_b{:}];
        
    end
    
    
    
end


