function [t,x,f,y,sigma] = get_fault_output(faultsys,faultParams,odeParams,K)
    
    Asigma = faultsys.Asigma;
    bsigma= faultsys.bsigma;
    Csigma=faultsys.Csigma;
    Dsigma = faultsys.Dsigma;
    xe = faultsys.xe;
    theta0 = faultParams.theta0;
    theta = faultParams.theta;
    tfault = faultParams.tfault;
    sensors = faultParams.sensors;

    timeInt = odeParams.timeInt;
    x0 = odeParams.x0;
    opts = odeParams.opts;
    p = size(Csigma{1,1},1);
%     y = zeros(p,len_t);
%     f = zeros(p,len_t);
    i = 1;
    y_i = x0;
    sigma_i = 1;
    function xdot = fault_dyn(t,x)
%         f_i = sensorgainfault(x,t,sigma_i,theta0,tfault,sensors,...,
%                                     theta,Csigma);
%         y_i = Csigma{1,sigma_i}*x+ Dsigma{1,sigma_i}*f_i;
        if K'*(x-xe)<= 0
            sigma_i = 1;
        else
            sigma_i = 2;
        end   
        xdot = Asigma{1,sigma_i(:,i)}*x + bsigma{1,sigma_i}; 
    end
    [t, x] = ode45(@fault_dyn,timeInt,x0,opts);
    len_t = length(t);
    sigma = ones(len_t,1);
    y = zeros(p,len_t);
    f = zeros(p,len_t);
    for j = 1:len_t
        sigma(j) = get_sigma(K,x(j,:)',xe);
        f(:,j) = sensorgainfault(x(j,:)',t(j),sigma(j),theta0,tfault,sensors,...,
                                    theta,Csigma);
        y(:,j) = Csigma{1,sigma(j)}*x(j,:)'+ Dsigma{1,sigma(j)}*f(:,j);
    end

    x = x';
end
