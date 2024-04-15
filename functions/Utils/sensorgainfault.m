function [f,thetaf] = sensorgainfault(x,t,sigma,theta0,tfault,sensors,theta,Csigma)
    thetaf = theta0;
    thetaf(sensors(t >= tfault)) = theta(sensors(t >= tfault));
    f =diag(thetaf)*(Csigma{1,sigma}*x)- Csigma{1,sigma}*x;
end

   