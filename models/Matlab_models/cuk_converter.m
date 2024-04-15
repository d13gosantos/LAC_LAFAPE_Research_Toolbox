%Dynamics of Cuk Converter
%Parameters for the Cuk converter
% Small-Signal Modelling of the Cuk Converter (2018)
% CCM DCM 
% Vin=50 Vin=50 
% L1=10m L1=7u 
% L2=10m L2=16u
% C1=100u C1=100u 
% C2=100u C2=100u 
% R=5     R=12 
% D=0.3 D=0.42
% RL1=0.01 RL1=1m 
% RL2=0.01 RL2=1m 
% RC1=0.001 RC1=1m 
% RC2=0.001 RC2=1m 
%Rs=0  Rs=0
% Rd=0 Rd=0
% fs=20k fs=100k
% Vin = 50; %Vg
% LiL1 = 10e-3;
% LiL2 = 10e-3;
% CvC1 = 100e-6;
% CvC2 = 100e-6;
% Ro = 5; %R
% rL1 = 0.01; %Inductor resistance
% rL2 = 0.01;
% rC1 = 0.001;
% rC2 = 0.001;
% Diode = 0.3;
% Rs = 0;
% Rd = 0;
% 
%Original
Vin = 25; %Vg
LiL1 = 1e-3;
LiL2 = 2e-3;
CvC1 = 100e-6;
CvC2 = 2e-3;
%CvC2 = 10e-3;
Ro = 5; %R
rL1 = 0.1; %Inductor resistance
%rL1 = 0; %To make one subsystem unstable
rL2 = 0.2;

%rL2 = 0;
% rC1 = 0.01;
% rC2 = 0.02;
rC1 = 0.01;
rC2 = 0.02;
Diode = 0.3;
Rs = 0;% 0 
Rd = 0;

%Cuk converter with inductor resistance
%Can be improved to have
%Original
% A1 =[-rL1/LiL1 0 0 0;
%     0 0 -1/LiL2 -1/LiL2;
%     0 1/CvC1 0 0;
%     0 1/CvC2 0 -1/(Ro*CvC2)];
% A2 =[-rL1/LiL1 0 -1/(LiL1) 0;
%     0 0 0 -1/LiL2;
%     1/CvC1 0 0 0;
%     0 1/CvC2 0 -1/(Ro*CvC2)];
% b1 = [Vin/LiL1;0;0;0];
% b2 = b1;
% 
% C1 = [1 0 0 0; 0 1 0 0;0 0 0 1];
% C2  =C1;
%C1 = eye(4);
%C2 = eye(4)

A1 =[(-rL1-Rs)/LiL1,0,-Rs/LiL1,0;
    0,0,-1/CvC1,0;
    -Rs/LiL2,1/LiL2,-((Rs+rC1+rL2)+((Ro*rC2)/(Ro+rC2)))/LiL2,-(Ro/(Ro+rC2))/LiL2;
    0,0,(Ro/(Ro+rC2))/CvC2,-(1/(Ro+rC2))/CvC2];
A2 =[(-rC1-rL1-Rd)/LiL1,-1/LiL1,-Rd/LiL1,0;
    1/CvC1,0,0,0;
    -Rd/LiL2,0,-(Rd+rL2+(Ro*rC2)/(Ro+rC2))/LiL2,-(Ro/(Ro+rC2))/LiL2;
    0,0,(Ro/(Ro+rC2))/CvC2,-(1/(Ro+rC2))/CvC2];

b1 = [Vin/LiL1;0;0;0];
b2 = b1;

% C1 = [0 0 (rC2*Ro)/(rC2+Ro) (Ro)/(rC2+Ro);
%       1 0 0 0;
%       0 0 1 0];
C1 = [0 0 0 1;
      1 0 0 0;
      0 0 1 0];
C2  =C1;
%y = [Vo,iL1,iL2] - Voltage in the capacitor 1 and 2 is not read
%Vo is the output voltage

%Convex set of the converter matrices
Asigma = {A1,A2};
bsigma = {b1,b2};
Csigma = {C1,C2};

x0 = [0;0;0;0]; %Initial condition
%%
%Calculates equilibrium points given an operation point 
%kappa = 0.35;
kappa = 1;
Akappa = kappa*(A1 - A2) + A2;
bkappa = kappa*(b1-b2) + b2;%kappa = 0.5;
xe1 = -Akappa^(-1)*bkappa;
%%
syms kappa iLe1 vCe1 iLe2 vCe2;
Akappa = kappa*(A1 - A2) + A2;
bkappa = kappa*(b1-b2) + b2;
Xe = -Akappa^(-1)*bkappa;
% vCe2 = 16;
vCe2 = xe1(4);
xe = [iLe1;vCe1;iLe2;vCe2]; %Must give one value or 0 <kappa < 1
Xe_equation = xe == Xe; %Find an equilibrium point with given variable
sol_xe = solve(Xe_equation);
sol_xe =  double(sol_xe.kappa);
kappa_val = min(sol_xe(sol_xe <= 1 & sol_xe >= 0));


kappa = 0.5;
[xe,Akappa,bkappa] = equilibrium(Asigma,bsigma,kappa);
x0 = [0;0;0;0.3*xe(4)];
Cuk.Asigma = Asigma;
Cuk.bsigma = bsigma;
Cuk.Csigma = Csigma;
Cuk.ksigma = {A1*xe+b1,A2*xe+b2};
Cuk.Akappa = Akappa;
Cuk.bkappa = bkappa;
Cuk.kappa = kappa_val;
Cuk.kappaVec = [kappa,1-kappa];
Cuk.xe = xe;
Cuk.x0 = x0;
%%
%Control without robustness 
% Q1 = C1'*C1;
% [K1,Pcontrol] = switchedcontrol_LMI(Asigma,bsigma, xe,Q1) ;
% [K, Lcsigma, P] = obssascontrol_LMI(Asigma,bsigma,Csigma, xe);
% Cuk.K = K;
% Kxe = K'*xe;
% Cuk.Kxe = K'*xe;
% Cuk.Pcontrol = Pcontrol;
% Cuk.Lcsigma = Lcsigma;


%% Uncertainties

%Uncertainties

%Mbsigma = {diag([5000,0,0,0]),diag([0,0,0,0])};
% dRo = 0.15;%Percentage of variation of Ro
dRo = 0.10;
%Only uncertainty in the parameter Ro
ma33 = (1/LiL2)*((Ro*rC2)/(Ro+rC2)-(Ro*(1+dRo)*rC2)/(Ro*(1+dRo) + rC2));
ma34 = (Ro/(Ro+rC2)-(Ro*(1+dRo))/(Ro*(1+dRo)+rC2))/LiL2;
ma43 = -(Ro/(Ro+rC2))/CvC2 + (Ro*(1+dRo)/(Ro*(1+dRo)+rC2))/CvC2;
ma44 = (1/(Ro+rC2))/CvC2 -(1/(Ro*(1+dRo)+rC2))/CvC2;
DeltaA =[0 0 0 0;
            0 0 0 0;
            0 0 ma33 ma34;
            0 0 ma43 ma44];
[DeltaA_MX,DeltaA_NX] = fun_full_rank (DeltaA);
[Ma,Na] = fun_adjustment(DeltaA,DeltaA_MX,DeltaA_NX);
Masigma = {Ma,Ma};
Nasigma = {Na,Na};

dVin = 0.03; %Variations in the load

Delta_b1 = [Vin*dVin/LiL1 0 0 0]';
Delta_b2 = [Vin*dVin/LiL1 0 0 0]';
[Delta_b1_MX,Delta_b1_NX] = fun_full_rank (Delta_b1);
[Mb1,Nb1] = fun_adjustment(Delta_b1,Delta_b1_MX,Delta_b1_NX);
[Delta_b2_MX,Delta_b2_NX] = fun_full_rank (Delta_b2);
[Mb2,Nb2] = fun_adjustment(Delta_b2,Delta_b2_MX,Delta_b2_NX);

Mbsigma = {diag([1 0 0 0]),diag([1 0 0 0])}; %Disturbance matrix-small disturbance for LMI feasibility
%Mbsigma = {Mb1,Mb2};
Nbsigma = {Nb1,Nb2};
% Mb1 = [750,0,0,0]';
% Nb1 = [1]';
% Mbsigma = {Mb1,Mb1};
% Nbsigma = {Nb1,Nb1};

%Matrix C
mc12 = -(rC2*Ro)/(rC2+Ro) + (rC2*Ro*(1+dRo))/(rC2+Ro*(1+dRo));
mc13 = -(Ro)/(rC2+Ro)+(Ro*(1+dRo))/(rC2+Ro*(1+dRo));
DeltaC = [0 0 mc12 mc13;
      0 0 0 0;
      0 0 0 0];
[DeltaC_MX,DeltaC_NX] = fun_full_rank (DeltaC);
[Mc,Nc] = fun_adjustment(DeltaC,DeltaC_MX,DeltaC_NX);
Mcsigma = {Mc,Mc};
Ncsigma = {Nc,Nc}; 

% Akappauncert = Asigma{1,2} - kappa_val*(Asigma{1,1}+) + Masigma{1,1}*Nasigma{1,1} ;

uncertSys = Cuk;
uncertSys.Mbsigma = Mbsigma;
uncertSys.Nbsigma = Nbsigma;
uncertSys.Masigma = Masigma;
uncertSys.Nasigma = Nasigma;
uncertSys.Mcsigma = Mcsigma;
uncertSys.Ncsigma = Ncsigma;


