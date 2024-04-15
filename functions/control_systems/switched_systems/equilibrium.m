function [xe,Alambda,blambda] = equilibrium(Asigma,bsigma,lambda)
    %Get equilibrium point for two subsystems
    Alambda = lambda*(Asigma{1} - Asigma{2}) +  Asigma{2};
    blambda = lambda*(bsigma{1}- bsigma{2}) +  bsigma{2};%lambda = 0.5;
    xe = -Alambda^(-1)*blambda;
 
end