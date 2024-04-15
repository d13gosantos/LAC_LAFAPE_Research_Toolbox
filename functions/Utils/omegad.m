    function omega_d = omegad(eta,lambdaPmax,gamma,n,muzero,muthree)
        omega_d = sqrt((gamma^2-muthree)/...
            (n*(eta*lambdaPmax+ muzero)));
    end