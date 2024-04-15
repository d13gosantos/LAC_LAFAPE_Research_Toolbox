%%
%get thresholds and simulate multiple faults
faultParams.theta =[10;10;10];
faultParams.tfault =[0.15,0.30];
faultParams.maxTheta = 9*ye;
faultParams.minTheta = 0.01*ye;
odeParams.timeInt = [0 0.45];
odeParams.opts = odeset('RelTol',1e-3,'AbsTol',1e-7,'Stats','off');
%odeParams.opts = odeset('RelTol',6e-3,'AbsTol',1e-7,'Stats','off');
faultParams.Ts = Ts;
[thVec,fIdxVec,obsTh] = get_threshold(obsSys,faultParams,odeParams);
%thVec = [0.0017 0.0005 0.0027]
%%
faultParams.theta =[10;10;10];
faultParams.tfault = 0.15;
odeParams.opts = odeset('RelTol',1e-2,'AbsTol',1e-9,'Stats','off');
%odeParams.opts = odeset('RelTol',1e-3,'AbsTol',1e-9,'Stats','off');

