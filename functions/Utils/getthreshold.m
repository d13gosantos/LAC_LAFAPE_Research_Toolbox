function [jth,jthmax] = getthreshold(gamma,gammax,theta_a_bar,theta_x_bar,omega,alpha) 
    %Threshold calculation
    %Gammamax is equivalent to dfbound
    jthmax =  sqrt(gamma*gammax^2 +(theta_a_bar*omega^2+theta_x_bar));
    jth =  sqrt(gamma*gammax^2 + alpha*(theta_a_bar*omega^2+theta_x_bar));
end