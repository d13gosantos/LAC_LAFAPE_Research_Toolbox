function [obsSysOut,P,params,lmiMat] = robftslgains(obsSys,eta,varepsilon_a,czeta,dispMsg)
    %Uncert sampled observer based switched conrol law
    %Using a common P
    
    if ~exist('dispMsg','var')
        % Defines if the solver returns a message if feasible or not
        dispMsg = 1;
    end
    
    %Tolerance
    lmitol = 1e-6;
    
    epslon_a = sdpvar(1,1);
    assign(epslon_a,lmitol);
    
    %Definition of matrices
    
    A = obsSys.Asigma;
    C = obsSys.Csigma;
    F = obsSys.Dsigma;
    
    %Uncertain matrices
    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    
    M = length(A);%(number of sets);
    xe = obsSys.xe;
    x0aug = obsSys.x0aug;
    
    
    %Define dimensions
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    
    cF = size(F{1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cMa = size(Ma{1,1},2);
    
    betaf = obsSys.fsbound;%betaf
    
    %Definition of LMI variables
    P = sdpvar(cA,rA);
    assign(P,lmitol*eye(cA,rA));
    Y = arrayfun(@(i) sdpvar(rC,cC,'full'),1:M,'UniformOutput',false);
    gamma = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epsilon = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epsilon_a = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    epsilon_x = arrayfun(@(x) sdpvar(1,1),1:M,'UniformOutput',false);
    
    
    constP = P>=lmitol*eye(cA);
    
    S = [];
    T = [];
    
    %Define the LMIs and set contraints
    [lmiMat,constLuncert] = linftyObserver(); %Return the W and c matrix
    
    
    % Solving LMIs
    
    %Solver selection
    opts=sdpsettings('solver','sdpt3','verbose',0);
    constraits = [constP,constLuncert];
    LuncertObjective = -logdet(P);
    optimize(constraits,LuncertObjective, opts);
    
    obsSysOut = obsSys;
    [primal,~]=checkset(constraits);
    che = min(round(primal*10^8));
    %If feasible
    if che >= 0       
        if dispMsg ~= 0
            fprintf(['The LMI is feasible',...
                ' then the system with ROBFTSL is stable with eta = %d\n'],eta);
        end
        feasible = 1;
        T = value(T);
        S = value(lmiMat.S);
        P = value(P);
        Y = cellfun(@value,Y,'UniformOutput',false);
        G = cellfun(@(y) -inv(P)*y',Y,'UniformOutput',false);
        
        obsSysOut.Lcsigma = G;
        obsSysOut.Gsigma = G;
        obsSysOut.P = P;
        obsSysOut.Y = Y;
        lmiMat = get_lmiMatrices();
        params = get_params(feasible);
        obsSysOut.params = params;
        obsSysOut.lmiMat = lmiMat;
    else
        if dispMsg ~= 0
            fprintf('The LMI is unfeasible with ROBFTSL and eta = %d',eta);
        end
        feasible = 0;
        P=[]; G = [];
        T =[];
        S = [];
        params= get_params(feasible);
        lmiMat = get_lmiMatrices();
        obsSysOut.params = params;
        obsSysOut.lmiMat = lmiMat;
    end
    
    
    function lmiMat = get_lmiMatrices()
        lmiMat.P = P;
        lmiMat.Y = Y;
        lmiMat.T = T;
        lmiMat.S = S;
        lmiMat.G = G; 
    end
    
    
    function params = get_params(feasible)
        %Return all parameters if feasible
        params.feasible = feasible;
        if feasible
            params.eta = eta;
            params.emaxP = eigmax(P);
            eminP = eigmin(P);
            params.eminP = eminP;
           % V0 = x0aug'*diag(P,P)*x0aug;
            %params.V0 = V0;            
            params.epsilon = cellfun(@value,epsilon,'UniformOutput',false);
            params.epsilon_x = cellfun(@value,epsilon_x,'UniformOutput',false);
            params.epsilon_a = cellfun(@value,epsilon_a,'UniformOutput',false);
            params.gamma = cellfun(@value,gamma,'UniformOutput',false);
            params.omega = sqrt(2*(1+varepsilon_a)/(eminP));
            params.omegazero = sqrt(2*eigmax(P)*czeta+1)/sqrt(eigmin(P));
            params.gammafbar = sqrt(eigmax(params.gamma)/(eigmin(P)*abs(eigmin(eta))));
        else
            params.eta = eta;
            params.emaxP= [];
            params.eminP= [];
            params.omega = [];
            params.gamma = 10^9;
            params.omega = 10^9;
            params.epsilon = [];
        end
    end
    
    
    function [lmiMat,constraints,objective]= linftyObserver()
        %Observer based switched control law
        
        constraints = arrayfun(@(i) [gamma{i}>=lmitol,...
            epsilon{i}>=lmitol,...
            epsilon_a{i}>=lmitol, epsilon_x{i}>=lmitol],1:M,'UniformOutput',false);
        constraints = [constraints{:}];
        for j = 1:M
            s11= P*A{1,j} + A{1,j}'*P + eta*P...
                +Y{j}'*C{j} + C{j}'*Y{j}+epsilon{j}*Na{1,1}'*Na{1,1};
            s12 = -C{j}'*Y{j};
            s13 = Y{j}'*F{j};
            s14 = P*Ma{j};
            s15 = P*Ma{j};
            s16 = P*Ma{j};
            s22 = P*A{1,j} + A{1,j}'*P + eta*P+epsilon_a{j}*Na{1,j}'*Na{1,j};
            s23 = -Y{j}'*F{j};
            s24 = zeros(cA,cMa);
            s25= zeros(cA,cMa);
            s26= zeros(cA,cMa);
            s33 = -gamma{j}*eye(cF);
            s34 = zeros(cF,cMa);
            s35 = zeros(cF,cMa);
            s36 = zeros(cF,cMa);
            s44 = -epsilon{j}*eye(cMa);
            s45 = zeros(cMa,cMa);
            s46 = zeros(cMa,cMa);
            s55 = -epsilon_a{j}*eye(cMa);
            s56 = zeros(cMa,cMa);
            s66 = -epsilon_x{j}*eye(cMa);
            S{j} = [s11,s12,s13,s14,s15,s16;
                s12',s22,s23,s24,s25,s26;
                s13',s23',s33,s34,s35,s36;
                s14',s24',s34',s44,s45,s46;
                s15',s25',s35',s45',s55,s56;
                s16',s26',s36',s46',s56',s66];
        end
        
        rS = size(S{1});
        
        %Define constraints for the bounds
        for j =1:M
            E{j} = (eta - gamma{j}*(betaf)^2-epsilon_x{j}*xe'*Na{j}'*Na{j}*xe);
        end
        
        constS = cellfun(@(s,e) [s<=-lmitol*eye(rS);e>=lmitol],S,E,...
            'UniformOutput',false);
        constraints= [constraints,[constS{:}]];
        
        objective = [];
        
        lmiMat.S = S;
    end
    
  
end


