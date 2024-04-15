function obsOut = sim_mult_faults(obsSys,faultParams,odeParams)
    %%This function is responsible to simulate all the faults. The
    %%objective is to comprove that high gains in the remaining faults
    %%vector does not implies in false alarms. In addition, small faults
    %%can be detetected.
    fParam = faultParams;
    odeP = odeParams;
    fParam.tfault = faultParams.initialTf;
    odeP.timeInt = [0 faultParams.initialTf+faultParams.minFduration]; 
    p = length(obsSys); %Number of observers 
    %Parameters for simulation. The same for every sensor
    obsOut = cell(1,p); 
    for i = 1:p
        fParam.sensors = i;     
        fParam.theta(i) = faultParams.minTheta(i);
        obsOut{i} = simfaultobserver(obsSys{i},fParam,odeP);
    end

end