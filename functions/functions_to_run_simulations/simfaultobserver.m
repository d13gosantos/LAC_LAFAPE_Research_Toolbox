function obsOutput = simfaultobserver(obsSys,faultParams,odeParams)
    %UNTITLED4 Simulate one fault detection observer output.
    %   Runs the simulation and gives the
    %results
    %Fault dynamics
%    f_dyn = fault_dyn(obsSys,faultParams); %Return a function
    f_dyn = fault_dyn_uncertain(obsSys,faultParams); %Return a function
    timeInt = odeParams.timeInt;
    x0 = obsSys.x0aug;
    opts = odeParams.opts;
    sol = ode45(@(t,x_aug) f_dyn(t, x_aug,obsSys.Lsigma,obsSys.Lcsigma),...,
        timeInt,x0,opts);
    t = sol.x;
    x_aug = sol.y;
    
    obsOutput = get_observer_results(t,x_aug,obsSys,faultParams);
    
end

