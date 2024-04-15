function test(A1,A2,b1,b2,tmax,x0,opts)
    xdotf1  =  @(t,x) A1*x+b1;
    xdotf2  =  @(t,x) A2*x+b2;
    tend = tmax;
    x = x0;
    if K*(x-xe)<= 0
        % xdot = Asigma{1}*x + bsigma{1};
        [t,x] = ode45(@xdotf1,[tstart tend],x0,opts)
        x0 = x;
        tstart = tend
    else
        [t,x] = ode45(@xdotf1,[0 tmax],x0,opts)
        x0 = x;
        %sigma = 2;
        % xdot = Asigma{2}*x + bsigma{2};
    end
end