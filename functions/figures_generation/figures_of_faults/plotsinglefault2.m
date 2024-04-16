function [pJ,axJ] = plotsinglefault2(out,jthVec,fType,fhandle)
    %Plot the residuals in the presence of faults
    %in a pre-existent figure
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
    
    %figJthName = [resString faultNumStr num2str(sNum)];
    
    axJ  = axes('Parent',fhandle);
    setpaperaxes(axJ,'',JStr);
%     axhandle = axes('Parent',fhandle,'TickLabelInterpreter','latex',...,
%         'LineWidth',1,'FontSize',10);
    axJFontSize = axJ.FontSize;
    hold(axJ,'on');
    %Test if y is a vector or matrix
 
    pJ = line(time,J,'LineWidth',1.5);

    
    % Set the remaining axes properties  
    
    xlim(axJ,[min(min(time)) max(max(time))]);
    
    setpaperfigsize(fhandle); %Set the figure size
    
    set(axJ,'LooseInset', max(get(axJ,'TightInset'), 0.02))
    box(axJ,'on');
    %setgrid(axhandle); %Set minor gridos
    hold(axJ,'off');
    set(pJ, 'LineStyle', '-', 'LineWidth', 2, 'Color', [0 0 0]); %Plot the residual
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
    
    xlabel(axJ,'Time (s)');
    
    
end