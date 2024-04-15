function J = residual_evaluation(t,rf,Ts)
    %len_rf = length(rf);
    %Returns a cell array of all residuals
    len_t = length(t);
    len_Window = ceil(len_t*(Ts/max(t))); %Turns integer
    Jfunc = dsp.MovingRMS(len_Window);
    J =  Jfunc(rf);
    Jfunc.release();
end