function omega_fr = omegafr(beta,Q,q,p2)
    omega_fr = sqrt((beta^2 - p2*lambdamax(Q))/q);
end