RiL = 2 ;
LiL = 500e-06;
CvC = 170e-06;
Vin = 100;
Ro = 50;
A1 = [-RiL/LiL -1/LiL;1/CvC -1/(Ro*CvC)];
A2 = A1;
b1 = [Vin/LiL;0];
b2 = [0;0];
C1 = eye(2);
C2 = C1;
Asigma = {A1,A2};
bsigma = {b1,b2};
Csigma = {C1,C2};
x0 = [0;0];
%Calculates equilibrium points given equilibrium voltage
syms lambda iLe vCe;
Adelta = A1-A2;
bdelta = b1-b2;
Alambda = lambda*(Adelta) + A2;
blambda = lambda*(bdelta) + b2;
Xe = -Alambda^(-1)*blambda;
vCe = 50;
xe = [iLe;vCe]; %Must give one value or 0 <lambda < 1
Xe_equation = xe == Xe; %Find an equilibrium point with given variable
sol_xe = solve(Xe_equation);
lambda_val = min(double(sol_xe.lambda));
xe = -inv(subs(Alambda,lambda,lambda_val))*subs(blambda,lambda,lambda_val);
xe = double(xe);
xeFault = xe;

k1 = Asigma{1,1}*xe + bsigma{1,1};
k2 = Asigma{1,2}*xe + bsigma{1,2};
ksigma = {k1,k2};
kdelta = k1-k2;
buck.Asigma = Asigma;
buck.bsigma = bsigma;
buck.Csigma = Csigma;
buck.Adelta = Adelta;
buck.bdelta = bdelta;
buck.ksigma = ksigma;
buck.kdelta = kdelta;
buck.xe = xe;
buck.x0 = x0;
