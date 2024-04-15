clc;clear all
eta = 0.2;
tmax = 100;
t = 0:tmax;
tau = 0:tmax;
%*abs(sin(2*pi.*tau./60))
sinfunc = @(tau) 10.*abs(sin(2*pi.*tau./60));
fault = @(tau) log(100000*tau);
expfunc = @(t,tau) exp(-eta*(t-tau)).*fault(tau) ;%(10.*abs(sin(2*pi.*tau./60)));
supf = max(fault(tau));
%t = 1:100;
expf = @(t) exp(-eta*t);

for i = 1:length(t)
    intexp(i) = integral(@(tau) expfunc(t(i),tau), 0, t(i));
end

% intexp = @(t,tau) integral(@(tau) expfunc(tau), 0, t+1)
%eint = expf(t).*intexp;
eint = intexp;
plot(t, eint,t,supf*(1-expf(t))/eta)
% plot(tau, eint)
% expsum = cumtrapz(tau,expfunc(tau));
% plot(tau,expsum,tau,(1-expfunc(tau))/eta)
% plot(tau,sinfunc(tau))

%%
R2 =[10 -5 6 -3];
H2 = R2'*R2;
Rbar = sqrt(diag(H2))';
Rstar = Rbar;
[rdiv,idx] = max(Rbar);
if rdiv ~=0 
    for i = 1:length(Rbar)
        Rstar(1,i) = H(idx,i)/rdiv;
    end
end