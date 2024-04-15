function obsOutput = simfaultobservers(obsSys,faultParams,odeParams)
    %UNTITLED4 Simulate all fault detection observers output.
    % The same fault is applied to all observers. If the simulation is
    % different faults for each observer, simfaultobserver() must be used. 
    %   Runs the simulation and gives the
    %results
    %Fault dynamics
    numObs = length(obsSys);
    f_dyn = cellfun(@(obsSys) fault_dyn(obsSys,faultParams),...
                    obsSys,'UniformOutput',false); %Return a function
    timeInt = odeParams.timeInt;
    x0 = obsSys{1}.x0aug;
    opts = odeParams.opts;
    obsOutput = cell(1,numObs);

    get_res = @get_observer_results;   
    %use the comand parpool
   for i = 1:numObs
        f_dyn_i = f_dyn{i};
        sol = ode45(@(t,x_aug) f_dyn_i(t, x_aug,obsSys{i}.Lsigma,obsSys{i}.Lcsigma),...,
                    timeInt,x0,opts);
        t = sol.x;
        x_aug = sol.y; %x_aug;
        obsOutput{i} = get_res(t,x_aug,obsSys{i},faultParams);  
    end

   

