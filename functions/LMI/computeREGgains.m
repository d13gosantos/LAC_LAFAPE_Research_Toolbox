function [estErrors_ezOut,optResults] = computeREGgains(estErrors_ez,sensorFaults,eta,omega0)
    % computeREGgains Compute gains Lsigma and Rsigma for a single residual
    % error gerator with a given estErrors_ez and sensorFaults parameters
    %
    %   [estErrors_ezOut,optResults] = computeREGgains(estErrors_ez,sensorFaults,eta,omega0)
    %   computes the gains L and R for a residual error generator with given
    %   eta > 1 and omega0 representing the bound of x.
    %
    %   sensorFaults is a struct containing the following fields
    %       fmax: maximum bound for a fault in a sensor
    %       dmax: maximum bound for remaining faults
    %       SensorNumber: number of faulty sensor
    %
    %   estErros_ez is a struct containing the matrices of an estimation
    %   erorr dynamics
    
    %Solver settings
    lmitol = 1e-8; %Lmi tolerance
    opt_settings=sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more
    
    nSys = length(estErrors_ez.Asigma); %(number of systems);
    
    %% Given LMI matrices and parameters
    %Parameters
    dfmax = sensorFaults.dfmax;
    fmax = sensorFaults.fmax;

    % Matrices
    A = estErrors_ez.Asigma;
    C = estErrors_ez.Csigma;
    D = estErrors_ez.Dsigma;
    E = estErrors_ez.Esigma;
    M = estErrors_ez.Msigma;
      
    % Set dimensions
    p = size(C{1,1},1);
    rA = size(A{1,1},1);
    cA = size(A{1,1},2);
    rC = size(C{1,1},1);
    cC = size(C{1,1},2);
    cD = size(D{1,1},2);
    cE = size(E{1,1},2);
    cM = size(M{1,1},2);
    
    %% Optimization variables
    
    % Scalars
    gamma = sdpvar(1,1);
    beta = sdpvar(1,1);
    epsilonx_sigma = arrayfun(@(x) sdpvar(1,1),1:nSys,'UniformOutput',false);
    
    % Matrices
    P =  sdpvar(cA,rA);
    Wsigma = arrayfun(@(i) sdpvar(rC,cC,'full'),1:nSys,'UniformOutput',false);
    Hsigma = arrayfun(@(i) sdpvar(p,p),1:nSys,'UniformOutput',false);
    
    % Assign initial parameters for the optimization variables
    % Parameters
    assign(gamma,lmitol);
    assign(beta,lmitol);
    cellfun(@(var) assign(var,lmitol),epsilonx_sigma,'UniformOutput',false);
    
    % Matrices
    assign(P,lmitol*eye(cA,rA));
    cellfun(@(var) assign(var,lmitol*eye(rC,cC)),Wsigma,'UniformOutput',false);
    cellfun(@(var) assign(var,lmitol*eye(p)),Hsigma,'UniformOutput',false);
    
    
    %% LMI global constraints
    % Parameters
    beta_constraint = beta>=lmitol;
    gamma_constraint = gamma>=lmitol;
    epsilon_x_constraintArray = arrayfun(@(i) epsilonx_sigma{i}>=lmitol,1:nSys,'UniformOutput',false);
    epsilon_x_constraint = [epsilon_x_constraintArray{:}];
    param_constraints = [beta_constraint,gamma_constraint,epsilon_x_constraint];
    
    % Matrices
    P_constraint = P>=lmitol*eye(cA);
    H_constraintArray = arrayfun(@(i) Hsigma{1,i}>=lmitol*eye(p),1:nSys,'UniformOutput',false);
    H_constraint = [H_constraintArray{:}];
    matrices_constraints = [P_constraint,H_constraint];
    
    %% LMI local constraints
    
    [Sminus_optResults,Sminus_constraints] = Sminus(); %Sminus LMI constraints
    [Linfty_optResults,Linfty_constraints] = LinftyUncert();%Linfty LMI constraints
    
    %% LMI objectives initialization
    Sminus_objective = -beta;
    Linfty_objective = gamma;
    
    %% Optimization
    opt_constraints = [param_constraints,matrices_constraints,...
                        Sminus_constraints,Linfty_constraints];
                    
    opt_objective = Sminus_objective+Linfty_objective;
    
    optimize(opt_constraints,opt_objective,opt_settings);
    
    %% Optimization check
    [primal,~]= checkset(opt_constraints);
    check = min(round(primal*1/lmitol));
    
    estErrors_ezOut = estErrors_ez;
    
    if check >= 0
        fprintf(['The LMI is feasible, then the residual error generator,'...
            '%d is stable with eta = %d\n'],sensorFaults.SensorNumber,eta);
        
        %Attribute the outputs
        optResults = get_feasibleOptResults;
     
    else
        fprintf('The LMI is unfeasible for residual error generator %d with eta = %d \n',...
            sensorFaults.SensorNumber,eta);
        
        %Attribute empty values
        optResults = get_unfeasibleOptResults;
       
    end
    
    estErrors_ezOut.Lsigma = optResults.Lsigma;
    estErrors_ezOut.Rsigma = optResults.Rsigma;
    
    
    function [Sminus_optResults,Sminus_constraints] = Sminus()
        %Sminus Set constraints for Sminus performance
        Psi{1,nSys} = [];
        
        % Constraints to achieve Sminus performance
        for swIdx=1:nSys
            Psi11= P*A{1,swIdx}+A{1,swIdx}'*P+C{1,swIdx}'*Wsigma{1,swIdx}+Wsigma{1,swIdx}'*C{1,swIdx} ...
                +eta*P-C{1,swIdx}'*Hsigma{1,swIdx}*C{1,swIdx};
            Psi12= Wsigma{1,swIdx}'*D{1,swIdx}-C{1,swIdx}'*Hsigma{1,swIdx}*D{1,swIdx};
            Psi22 = beta*eye(cD)-D{1,swIdx}'*Hsigma{1,swIdx}*D{1,swIdx};
            Psi{swIdx} = [Psi11,Psi12;
                Psi12',Psi22];
        end
        
        %Constraints to achieve stability
        bSminus{1,nSys} = [];
        for swIdx = 1:nSys
            s12 = -C{1,swIdx}'*Hsigma{1,swIdx}*D{1,swIdx};
            bSminus{swIdx}=[eta*P-C{1,swIdx}'*Hsigma{1,swIdx}*C{1,swIdx}-P,s12;
                s12',D{1,swIdx}'*Hsigma{1,swIdx}*D{1,swIdx}-beta*eye(cD)-1/fmax^2];
        end
%                bSminusMatrix = arrayfun(@(i) sdpvar(rbS,rbS),1:nSys,'UniformOutput',false);
        % All Sminus constraints
        rPsi = size(Psi{1},1);
        rbS = size(bSminus{1},1);
        
        Sminus_constraintsArray = cellfun(@(p,s) [p<=-lmitol*eye(rPsi),...
            s>=lmitol*eye(rbS)],Psi,bSminus,...
            'UniformOutput',false);
        Sminus_constraints= [Sminus_constraintsArray{:}];
        
        Sminus_optResults.Psi = Psi;
        Sminus_optResults.bSminus = bSminus;
    end
    
    function [Linfty_optResults,Linfty_constraints] = LinftyUncert()
        %LinftyUncert Set constraints for Linfty performance
        
        % LMI Constraints for Linfty performance
        Theta{1,nSys} = [];
        
        for swIdx=1:nSys
            Theta11 = P*A{1,swIdx}+A{1,swIdx}'*P+C{1,swIdx}'*Wsigma{1,swIdx}...
                +Wsigma{1,swIdx}'*C{1,swIdx}+eta*P+C{swIdx}'*Hsigma{swIdx}*C{swIdx};
            Theta12 = Wsigma{1,swIdx}'*E{1,swIdx}+ C{1,swIdx}'*Hsigma{1,swIdx}*E{1,swIdx};
            Theta13 = P*M{1,swIdx};
            Theta22 = -gamma*eye(cE)+E{1,swIdx}'*Hsigma{1,swIdx}*E{1,swIdx};
            Theta23 = zeros(cE,cM);
            Theta33 = -epsilonx_sigma{swIdx}*eye(cM);
            Theta{swIdx} = [Theta11 Theta12 Theta13;
                Theta12' Theta22 Theta23;
                Theta13' Theta23' Theta33];
        end
        
        % Constraints to guarantee the boundeness of the solution
        bLinfty{1,nSys} = [];
        for swIdx =1:nSys
            bLinfty{swIdx} = (eta-gamma*dfmax^2-epsilonx_sigma{swIdx}*omega0^2);
        end
        
        % All Linfty constraints
        rTheta = size(Theta{1},1);
        Linfty_constraintsArray = cellfun(@(t,b) [t<=-lmitol*eye(rTheta),...
            b>=lmitol],Theta,bLinfty,...
            'UniformOutput',false);
        Linfty_constraints = [Linfty_constraintsArray{:}];
        
        Linfty_optResults.Theta = Theta;
        Linfty_optResults.bLinfty = bLinfty;
    end
    
    function optResults = get_feasibleOptResults
        % get_feasibleOptResults Gets the optResultsrices when optimization is solved
        % succesfully
        optResults.feasible = 1;
        optResults.SensorNumber = sensorFaults.SensorNumber;
        optResults.estErrors_ez = estErrors_ez;
        optResults.eta = eta;
        optResults.omega0 = omega0;
        optResults.fmax  = fmax;
        optResults.dfmax = dfmax;
        optResults.beta = value(beta);
        optResults.betabar = sqrt(optResults.beta);
        optResults.gamma = value(gamma);
        optResults.gammabar = sqrt(optResults.gamma);
        optResults.epsilonx_sigma = cellfun(@value,epsilonx_sigma,'UniformOutput',false);
        optResults.epsilonx = max([optResults.epsilonx_sigma{:}]);
        optResults.eiPmax= eigmax(P);
        optResults.eigPmin= eigmin(P);
        optResults.Psi = value(Sminus_optResults.Psi);
        optResults.bSminus = value(Sminus_optResults.bSminus);
        optResults.Theta = value(Linfty_optResults.Theta);
        optResults.bLinfty = value(Linfty_optResults.bLinfty);
        optResults.P = value(P);
        optResults.Wsigma = cellfun(@value,Wsigma,'UniformOutput',false);
        optResults.Lsigma = cellfun(@(W) -inv(optResults.P)*W',optResults.Wsigma,'UniformOutput',false);
        optResults.Hsigma = cellfun(@value,Hsigma,'UniformOutput',false);
        optResults.Rsigma = cellfun(@(H) sqrtm(H),optResults.Hsigma,'UniformOutput',false);
    end
    
    function optResults = get_unfeasibleOptResults
        % get_unfeasibleOptResults Gets the OptResults when optimization problem
        % is NOT solved succesfully
         optResults.feasible = 0;
        optResults.eta = eta;
        optResults.omega0 = omega0;
        optResults.estErrors_ez = estErrors_ez;
        optResults.fmax  = fmax;
        optResults.dfmax = dfmax;
        optResults.beta = 10^(-9);
        optResults.betabar = 10^(-9);
        optResults.gamma = 10^9;
        optResults.gammabar =10^9;
        optResults.epsilonx_sigma = cellfun(@(i) 10^9,1:nSys,'UniformOutput',false);
        optResults.epsilonx = 10^9;
        optResults.eigPmax = [];
        optResults.eigPmin = [];
        optResults.Psi = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.bSminus = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.Theta = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.bLinfty = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.P = [];
        optResults.Wsigma = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.Lsigma = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.Hsigma = cellfun(@(i) [],1:nSys,'UniformOutput',false);
        optResults.Rsigma = cellfun(@(i) [],1:nSys,'UniformOutput',false);
    end
 
 
    
  

end


