function [S,E,R,H,emaxS,nmaxE,alpha,beta,nu,zetamax] =  boundcalculation(obsSys,fbound,eta,Tmax)
    %Calculates the radius of the ball with control
   % delta = {-1,1};
    delta = {0,0};
    tau = {{Tmax{1},Tmax{1}},{0,0}}; %Create number of zeros equals to the number of subsystems
    %tau = {Tmax},{0,0}}; %Create number of zeros equals to the number of subsystems
    %tau = {{Tmax{1},Tmax{1}},{Tmax{1},Tmax{1}}};
   % tau = {{0,0},{0,0}};
    A = obsSys.Asigma;
    A1 = A{1};
    A2 = A{2};
    C = obsSys.Csigma;
    b = obsSys.bsigma;
    b1 = b{1}; b2 = b{2};
    F = obsSys.Dsigma;
    P = obsSys.P;
    Z = obsSys.Z;
    U = obsSys.U;
    G = obsSys.Gsigma;
    xe = obsSys.xe;

    %Uncertain matrices
    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    Qa = cellfun(@(m,n) m*n,Ma,Na,'UniformOutput',false);
%     epsilon = {0.06,0.006};%Best value
    epsilon = {0.05,0.06};%Best value
    Atilde = cellfun(@(a,g,c) a-g*c,A,G,C,'UniformOutput',false);
    %Dimensions
    %Sizes of fault and remaining faults vector
    M = length(A);
    [~,cA] = size(A{1});
    tausym = sym('tausym');
    lambda = obsSys.lambda;
    bd2 = double(int(expm(A2*tausym)*b2,[0 Tmax{1}]));
    bd1 = double(int(expm(A1*tausym)*b1,[0 Tmax{1}]));
    Ad1 = expm(A1*Tmax{1});
    Ad2 = expm(A2*Tmax{1});
    xed= -inv(-eye(2)+((Ad1)*lambda + (Ad2)*(1-lambda)))*(bd1*lambda+bd2*(1-lambda));
%     phihatMax = [15;-1.5];
%     phiMax = [15;-1.5];
     phihatMax = [15;-1.5]/Tmax{1};
     phiMax = [15;-1.5]/Tmax{1};
%                 phihatMax = [-15;15]/Tmax{1};
%                 phiMax = [-15;15]/Tmax{1};
    %Using the approximation of the derivative : xdot= (x(k+1)-x(k))/Tmax
    %Lyapunov
    for j = 1:M
        for d = 1:2
            for tt = 1:2
                s11 = P*(A{j}+delta{d}*Qa{j}) + (A{j}+delta{d}*Qa{j})'*P...
                    -P*G{j}*C{j} - C{j}'*G{j}'*P + eta{j}*P + (Tmax{j}-tau{tt}{j})*(Atilde{j}'*Z{j}*Atilde{j}+Atilde{j}'*Z{j}*delta{d}*Qa{j}...
                    +Qa{j}'*Z{j}*Qa{j}+C{j}'*G{j}'*G{j}*C{j})+1/epsilon{j}*eye(cA)+...
                    (-tau{tt}{j})*(Atilde{j}'*Z{j}*Atilde{j}+Atilde{j}'*Z{j}*delta{d}*Qa{j}...
                    +Qa{j}'*Z{j}*Qa{j}+C{j}'*G{j}'*G{j}*C{j})*exp(-eta{j}*Tmax{j});
                s12 = delta{d}*P*Qa{j}+C{j}'*G{j}'*P+ (Tmax{j}-tau{tt}{j})*(C{j}'*G{j}'*A{j}+Qa{j}'*Z{j}*Qa{j})...
                        +(-tau{tt}{j})*(C{j}'*G{j}'*A{j}+Qa{j}'*Z{j}*Qa{j})*exp(-eta{j}*Tmax{j});
                s22 = P*A{1,j} + A{1,j}'*P + (Tmax{j}-tau{tt}{j})*(A{j}'*U{j}*A{j}+...
                    +Qa{j}'*Z{j}*Qa{j})+1/epsilon{j}*eye(cA)+(-tau{tt}{j})*(A{j}'*U{j}*A{j}+...
                    +Qa{j}'*Z{j}*Qa{j})*exp(-eta{j}*Tmax{j})+ eta{j}*P;
                Sd{d} = [s11,s12;
                    s12',s22];
                
                eigSd(d) = eigmax(Sd{d});
                e11 = -P*G{j}*F{j}*fbound+delta{d}*P*Qa{j}*xe+ (Tmax{j}-tau{tt}{j})*(-Atilde{j}'*Z{j}*G{j}*F{j}*fbound+...
                        Atilde{j}'*Z{j}*delta{d}*Qa{j}*xe+Qa{j}'*Z{j}*Qa{j}*xe-delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound)...
                         +(-tau{tt}{j})*(-Atilde{j}'*Z{j}*G{j}*F{j}*fbound+...
                        Atilde{j}'*Z{j}*delta{d}*Qa{j}*xe+Qa{j}'*Z{j}*Qa{j}*xe...
                        -delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound)*exp(-eta{j}*Tmax{j})+...
                        tau{tt}{j}*(C{j}'*G{j}'*P*(A{j}*xe+b{j}))*exp(-eta{j}*Tmax{j});
                e21 = P*G{j}*F{j}*fbound+(Tmax{j}-tau{tt}{j})*(-delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound+Qa{j}'*Z{j}*Qa{j}*xe+...
                    A{j}'*U{j}*A{j}*xe + A{j}'*U{j}*b{j}+A{j}'*U{j}*G{j}*F{j}*fbound)+...
                    (-tau{tt}{j})*(-delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound+Qa{j}'*Z{j}*Qa{j}*xe+...
                    A{j}'*U{j}*A{j}*xe + A{j}'*U{j}*b{j}+A{j}'*U{j}*G{j}*F{j}*fbound)*exp(-eta{j}*Tmax{j})+...
                    tau{tt}{j}*(A{j}'*P*(A{j}*xe+b{j}))*exp(-eta{j}*Tmax{j});
                Ed{d} = [e11;e21];
                
                Rd{d} = (Tmax{1}-tau{tt}{j})*(xe'*Qa{j}*Z{j}*Qa{j}*xe-2*xe'*delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound+...
                            xe'*A{j}'*U{j}*A{j}*xe +  2*xe'*A{j}'*U{j}*b{j}+ 2*xe'*A{j}'*U{j}*G{j}*F{j}*fbound+...
                            fbound'*F{j}'*G{j}'*Z{j}*G{j}*F{j}*fbound+fbound'*F{j}'*G{j}'*U{j}*G{j}*F{j}*fbound)+...
                            (-tau{tt}{j})*(xe'*Qa{j}*Z{j}*Qa{j}*xe-2*xe'*delta{d}*Qa{j}'*Z{j}*G{j}*F{j}*fbound+...
                            xe'*A{j}'*U{j}*A{j}*xe +  2*xe'*A{j}'*U{j}*b{j}+ 2*xe'*A{j}'*U{j}*G{j}*F{j}*fbound+...
                            fbound'*F{j}'*G{j}'*Z{j}*G{j}*F{j}*fbound+fbound'*F{j}'*G{j}'*U{j}*G{j}*F{j}*fbound)*exp(-eta{j}*Tmax{j})+...
                            2*tau{tt}{j}*(fbound'*F{j}'*G{j}'*P*(A{j}*xe+b{j})*exp(-eta{j}*Tmax{j})...
                            +xe'*A{j}'*P*(A{j}*xe+b{j})+b{j}'*P*(A{j}*xe+b{j}))*exp(-eta{j}*Tmax{j});
                
                normEd(d) = norm(Ed{d});
                
                %R{tt,j} =   Rd{d};
                
            end
             
        end
        [~,maxSd] = max(eigSd);
        S{j} = Sd{maxSd};
        [~,maxEd] = max(normEd);
        E{j} = Ed{maxEd};
        normE(j) = norm(E{j});
        R{j} = Rd{maxEd};
        H{j} = -tau{tt}{j}*phihatMax'*U{j}*phihatMax*exp(-eta{j}*Tmax{j})...
                        -tau{tt}{j}*phiMax'*U{j}*phiMax*exp(-eta{j}*Tmax{j})+2*tau{tt}{j}*phihatMax'*P*(A{j}*xe+b{j});
        numalpha{j} = (eigmax(S{j}));
        alpha{j} = numalpha{j}/eigmax(P);
        nu{j} = (S{j}^-1)*E{j};
        %beta{j} = 2*[-0.5 -0.5 -10 -30]*E{j}+R{j}+H{j};
        beta{j} = epsilon{j}*norm(E{j})^2+R{j};%+H{j};
        %beta{j} = (E{j})'*(-S{j}^-1)*E{j}+R{j}%+H{j};
        zetamax{j} =  sqrt(beta{j}/abs(alpha{j}));
        %Vdot{j} = eigmax(S{j});
    end
    emaxS = eigmax(S);
    nmaxE = max(normE);
    %alpha = emaxS/eigmax(P) +1;
    %V(delta,tau,j)
    %Vdot <= (eigmax(S)+1/epsilon)*norm(zeta)^2 + epsilon*norm(E)+ R + H + 
    %Vdot <= -abs(alpha)*V - eta*w  epsilon*norm(E)+ R
    
end