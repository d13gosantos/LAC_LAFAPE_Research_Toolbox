%Fault detecition and Isolation in a boost DC-DC converter
%% Sensor gain deviation and loss of sensor signal faults are tested
%Main
%System without fault


tmax = 1;
% opts = odeset('RelTol',1e-2,'AbsTol',1e-2);
% opts = odeset('RelTol',3e-3,'AbsTol',1e-6);
opts = odeset('RelTol',1e-3,'AbsTol',1e-9,'Refine',1, 'Stats','off');
% [t, x] = ode45(@(t,x) xdot_sys(t,x,Asigma, bsigma, K, Kxe),...,
%     [0 tmax], x0, opts);
[t, x] = ode45(@(t,x_aug) xdot_sys_obs(t,x_aug,Asigma, bsigma, Csigma,...,
                K, Kxe, Lcsigma,n),...,
    [0 tmax], zeros(8,1), opts);
figure;
plot(t,x);
%
%%
%obsSim = sim_mult_faults(obsSys,faultParams,odeParams);
%%
%faultParams.theta =[5*xe(1);5*xe(2);5*xe(4)];
faultParams.theta =[9*xe(1);9*xe(2);0.1*xe(4)];
faultParams.theta0 =[0;0;0];
faultParams.tfault = [0.15;0.30;0.45];
%faultParams.tfault = [2;2;2];
faultParams.sensors = [1 2 3];
odeParams.timeInt = [0 0.6];
%%
obsSim3 = simfaultobserver(obsSys{3},faultParams, odeParams);
%obsSim2 = simfaultobserver(obsSystest,faultParams, odeParams);
%obsSim = sim_mult_faults(obsSys,faultParams,odeParams);

%obsSim = simfaultobservers(obsSys,faultParams, odeParams);


