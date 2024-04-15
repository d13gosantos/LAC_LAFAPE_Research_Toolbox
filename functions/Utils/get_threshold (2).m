function [thVec,fIdxVec,obsOut] = get_threshold(obsSys,fParam,odeParams)
    %%This function is responsible to simulate the extreme faults scenario
    %%and determine The thresholds for each sensor based on the worst case

    faultParams = fParam;
    thetaMax = faultParams.maxTheta; %maxTheta = 
    p = length(obsSys); %Number of observers 
    %Parameters for simulation. The same for every sensor
    %thetaMax = repmat(maxTheta,1,p);
   % lossTheta = zeros(1,p);    
    allsensors  = p:-1:1; %vector of sensors
    sensorsComb = nchoosek(allsensors,p-1); %Return all the possible combinations
    thVec = zeros(1,p);
    fIdxVec = cell(1,p);
    obsOut = cell(1,p);
    %obsOut = cell(p,3);
    %Runs the threshold of a combination of p-1 sensors (remaining faults) 
    for i = 1:p
        faultParams.sensors = sort(sensorsComb(i,:));
        faultParams.theta = thetaMax;
        obsOut{i} = simfaultobserver(obsSys{i},faultParams,odeParams);
        threshold = obsOut{i}.J;
        [thVec(i),fIdxVec{i}] = max(threshold);
    end


%     for i = 1:p
%         faultParams.sensors = sort(sensorsComb(i,:)); 
%         faultParams.theta = thetaMax;
%         %off_func = @(x,t) offsetfault(x,t,tfault,sensors,alpha,Csigma);
%         [sgext_thresh,obsOut{1,p}] = runfaults(faultParams,i);
%         faultParams.theta = lossTheta;
%         [loss_thresh,obsOut{2,p}] = runfaults(faultParams,i);
%         %Simulation with normal theta 
%         faultParams.theta = fParam.theta;
%         [sg_thresh,obsOut{3,p}] = runfaults(faultParams,i);
%        % off_thresh = runfaults(off_func,i);
%         %Returns the maximum threshold and the type of fault 
%         [thVec{i},fIdxVec{i}] = max([sgext_thresh,loss_thresh sg_thresh]);      
%     end
%     
%     function [threshMax,obsOut] = runfaults(faultParams,i)
%         %Sensor gain, offsset or loss sensor
%         %Run the dynamics of all the observers
%         obsOut = simfaultobsevers(obsSys,faultParams,odeParams);
%         threshold = obsOut{i}.J;
%         threshMax = max(threshold);
%     end
end