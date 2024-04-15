function obsOutput = get_observer_results(t,x_aug,obsSys,faultParams)
    
    Csigma= obsSys.Csigma;
    Dsigma = obsSys.Dsigma;
    Kxe = obsSys.Kxe;
    xe = obsSys.xe;
    K = obsSys.K;
    x0aug = obsSys.x0aug;
    P = obsSys.lmiMat.P;
    Rsigma = obsSys.Rsigma;
    theta0 = faultParams.theta0;
    theta = faultParams.theta;
    tfault = faultParams.tfault;
    sensors = faultParams.sensors;
    p = size(Csigma{1,1},1);
    n = length(xe);
    len_t = length(t);
    sigma = ones(1,len_t);
    y = zeros(p,len_t);
    f = zeros(p,len_t);
    df = zeros(p-1,len_t);
    yhat = zeros(p,len_t);
    yhat1 = zeros(p,len_t);
    rf = zeros(size(Rsigma,1),len_t);
    sensorNumber= obsSys.SensorNumber;
    x =  x_aug(1:n,:);
    xhat = x_aug(n+1:2*n,:);
    xhat1 = x_aug(2*n+1:3*n,:);
    thetaf = theta0;
    ef = x-xhat;
    ef1 = x - xhat1;
    V = zeros(1,len_t);
    
    for j = 1:len_t
        sigma(j)= ((K'*x(:,j)-Kxe)> 0)+1;
        thetaf(sensors(t(j) >= tfault)) = theta(sensors(t(j) >= tfault));
       % f(:,j) = diag(thetaf)*(Csigma{1,sigma(j)}*x(:,j))- Csigma{1,sigma(j)}*x(:,j);
        thetaf(sensors(t(j) >= tfault)) = theta(sensors(t(j) >= tfault));
        f(:,j) = thetaf;%diag(t>=tfault)*theta; %Offset faults
        
        %f(:,j) = theta(sensors(t(j) >= tfault)); %diag(t(j)>=tfault)*theta;
        y(:,j) = Csigma{1,sigma(j)}*x(:,j)+ Dsigma{1,sigma(j)}*f(:,j);
        yhat(:,j) = Csigma{1,sigma(j)}*xhat(:,j);
        yhat1(:,j) = Csigma{1,sigma(j)}*xhat1(:,j);
        rf(:,j) = Rsigma{1,sigma(j)}*(y(:,j) - yhat(:,j));
        V(j) = ef(:,j)'*P*ef(:,j);
    end  
    
    df = setdiff(f,f(sensorNumber,:),'rows');% remaing faults signal
    
    windowSize = 50;
    bf = (1/windowSize)*ones(1,windowSize);
    Vdot = filter(bf,1,diff([0 V]));    
    xdot_aug = filter(bf,1,diff([x0aug x_aug],1,2));
    xdot =  xdot_aug(1:n,:);
    xhatdot = xdot_aug(n+1:2*n,:);
    efdot = xdot - xhatdot;
    
    windowSize = 25; %It can change if the simulation is improved
    bf = (1/windowSize)*ones(1,windowSize);
    norm_ef = filter(bf,1,get_norm(ef));
    norm_f = filter(bf,1,get_norm(f(sensorNumber,:)));
    norm_df = filter(bf,1,get_norm(df));
    norm_rf = filter(bf,1,get_norm(rf));

    obsOutput.t = t;
    obsOutput.xaug = x_aug;
    obsOutput.x = x;
    obsOutput.xhat = xhat;
    obsOutput.xhat1 = xhat1;
    obsOutput.xdot = xdot;
    obsOutput.xhatdot = xhatdot;
    obsOutput.ef = ef;
    obsOutput.ef1 = ef1;
    obsOutput.efdot = efdot;
    obsOutput.norm_ef = norm_ef;
    obsOutput.norm_f = norm_f;
    obsOutput.norm_df = norm_df;
    obsOutput.y = y;
    obsOutput.yhat = yhat;
    obsOutput.yhat1 = yhat1;
    obsOutput.rf = rf;
    obsOutput.J = norm_rf;
    obsOutput.f = f;
    obsOutput.V = V;
    obsOutput.norm_rf = norm_rf;
    obsOutput.Vdot = Vdot;
    obsOutput.sigma = sigma;
      
    function normVec = get_norm(signal)
        normVec = arrayfun(@(i) norm(signal(:,i),'inf'),1:len_t,...
                            'UniformOutput',false);
        normVec = [normVec{:}];
    end
    
end
