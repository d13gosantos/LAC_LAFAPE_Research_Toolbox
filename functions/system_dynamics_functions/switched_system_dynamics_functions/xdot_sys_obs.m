function xdot_aug = xdot_sys_obs(~,x_aug, Asigma, bsigma, Csigma, K, Kxe, Lcsigma,n)
    %myFun - Description
    %
    % Syntax: xdot1 = xdot_sys1(t,x)
    %
    % Long description
    x = x_aug(1:n,1);
    xhat = x_aug(n+1:2*n,1);
    sigma = (K'*xhat-Kxe> 0)+1;
    %An augmented system to solve in the ODE
    xdot_aug(1:n,1) = Asigma{1,sigma}*x+ bsigma{1,sigma};
    y = Csigma{1,1}*x;
    xdot_aug(n+1:2*n,1) = Asigma{1,sigma}* xhat + bsigma{1,sigma}+ ....
        Lcsigma{1,sigma}*(y - Csigma{1,1}*xhat);   
 
end
