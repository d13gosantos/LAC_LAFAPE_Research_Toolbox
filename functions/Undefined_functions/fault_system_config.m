%%
%Fault matrix of each sensor (The column corresponds to each sensor)
faultsys = uncertSys;
%%

%Uncertainty function
wfunc = @(t) sin(2*pi*60*t);
delta = 0.0001;
etaVec = [5 5 2];
Qgiven = 1;
%Cd = eye(4);
faultsys.Csigma = {C1,C1};

%Distribution matrices (complete)
p = size(C1,1);
n = size(A1,2);
m = size(b1,2);
D1 = [1 0 0;
    0 1 0;
    0 0 1];%eye(p);%the dimensions of the sensors vector
D2 = D1;
Dsigma = {D1,D2};
faultsys.Dsigma = Dsigma;

obsSys = arrayfun(@(i) faultsys,1:p,'UniformOutput',false);

% fbounds = [0.05*Cxe(1), 0.05*Cxe(2), 0.05*Cxe(3)];
% fbounds = [0.5*Cxe(1), 0.5*Cxe(2), 0.5*Cxe(3)];
fbounds = [Cxe(1), Cxe(2), Cxe(3)];
dfbounds = [norm(fbounds(2:3)), norm(fbounds(1:2)),norm([fbounds(1),fbounds(3)])]; %gamma
fboundsmin = [0.1*Cxe(1), 0.1*Cxe(2), 0.1*Cxe(3)]; %beta
maxdfbound = sum(dfbounds);
xhat0 = x0;
ef0 = x0;
x0aug = [x0;xhat0;xhat0];
%x0aug1 = [x0;xhat0];


for i = 1:p
    %     Dfault{i} = cellfun(@(D) D(:,i),Dsigma, 'UniformOutput',false);
    %     Efault{i} = cellfun(@(D) D(:,[1:i-1 i+1:end]),Dsigma,'UniformOutput',false);
    %     obsSys{i}.Dfault = Dfault{i};
    %     obsSys{i}.Efault = Efault{i};
    obsSys{i}.xhat0 = x0;
    obsSys{i}.ef0 = x0;
    obsSys{i}.x0aug = x0aug;
    obsSys{i}.dfbound = dfbounds(i);
    obsSys{i}.dmax = dfbounds(i);
    obsSys{i}.fmax = fbounds(i);
    obsSys{i}.fbound = fbounds(i);
    obsSys{i}.fsbound = fbounds;
    obsSys{i}.fmin = fboundsmin(i);
    obsSys{i}.SensorNumber = i;
end
[obsSys,Dfault, Efault] = dosmatrices(obsSys,Dsigma,p);
%%
obsFilter = obsSys{1};
obsFilter.Dfault = Dsigma;
obsFilter.Efault = Dsigma;
%%
obsControl = faultsys;
obsControl.Efault = Dsigma;
obsControl.xhat0 = x0;
obsControl.ef0 = x0;
obsControl.x0aug = x0aug;
obsControl.fsbound = norm(fbounds);
