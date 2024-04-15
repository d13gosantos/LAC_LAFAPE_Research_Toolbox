function f_dyn = fault_dyn_uncertain(obsSys,faultParams)
    %Return the dynamic of fault system as a function
    %UNTITLED4 Simulate one fault detection observer output.
    %   Runs the simulation and gives the
    %results
    %Fault dynamics
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
    P = obsSys.lmiMat.P;
    n = length(P);
    Po = P(1:n-1,1:n-1);
    %Po = diag([0.0001,-0.0002 5000]);
    Mb = diag([5000,0,0,0]);
    Nb = [1 0 0 0]';
    %Mb = eye(4);
    %Nb = [5000 0 0 0]';
    Gn = Mb(1:n,1:n-1);
    
    %    omega = F(t)*N;
    %   bincert = Mb*omega;
    %   Aincert = zeros(4);
    %     Aincert(4,4) = - 200;
    %     yincert = rand(1,4)';
    %    Ltest = place(Asigma{1,2},Csigma{1,1},[-0.1;-0.2;-0.3;-0.15]);
    Af = diag([-0.0001;-0.0002;-0.0003;-0.0004]);
    Lw =  [diag([1;0;0]);[1 0 0]];
    function xdot_aug = sys_dyn(t, x_aug,Lsigma,Lcsigma)
        
        %myFun - Description
        %
        % Syntax: xdot = xdot_sys(t,x)
        %
        % Long description
        x = x_aug(1:n,1);
        xhat = x_aug(n+1:2*n,1);
        xhat1 = x_aug(2*n+1:3*n,1);
        %f = sensorgainfault(x,t,1,theta0,tfault,sensors,theta,Csigma);
        thetaf(sensors(t >= tfault)) = theta(sensors(t >= tfault));
        f = thetaf;%diag(t>=tfault)*theta; %Offset faults
        %f =  thetaf*3000*sin(2*pi*60*(t));
        y = Csigma{1,1}*x+ Dsigma{1,1}*f;%+10*(t>0.15)*yincert; %rand(1,4)';
        yhat =  Csigma{1,1}*xhat ;%+ Dsigma{1,1}*[1 1.2 2 -2;6 0.5 0.6 4;5.0 3.2 5.78 1]*xhat1;
        yhat1 = Csigma{1,1}*xhat1;
        ey = (y-yhat);
        delta = 0.0001;
        if t <= 0.15
            rho = 5;
        elseif (t>0.15) && (t <= 0.45)
            rho = 0.01;
        else 
            rho = 0.1;
        end
        v = (rho*(Po*ey)/(norm(Po*ey) + delta));
        sigma = (K'*x-Kxe> 0)+1;
        %sigma = (K(1:3)'*(Csigma{1,1}*(x-xe)+ Dsigma{1,1}*f)> 0)+1;Mb*sin(2*pi*60*t)*Nb
       % xdot_aug(1:n,1) = Asigma{1,sigma}*x+ bsigma{1,sigma}+ Mb*sin(2*pi*60*t)*Nb;
        xdot_aug(1:n,1) = Asigma{1,sigma}*x+ bsigma{1,sigma}+ Mb*(1)*Nb;
        xdot_aug(n+1:2*n,1) = Asigma{1,sigma}* xhat + bsigma{1,sigma}+ ....
            Lsigma{1,1}*(y - yhat) + Gn*v;%+ Mb*xhat1;% + Gn*v;
%         xdot_aug(2*n+1:3*n,1) = Asigma{1,sigma}* xhat1 + bsigma{1,sigma}+ ....
%             Lcsigma{1,sigma}*(y - Csigma{1,1}*xhat1);
        xdot_aug(2*n+1:3*n,1) = Lw*(y - yhat) + Af*xhat1;
    end
    
end


