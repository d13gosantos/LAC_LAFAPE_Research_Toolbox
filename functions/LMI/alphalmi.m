function [alpha,delta,fminbar,alpha_min] = alphalmi(obsSys,delta2,omega)
     lmitol = 1e-8;
      opts=sdpsettings('solver','sdpt3','verbose',0); %Mosek solves more

    epsilonx = obsSys.params.epsilon_x;

    Ma = obsSys.Masigma;
    Na = obsSys.Nasigma;
    P = obsSys.P;
    betabar= obsSys.params.betabar;
    gammabar = obsSys.params.gammabar;
    dmax = obsSys.dmax;
    fmin = obsSys.fmin;
    fmax = obsSys.fmax;
    alpha = sdpvar(1,1);
    delta = sdpvar(1,1);
    fminbar = fmin^2;
    %fminbar = sdpvar(1,1);
    theta_a_bar = obsSys.params.theta_a_bar;

    epsilon_x_bar = obsSys.params.epsilon_x_bar;
  
    alpha_min = (betabar^2*(fminbar)-(1+sqrt(2))^2*(gammabar*dmax)^2)/((1+sqrt(2))^2*(theta_a_bar*omega^2));
    Lmi{length(Ma),1} = [];
    for i = 1:length(Ma)
        lmi12 = delta*P*Ma{i}*Na{i};
        Lmi{i} = [-alpha*epsilonx{i}^(-1)*P*Ma{i}*Ma{i}'*P,lmi12;
                    lmi12',-alpha*epsilonx{i}*Na{i}'*Na{i}];
    end
    constraintLmi = cellfun(@(lmi) [lmi<=0],Lmi,'UniformOutput',false);
    constraints = [[constraintLmi{:}],alpha<=alpha_min,alpha>=lmitol,...
                    delta<=1,delta>=0, fminbar>=0,fminbar<=fmax^2
                    betabar^2*fminbar >= (1+sqrt(2))*gammabar^2*dmax^2,alpha<=1,alpha>=0];
%    constraints = [[constraintLmi{:}],alpha<=alpha_min,alpha>=lmitol,...
%                     delta<=1,delta>=0];
   % constraints = [[constraintLmi{:}],alpha<=1];
    optimize(constraints,[-delta+0.01*fminbar], opts);
    [primal,~]=checkset(constraints);
    che = min(round(primal*10^8));
      if che >= 0
          alpha = value(alpha);
          delta = value(delta);
          %fmin = sqrt(value(fmin));
          fminbar = sqrt(value(fminbar));
      else 
          alpha = -100;
          delta = -100;
          fminbar = -100;
      end
end