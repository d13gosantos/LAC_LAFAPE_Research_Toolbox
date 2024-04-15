At = [-10,0;0,-20]; Lt = [2,0;0,1]; Ct=eye(2); Dt = eye(2);
Ao = (At-Lt*Ct);Rt = eye(2); fmax = [3;2];
%edot1 = Ao*e1 -Lt*Dt*f-%f is the input
%rdot1 = eye(2)*(Ct*(e) + Dt*f)
t0 = 0:0.01:0.15;
tf = 0.16:0.01:100;
t = [t0 tf];
[f0,t1] = meshgrid([0;0],t0);
[f1,t2] = meshgrid(fmax,tf);
f = [f0;f1];f = meshgrid(fmax,t);
efsys = ss(Ao,-Lt*Dt,Rt*Ct,Rt*Dt);
[y,T,x] = lsim(efsys,f,t);
