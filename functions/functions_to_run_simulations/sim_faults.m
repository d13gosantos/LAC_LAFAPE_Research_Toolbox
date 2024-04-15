function [out,simInfo] = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f)
    %Simulate faults and return the respective vectors
    %single means only the respective fault while full means uncertainties
    %and faults
    out = sim(modelName);
    simInfo.uncertFreq = uncertFreq;
    simInfo.fType = fType;
    simInfo.sNum = sNum; %Number of the faulty sensor
    simInfo.f_s = f_s;
    simInfo.t_f = t_f;
    simInfo.uncerType = uncertType;
    time = out.tout;
    sumDf = zeros(length(time),1);
    numF = length(f_s);
    for i = 1:numF
        sumDf  = sumDf + out.(['fsnorm' num2str(i)]).Data;
    end
    dfault = sumDf - out.(['fsnorm' num2str(sNum)]).Data;
    simInfo.dfault = dfault;    
    out.SimulationMetadata.UserData = simInfo;
    out.simInfo = simInfo;
    
end