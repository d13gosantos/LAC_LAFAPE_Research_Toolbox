%Fault detecition and Isolation in a boost DC-DC converter
%Main
clear;clc;close all;

%Parameters for the boost converter
LiL =  5e-3; %1mH
CvC = 0.00285;%1 mF
Vin = 190;%25 V;
Ro = 100;%10? ;
R = 0.082;%0.1?.
ve = 380;

%Boost model
A1 =  [-R/LiL 0;0 -1/(Ro*CvC)];
A2 =  [-R/LiL -1/LiL;1/CvC -1/(Ro*CvC)];
b1 = [Vin/LiL;0];
b2 = b1;

%Calculates equilibrium points given equilibrium voltage

% delta_ie = (-Vin/R)^2 - (4*ve^2)/(R*Ro);
% ie = ((Vin/R) - sqrt(delta_ie))/2;
% xe = [ie;ve];
x0 = [0;0];
xhat0 =x0;
ef0 = x0;
n = size(A1,2);

C1 =  eye(2);
C2 = C1;
p = size(C1,2);
%Convex set
Asigma = {A1,A2};
bsigma = {b1,b2};
Csigma = {C1,C2};

syms lambda iLe vCe; 
Alambda = lambda*(A1 - A2) + A2;
blambda = lambda*(b1-b2) + b2;
Xe = -Alambda^(-1)*blambda;
vCe = 380;
xe = [iLe;vCe]; 
Xe_equation = xe == Xe; %Find an equilibrium point with given variable
sol_xe = solve(Xe_equation);
iLe = min(double(sol_xe.iLe));
lambda = min(double(sol_xe.lambda));
xe = double([iLe;vCe]);
xeFault = xe;
