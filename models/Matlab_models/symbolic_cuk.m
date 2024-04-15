syms V_in L_iL1 L_iL2 C_vC1 C_vC2 R_o R_LiL1
%Cuk converter with inductor resistance
%Can be improved to have
A1sym =[-R_LiL1/L_iL1 0 0 0;
    0 0 -1/L_iL2 -1/L_iL2;
    0 1/C_vC1 0 0;
    0 1/C_vC1 0 -1/(R_o*C_vC1)];
A2sym =[-R_LiL1/L_iL1 0 -1/(L_iL1) 0;
    0 0 0 -1/L_iL2;
    1/C_vC1 0 0 0;
    0 1/C_vC1 0 -1/(R_o*C_vC1)];
b1sym = [V_in/L_iL1;0;0;0];
b2sym = b1sym;

%Calculates equilibrium points given equilibrium voltage
syms sigmasym iLe1 iLe2 vCe1 vCe2;
Asigmasym = simplify((2-sigmasym)*(A1sym - A2sym) + A2sym);
bsigmasym = simplify((2-sigmasym)*(b1sym-b2sym) + b2sym);
AsigmaLatex = matrix2latex(Asigmasym)
bsigmaLatex = matrix2latex(bsigmasym)% Xe = -Alambda^(-1)*blambda;
% %xe = [iLe1;iLe2;vCe1;vCe2];
% vCe2 = -16;
% xe = [iLe1;iLe2;vCe1;vCe2]; %Must give one value or 0 <lambda < 1
% 
% Xe_equation = xe == Xe; %Find an equilibrium point with given variable
% sol_xe = solve(Xe_equation);
% lambda_val = min(double(sol_xe.lambda));
% xe = -inv(subs(Alambda,lambda,lambda_val))*subs(blambda,lambda,lambda_val);
% xe = double(xe);
% xeFault = xe;
