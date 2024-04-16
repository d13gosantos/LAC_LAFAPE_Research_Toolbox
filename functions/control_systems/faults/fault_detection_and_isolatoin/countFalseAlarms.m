function [fpa,fna] = countFalseAlarms(out,sNum,jthVec)
    %Count False Alarms
    time = out.tout;
    J = out.J.Data(:,sNum);
    Jth = jthVec{sNum}*ones(length(time),1);
    alarms = J>=Jth;
    fsnorm = out.(['fsnorm' num2str(sNum)]).Data;
    tf = time(find(fsnorm,1,'first'));
    tfidx = find(out.tout>=tf);
    %Count the number of positive and negative alarms before tf
    Na1_fpa = nnz(alarms(1:tfidx(1)-1));
    Na0_fpa = nnz(~alarms(1:tfidx(1)-1));
    fpa = Na1_fpa/(Na1_fpa+Na0_fpa);
    Na1_fna = nnz(alarms(tfidx(1):end));
    Na0_fna = nnz(~alarms(tfidx(1):end));
    fna = Na0_fna/(Na0_fna+Na1_fna);
end