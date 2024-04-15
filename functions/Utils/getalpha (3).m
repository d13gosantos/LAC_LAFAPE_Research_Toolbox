function alpha = getalpha(gammad,gammamax,theta_a_bar,theta_x_bar,omega,betabar,fmin) 
    %Calculate alpha with given fmin
    alpha = ((betabar*fmin)^2- gammad*gammamax^2)/(theta_a_bar*omega^2+(theta_x_bar));
end
