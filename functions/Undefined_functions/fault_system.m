%run('fault_system_config.m');
%%
%Detection Observers
% lambda = 0.6;
% xe = equilibrium(Asigma,bsigma,lambda);
Cxe = C1*xe;
Tmax = {0.0004,0.0005};
muControl = {1.0001,1.0002};
etaControl ={3,2};
%%
%Create matrices for isolation in each observer in a DOS scheme
Svec = [1 1 1];
etaVec = {{6,6},{5,8},{2,1}};
etaVec2 = {9,9,80};
muVec= {{1.0001,1.0002},{2,1.004},{1.00001,1.00002}};
tauap = @(tau,eta,mu) (tau/(eta*tau-log(mu)));
tau = {2/10^3,2/10^3};
alpha = 0.01;
omegazero = optparams.omegazero;
for i = 1:p 
    [obsSys{i},Lsigma{i},Rsigma{i},params,lmiMat] = uncertfdiocontinuos2(obsSys{i},etaVec2{i},omegazero,1);
end
%%

nuinfty = 10^9;
etatildemax = 91;
etatildesteps = 0.5;
% etatildemax = 2;
% etatildesteps = 0.5;

[reg_optparams,reg_vectors,obsSysOpt] = optimizeobserver(obsSys,omega,1,etatildemax,etatildesteps,nuinfty);
obsSys = obsSysOpt;

