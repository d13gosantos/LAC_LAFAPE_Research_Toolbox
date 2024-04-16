function [hJ,pJ,axJ] = plotsinglefault(out,jthVec,fType)
    %Plot the residuals in the presence of faults
    %sNum is the sensor number
    %fType = 'single' means system without remaining faults and
    %uncertainties, while 'full' is the opposite
    %out is a simulation object
    %jthVec is the vector of thresholds (cell).
    numF = length(jthVec);
    uncertFreq = out.simInfo.uncertFreq;
    
%    fType = out.simInfo.fType;
    sNum = out.simInfo.sNum;
    faultNumStr = '_faultNum_';
    downrate = 50;
    time = downsample(out.tout,downrate);
    J = downsample(out.J.Data(:,sNum),downrate);
    
    Jth = jthVec{sNum}*ones(length(time),1);
    JStr = ['$J(r^' num2str(sNum) ')$'];
    JthStr = ['$J_{th}^{' num2str(sNum) '}$'];
    sumDf = zeros(length(time),1);
    fsnorm = downsample(out.(['fsnorm' num2str(sNum)]).Data,downrate);
    for i = 1:numF
        sumDf  = sumDf + downsample(out.(['fsnorm' num2str(i)]).Data,downrate);
    end
    dfcolor = [0 0 1];
    dfault = sumDf - fsnorm;
    
    
    if strcmp(fType,'single')
        resString = 'Residual_only_faults_obsv';
        numPlots = 2;
        fStr = ['$||f^{' num2str(sNum) '}||$'];
        fnorm = fsnorm;
        fColor = 'red';
    else
        resString = ['Residual_remaining_and_uncertfreq_' num2str(uncertFreq) 'obsv'];
        numPlots = 2;
        fStr = ['$||d_{f}^{' num2str(sNum) '}||$'];
        fnorm = dfault;
        fColor = 'blue';
    end
    figJthName = [resString faultNumStr num2str(sNum)];
    
    
    [hJ,pJ,axJ] = plotscatter(time,J,...,
        figJthName,...
        'Time (s)',JStr,'on');
    axJFontSize = axJ.FontSize;
   % set(pJ, 'LineStyle', '-', 'LineWidth', 2, 'Color', [0 0 0]); %Plot the residual
    mkcolorarea(axJ,axJ.YLim(1),jthVec{sNum},'black');
    %subplot(numPlots,1,1,axJ);

    hold on;
    
    pJth = line(axJ,time,Jth,'LineStyle', '--', 'LineWidth', 2, 'Color',...
        [0 0 0],'DisplayName',JthStr);
    setylim(axJ,[J,Jth]);
    
    setlegend(pJth,JthStr,'on','northwest');
    
    hold off;
     
 
    yyaxis(axJ,'right');
    set(axJ.YAxis(2),'Color',fColor);
    
    pfault = line(axJ,time,fnorm,'LineStyle', '-.', 'LineWidth', 2, 'Color',...
        fColor,'DisplayName',fStr);
 
    set(axJ,'TickLabelInterpreter','latex',...,
        'LineWidth',1,'FontSize',axJFontSize);
    % y = [out.J.Data(:,sNum),Jth,fnorm];
    setlegend([pJth pfault],{JthStr fStr},'on','northwest');
    xlabel(axJ,'Time (s)');
    
    
end