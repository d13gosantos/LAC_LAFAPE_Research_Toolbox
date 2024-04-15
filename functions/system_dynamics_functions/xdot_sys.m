function xdot = xdot_sys(~,x, Asigma, bsigma, K, Kxe)
    %myFun - Description
    %
    % Syntax: xdot1 = xdot_sys1(t,x)
    %
    % Long description
    sigma = (K'*x-Kxe> 0)+1;
    xdot = Asigma{1,sigma}*x + bsigma{1,sigma};
end
