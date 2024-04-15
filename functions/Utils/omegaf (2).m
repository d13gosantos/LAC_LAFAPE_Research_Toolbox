  function omega_f = omegaf(eta,lambdaPmax,beta2,Q,p2,muone,muzero)
        omega_f = sqrt((muone+p2*lambdamax(Q) - beta^2)/...
            (eta*lambdaPmax - muzero));
    end