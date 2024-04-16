function [hJ,pJ,axJ] = plotresidual2(out,jthVec)
    %Plot the residuals in the presence of faults
    %sNum is the sensor number
    %fType = 'single' means system without remaining faults and
    %uncertainties, while 'full' is the opposite
    %out is a simulation object
    %jthVec is the vector of thresholds (cell).
    numF = length(jthVec);
    uncertFreq = out.simInfo.uncertFreq;
    fType = out.simInfo.fType;
    sNum = out.simInfo.sNum;
    faultNumStr = '_faultNum_';
    if strcmp(fType,'single')
        resString = 'Residual_only_faults_obsv';
        numPlots = 2;
    else
        resString = ['Residual_remaining_and_uncertfreq_' num2str(uncertFreq) 'obsv'];
        numPlots = 2;
        %faultNumStr = '_noFaultNum_';
    end
    
    
    
    time = out.tout;
    Jth = jthVec{sNum}*ones(length(time),1);
    JStr = ['$J(r^' num2str(sNum) ')$'];
    JthStr = ['$J_{th}^{' num2str(sNum) '}$'];
    fStr = ['$||f^{' num2str(sNum) '}||$'];
    dfStr = ['$||d_{f}^{' num2str(sNum) '}||$'];
    
    figJthName = [resString faultNumStr num2str(sNum)];
    
    [hJ,pJ,axJ] = plotfigure(time,out.J.Data(:,sNum),...,
        figJthName,...
        '',JStr,'on');
    
    set(pJ, 'LineStyle', '-', 'LineWidth', 2, 'Color', [0 0 0]); %Plot the residual
    mkcolorarea(axJ,axJ.YLim(1),jthVec{sNum},'black');
    subplot(numPlots,1,1,axJ);
    hold on;
    
    pJth = line(axJ,time,Jth,'LineStyle', '--', 'LineWidth', 2, 'Color',...
        [0 0 0],'DisplayName',JthStr);
    setylim(axJ,[out.J.Data(:,sNum),Jth]);
        
    setlegend(pJth,JthStr,'on');
    
    hold off;
    
    axfault = axes('Parent',hJ);
    axfault = setpaperaxes(axfault,'','');
    
    subplot(numPlots,1,2,axfault);
    fnorm = out.(['fsnorm' num2str(sNum)]).Data;
    pfault = line(axfault,time,fnorm,'LineStyle', '-.', 'LineWidth', 2, 'Color',...
        [1 0 0],'DisplayName',fStr);
    set(axfault,'TickLabelInterpreter','latex',...,
        'LineWidth',1,'FontSize',10);
    % y = [out.J.Data(:,sNum),Jth,fnorm];
    if strcmp(fType,'single')
        xlabel(axfault,'Time (s)');
        ylabel(axfault,fStr);
        %setlegend([pJth pfault],{JthStr,fStr},'on');
    else
        sumDf = zeros(length(time),1);
        for i = 1:numF
            sumDf  = sumDf + out.(['fsnorm' num2str(i)]).Data;
        end
        dfcolor = [0 0 1];
        dfault = sumDf - out.(['fsnorm' num2str(sNum)]).Data;
        
        %dfault = sum(out.(setdiff(1:end, 12))
        %dfault = out.fsnorm.Data - out.(['fsnorm' num2str(sNum)]).Data;
        yyaxis(axfault,'right');
        %axdf = axes('Parent',hJ);
        
        %%axdf = setpaperaxes(hJ,'Time (s)',dfStr);
        %axdf = subplot(numPlots,1,numPlots);
        
        % axdf = setpaperaxes(axdf,'Time (s)',dfStr);
        pdfault = line(axfault,time,dfault,'LineStyle', ':', 'LineWidth', 2, 'Color',...
            dfcolor,'DisplayName',dfStr);
        set(axfault.YAxis(2),'Color',dfcolor);
        set(axfault.YAxis(1),'Color','red');
        %setlegend([pfault pdfault],{fStr,dfStr},'on');
        setylim(axfault,dfault);
        xlabel(axfault,'Time (s)');
        axfault.YLabel.String = '';
        %         setylim(axJ,[out.J.Data(:,sNum),Jth,dfault]);
    end
    
    
end