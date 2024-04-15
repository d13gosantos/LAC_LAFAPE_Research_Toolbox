function f_dyn = fault_dyn(obsSys,faultParams)
%     Return the dynamic of fault system as a function
%     UNTITLED4 Simulate one fault detection observer output.
%       Runs the simulation and gives the
%     results
%     Fault dynamics
    Asigma = obsSys.Asigma;
    bsigma= obsSys.bsigma;
    Csigma=obsSys.Csigma;
    Dsigma = obsSys.Dsigma;
    K = obsSys.K;
    xe = obsSys.xe;
    Kxe = K'*xe;
    theta0 = faultParams.theta0;
    theta = faultParams.theta;
    tfault = faultParams.tfault;
    sensors = faultParams.sensors;
    n = length(xe);
    f_dyn = @(t,x,Lsigma,Lcsigma) sys_dyn(t,x,Lsigma,Lcsigma);
    thetaf = theta0;
         Aincert = zeros(4);
%     Aincert(4,4) = - 200;
%     yincert = rand(1,4)';
%    Ltest = place(Asigma{1,2},Csigma{1,1},[-0.1;-0.2;-0.3;-0.15]);
        
    function xdot_aug = sys_dyn(t, x_aug,Lsigma,Lcsigma)
        
%         myFun - Description
%         
%         Syntax: xdot = xdot_sys(t,x)
%         
%         Long description
        x = x_aug(1:n,1);
        xhat = x_aug(n+1:2*n,1);
        xhat1 = x_aug(2*n+1:3*n,1);
        f = sensorgainfault(x,t,1,theta0,tfault,sensors,theta,Csigma);
        thetaf(sensors(t >= tfault)) = theta(sensors(t >= tfault));
        f = thetaf;%diag(t>=tfault)*theta; %Offset faults
        y = Csigma{1,1}*x+ Dsigma{1,1}*f;%+10*(t>0.15)*yincert; %rand(1,4)';
        
        sigma = (K'*xhat1-Kxe> 0)+1;
        xdot_aug(1:n,1) = Asigma{1,sigma}*x+ bsigma{1,sigma};
        xdot_aug(n+1:2*n,1) = Asigma{1,sigma}* xhat + bsigma{1,sigma}+ ....
            Lsigma{1,sigma}*(y - Csigma{1,1}*xhat);
        xdot_aug(2*n+1:3*n,1) = Asigma{1,sigma}* xhat1 + bsigma{1,sigma}+ ....
            Lcsigma{1,sigma}*(y - Csigma{1,1}*xhat1);
    end
    
     function xdot_aug = fault_dyn(t, x_aug,L)
        
        %myFun - Description
        %
        % Syntax: xdot = xdot_sys(t,x)
        %
        % Long description
        x = x_aug(1:n,1);
        xhat = x_aug(n+1:2*n,1);
        f = sensorgainfault(x,t,1,theta0,tfault,sensors,theta,Csigma);
        y = Cd*x + Dsigma{1,1}*f;
        sigma = (K'*Cdinv*y-Kxe> 0)+1;
%         f = sensorgainfault(x,t,sigma,theta0,tfault,sensors,theta,Csigma);
%         y = Csigma{1,sigma}*x + Dsigma{1,sigma}*f;
        
        %An augmented system to solve in the ODE
        xdot_aug(1:n,1) = Asigma{1,sigma}*x + bsigma{1,sigma};
        xdot_aug(n+1:2*n,1) = Asigma{1,sigma}* xhat + bsigma{1,sigma}+ ....
            L*(y - Csigma{1,sigma}* xhat);      
    end
end


