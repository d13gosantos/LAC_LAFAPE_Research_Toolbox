%Simulate faults
%%
%Print the results
close all;
modelName = 'cukModelStateSpaceWithcontrol';
%The fault k means that all sensors has faults except k
uncertType = 2;
uncertFreq = 10; %100ms%
%simObj{simType,sensorFault} - simType -  1: full except one, 2-single fault
%3: all faults 4 - only uncertainties 5 - none, sensorFault p+1:allsensors

sNum = 1;
t_f = [.2,.1,.1]; %Time of fault occurrence for each fault;
f_s = [fboundsmin(1),fbounds(2),fbounds(3)];
fType = 'full';
simObj{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);

sNum = 2;
t_f = [.1,.2,.1]; %Time of fault occurrence for each fault;
f_s = [fbounds(1),fboundsmin(2),fbounds(3)];
fType = 'full';
simObj{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);

sNum = 3;
t_f = [.1,.1,.2]; %Time of fault occurrence for each fault;
f_s = [fbounds(1),fbounds(2),fboundsmin(3)];
fType = 'full';
simObj{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);

%%
sNum = 1;
uncertType = 0;

t_f = [.2,.1,.1]; %Time of fault occurrence for each fault;
f_s = [fboundsmin(1),0,0];
fType = 'single';
simObj{2,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);
sNum = 2;
t_f = [.1,.2,.1]; %Time of fault occurrence for each fault;
f_s = [0,fboundsmin(2),0];
fType = 'single';
simObj{2,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);
sNum = 3;
t_f = [.1,.1,.2]; %Time of fault occurrence for each fault;
f_s = [0,0,fboundsmin(3)];
fType = 'single';
simObj{2,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);


% %%UncertFreq2
% %%
% uncertFreq = 100; %10ms
% uncertType = 2;
% sNum = 1;
% t_f = [.2,.1,.1]; %Time of fault occurrence for each fault;
% f_s = [fboundsmin(1),fbounds(2),fbounds(3)];
% fType = 'full';
% simObj2{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);
% %%
% sNum = 2;
% t_f = [.1,.2,.1]; %Time of fault occurrence for each fault;
% f_s = [fbounds(1),fboundsmin(2),fbounds(3)];
% fType = 'full';
% simObj2{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);
% %%
% sNum = 3;
% t_f = [.1,.1,.2]; %Time of fault occurrence for each fault;
% f_s = [fbounds(1),fbounds(2),fboundsmin(3)];
% fType = 'full';
% simObj2{1,sNum} = sim_faults(modelName,sNum,uncertFreq,fType,uncertType,f_s,t_f);

