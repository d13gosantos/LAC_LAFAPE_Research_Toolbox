% This function adjust the order of matrices obtained by the full rank factorization
function [MX,NX] = fun_adjustment (M,MX,NX)

% Maximum rank of MX
    [nLX,nCX]= size(M);
     nLM = nLX;
     Vaux = rank(MX); 

Maxrank=nLM;

% Complete the columns of matrices MX and the rows of matrices NX with
% zeros if it is needed 
        maux=Maxrank-size(MX,2);
            if  isempty(MX)
                MX = zeros(nLX,Maxrank);
            elseif maux~=0
                MX =[MX, zeros(size(MX,1),maux)];
            end
            if  isempty(NX)
                NX = zeros(Maxrank,nCX);
            elseif maux~=0
                NX=[NX; zeros(maux,size(NX,2))];
            end
end