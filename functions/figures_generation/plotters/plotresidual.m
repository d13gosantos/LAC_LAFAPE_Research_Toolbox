function [hJ,pJ,axJ] = plotresidual(out,jthVec)
    %Plot the residuals in the presence of faults
    %sNum is the sensor number
    %fType = 'single' means system without remaining faults and
    %uncertainties, while 'full' is the opposite
    %out is a simulation object
    %jthVec is the vector of thresholds (cell).
    fType = out.simInfo.fType;
     numF = length(jthVec);
    uncertFreq = out.simInfo.uncertFreq;
    
%    fType = out.simInfo.fType;
    sNum = out.simInfo.sNum;
    faultNumStr = '_faultNum_';
    time = out.tout;
    Jth = jthVec{sNum}*ones(length(time),1);
    JStr = ['$J(r^' num2str(sNum) ')$'];
    JthStr = ['$J_{th}^{' num2str(sNum) '}$'];
    
    %Make the full plot with remaining faults and faults
    if strcmp(fType,'single')
        resString = 'Residual_only_faults_obsv';
        numPlots = 2;
        fStr = ['$||f^{' num2str(sNum) '}||$'];
        fColor = 'red';
    else
        resString = ['Residual_remaining_and_uncertfreq_' num2str(uncertFreq) 'obsv'];
        numPlots = 2;
        fStr = ['$||d_{f}^{' num2str(sNum) '}||$'];
       
        fColor = 'blue';
    end
    figJthName = [resString faultNumStr num2str(sNum)];
    if strcmp(fType,'single')
        [hJ,pJ,axJ] = plotsinglefault(out,jthVec,'single');
        setpaperfigsize(hJ,5);
    else
        [hJ,pJ,axJ] = plotsinglefault(out,jthVec,'single');
        axJ.XLabel.String = '';
        [~,axJ2] = plotsinglefault2(out,jthVec,'full',hJ); %df
        axJ2.XLabel.String = '';
        [~,axJ3] = plotalarm(out,jthVec,'full',hJ); %alarmFunction
        hJ.Name = figJthName;
        subplot(3,1,1,axJ);
        subplot(3,1,2,axJ2);
        subplot(3,1,3,axJ3);
        setpaperfigsize(hJ,8);
          axJFontSize = axJ.FontSize;
          set(axJ2,'FontSize',axJFontSize);
          set(axJ3,'FontSize',axJFontSize);
        %faultNumStr = '_noFaultNum_';
    end
    
    
    
    %figJthName = [resString faultNumStr num2str(sNum)];
    
    
end