function [Vx,Vdot] = lyapunov_sminus(obsOutput,P)
    Vlyap = @(x) x'*P*x;
    Vx = arrayfun(@(i) Vlyap(obsOutput.ef(:,i)),1:size(obsOutput.ef,2),...,
        'UniformOutput',false);
    Vx = cell2mat(Vx);
    Vdot = diff(Vx);
end