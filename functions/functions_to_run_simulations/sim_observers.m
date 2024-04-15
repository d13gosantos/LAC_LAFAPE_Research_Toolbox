function xdot = sim_observers(t,xhat,f,y,t_old,x_old,xe,K,Asigma,bsigma,L,Csigma,Dsigma)
    
%     sigma_i = interp1(t_old,sigma,t,'linear');
%     f_i = interp1(t_old,f',t,'linear');,
    x_i = interp(t_old,x_old',t,'linear');
    sigma_i = get_sigma(K,x_i',xe);
    y_i = interp1(t_old,y',t,'nearest');
%       n = size(Asigma{1,1},1);
%     x = x_aug(1:n,1);
%     xhat = x_aug(n+1:2*n,1);
%     ef = x_aug(2*n+1:3*n,1);
  
    %An augmented system to solve in the ODE
%     xdot_aug(1:n,1) = Asigma{1,sigma_i}*x + bsigma{1,sigma_i};
%     xdot = Asigma{1,sigma_i}* xhat + bsigma{1,sigma_i}+ ....
%         L*(y_i') - L*Csigma{1,sigma_i}* xhat;
      xdot = ((2-sigma_i)*(Asigma{1,1}- Asigma{1,2}) + Asigma{1,1})*xhat +...
          bsigma{1,2}+ L*(y_i') - L*Csigma{1,1}* xhat;
    

%     xdot_aug(2*n+1:3*n,1) = (Asigma{1,sigma_i}-L*Csigma{1,sigma_i})*ef -...
%         L*(Dsigma{1,sigma_i}*f_i');
    
end