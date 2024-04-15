function [pJ,axJ] = plotalarm(out,jthVec,fType,fhandle)
    %Plot the residuals in the presence of faults
    %in a pre-existent figure
    numF = length(jthVec);
    uncertFreq = out.simInfo.uncertFreq;
    
%    fType = out.simInfo.fType;
    sNum = out.simInfo.sNum;
    faultNumStr = '_faultNum_';
    downrate = 50;
    time =  downsample(out.tout,downrate);
    J = downsample(out.J.Data(:,sNum),downrate);
    Jth = jthVec{sNum}*ones(length(time),1);
    alarm = J>=Jth;
    %alarm = downsample(out.(['Alarm' num2str(sNum)]).Data,downrate);

    axJ  = axes('Parent',fhandle);
    setpaperaxes(axJ,'',['$a^{' num2str(sNum) '}(t)$']);
 
    hold(axJ,'on');
    %Test if y is a vector or matrix
 
    pJ = line(time,alarm,'LineWidth',1.5);
  
    % Set the remaining axes properties  
    
    xlim(axJ,[min(min(time)) max(max(time))]);
    
    setpaperfigsize(fhandle); %Set the figure size
    
    set(axJ,'LooseInset', max(get(axJ,'TightInset'), 0.02))
    box(axJ,'on');
    %setgrid(axhandle); %Set minor gridos
    hold(axJ,'off');
    set(pJ, 'LineStyle', ':', 'LineWidth', 2, 'Color', [0 0 0]); %Plot the residual

    hold on;
    
    setylim(axJ,alarm);
    
    %setlegend(pJth,JthStr,'on','northwest');
    
    hold off;
     
    %setlegend([pfault pdfault],{fStr,dfStr},'on');
       
    xlabel(axJ,'Time (s)');
    
    
end