function [jth,jthmax,theta_a_bar,theta_x_bar] = threshold(gamma,dfbound,theta_a,xe,theta_x,omega,alpha,Na)
    Nsquare = cellfun(@(N) N'*N,Na,'UniformOutput',false);
    Nxesquare = cellfun(@(N) xe'*N'*N*xe,Na,'UniformOutput',false);
    theta_a_bar = max([theta_a{:}])*eigmax(Nsquare);
    theta_x_bar = max([theta_x{:}])*eigmax(Nxesquare);
    
    jthmax =  sqrt(gamma*dfbound^2 + (theta_a_bar*omega)^2+(theta_x_bar)^2);
    jth =  sqrt(gamma*dfbound^2 + alpha*(theta_a_bar*omega^2+theta_x_bar));
end