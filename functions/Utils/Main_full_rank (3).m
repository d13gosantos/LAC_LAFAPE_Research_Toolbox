
% Defina a matriz

%M = [3 6 13;2 4 9;1 2 3];

dRo = 0.05;%Percentage of variation of Ro
%Only uncertainty in the parameter Ro
m33 = (1/LiL2)*(Rpar(Ro,rC2)-Rpar(Ro*(1+dRo),rC2));
m34 = (Ro/(Ro+rC2)-(Ro*(1+dRo))/(Ro*(1+dRo)+rC2))/LiL2;
m43 = -(Ro/(Ro+rC2))/CvC2 + (Ro*(1+dRo)/(Ro*(1+dRo)+rC2))/CvC2;
m44 = (1/(Ro+rC2))/CvC2 -(1/(Ro*(1+dRo)+rC2))/CvC2;

M =[0 0 0 0;
    0 0 0 0;
    0 0 m33 m34;
    0 0 m43 m44];

[MX,NX] = fun_full_rank (M);

nLM = size(M,1);
nCM = size(M,2);
r=1; % seria o número de matrizes (modelos locais), não é o caso aqui

[Ma,Na] = fun_adjustment (nLM,nCM,MX,NX,nLM)
