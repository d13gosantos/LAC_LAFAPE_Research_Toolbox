function [K, Lsigma, P] = obssascontrol_LMI(Asigma,bsigma,Csigma, xe)
    %myFun - Calculates the gain for the switched control
    %
    % Syntax: [K,P] = myFun(Asigma,bsigma,xe)
    %
    % Long description
    M = length(Asigma);  
    rA = size(Asigma{1,1},1);
    cA = size(Asigma{1,1},2);
    rC = size(Csigma{1,1},1);
    cC = size(Csigma{1,1},2);
    
    P = sdpvar(rA,cA);
    Wsigma = arrayfun(@(i) sdpvar(cC,rC,'full'),1:M,'UniformOutput',false);
    tolerance = 1e-5;
    restr= [P >= tolerance];
    for j = 1:M 
        a11 = P*Asigma{1,j}+ Asigma{1,j}'* P + Wsigma{1,j}*Csigma{1,j}+...
                Csigma{1,j}'*Wsigma{1,j}';
        a12 = Csigma{1,j}'*Wsigma{1,j}';
        a21= a12';
        a22 = Asigma{1,j}'* P + P* Asigma{1,j};
        restr = [restr, [a11 a12; a21 a22] <= -tolerance];
    end
    opts=sdpsettings('solver','mosek','verbose',0);
    optimize(restr,[],opts);
    %Check LMI conditions
    if min(checkset(restr)) <= 0
        fprintf(['LMI is unfeasible \n'])
        P = [];
        K = [];
        Lsigma = [];
    else
        fprintf(['LMI is feasible' '\n'])
        P = value(P);
        Wsigma = cellfun(@value,Wsigma,'UniformOutput',false);%value(W);
        Lsigma = cellfun(@(W) -inv(P)*W,Wsigma,'UniformOutput',false);
        zeta = P * ((Asigma{1,1} - Asigma{1,2})*xe + (bsigma{1,1}-bsigma{1,2}));
        K = zeta;
    end
end
