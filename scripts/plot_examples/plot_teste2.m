clear all; close all; clc

T = load('rec2_001.mat');
tempo = T.rec2_001.X.Data-0.5;
y1 = T.rec2_001.Y(1).Data;
y2 = T.rec2_001.Y(2).Data; 
y3 = T.rec2_001.Y(3).Data;
y4 = T.rec2_001.Y(4).Data;
y5 = T.rec2_001.Y(5).Data;
y6 = T.rec2_001.Y(6).Data; 
y7 = T.rec2_001.Y(7).Data; 


%Filtrando os sinais
windowSize = 500; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

y1 = filter(b,a,y1); %Ciclo de trabalho
y2 = filter(b,a,y2); %Tensão do barramento
y3 = filter(b,a,y3); %Corrente no indutor
y4 = filter(b,a,y4);
y5 = filter(b,a,y5);
y6 = 60*filter(b,a,y6); %Velocidade MIT de tração (rpm)
y7 = 60*filter(b,a,y7); %Velocidade MIT de resistência (rpm)

LW = 2;
te1 = 10;
te2 = 27.2;
te3 = 35;
te4 = 41;  


figure('Renderer', 'painters', 'Position', [700 150 600 800])
[ha, pos] = tight_subplot(4,1,[.05 .1],[.07 .05],[.14 .08]);

axes(ha(1));
plot(tempo,y2,'k','LineWidth',LW)
hold on
line([0,48.6],[280 280],'Color','red','LineWidth',1.5)
hold on
line([te1,te1],[270 300],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 1
hold on
line([te2,te2],[270 300],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 2
hold on
line([te3,te3],[270 300],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 3
hold on
line([te4,te4],[270 300],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 4
axis([0 48 270 300])
grid on
grid minor
xticks([0 5 10 15 20 25 30 35 40 45])
ax = gca; ax.FontSize = 12;  
ax.MinorGridColor = [0 0 0];
ax.GridAlpha = 0.2;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0]; 
ylabel({'Tensão do';'barramento CC (V)'},'FontSize',14)
%legend('Valor medido','Referência','Location','northoutside','Orientation','horizontal')
lgnd = legend('Valor medido','Referência','FontSize',14,'Orientation','horizontal');
set(lgnd,'color','none', 'FontSize', 14);
legend boxoff;


axes(ha(2));
plot(tempo,y3,'k','LineWidth',LW)
hold on
line([te1,te1],[-1 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 1
hold on
line([te2,te2],[-1 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 2
hold on
line([te3,te3],[-1 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 3
hold on
line([te4,te4],[-1 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 4
axis([0 48 -1 2])
grid on
grid minor
xticks([0 5 10 15 20 25 30 35 40 45])
ax = gca; ax.FontSize = 12;  
ax.MinorGridColor = [0 0 0];
ax.GridAlpha = 0.2;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0]; 
ylabel({'Corrente';'no indutor (A)'},'FontSize',14)


axes(ha(3));
plot(tempo,y6/1000,'b','LineWidth',LW)
hold on
plot(tempo,y7/1000,'LineWidth',LW)
hold on
line([te1,te1],[0 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 1
hold on
line([te2,te2],[0 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 2
hold on
line([te3,te3],[0 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 3
hold on
line([te4,te4],[0 2],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 4
axis([0 48 0 2])
grid on
grid minor
xticks([0 5 10 15 20 25 30 35 40 45])
ax = gca; ax.FontSize = 12;  
ax.MinorGridColor = [0 0 0];
ax.GridAlpha = 0.2;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0]; 
%xlabel('Tempo (s)','FontSize',12)
ylabel({'Velocidade';'dos MITs (krpm)'},'FontSize',14)
% legend('MIT de tração','MIT de resistência','Location','northoutside','Orientation','horizontal')
lgnd = legend('MIT de tração','MIT de resistência','FontSize',14,'Orientation','horizontal');
set(lgnd,'color','none', 'FontSize', 14);
legend boxoff;

axes(ha(4));
plot(tempo,y1,'k','LineWidth',LW)
hold on
line([te1,te1],[0.7 0.9],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 1
hold on
line([te2,te2],[0.7 0.9],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 2
hold on
line([te3,te3],[0.7 0.9],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 3
hold on
line([te4,te4],[0.7 0.9],'Color','black','LineWidth',0.5,'LineStyle','-.') %Linha evento 4
axis([0 48 0.7 0.9])
grid on
grid minor
xticks([0 5 10 15 20 25 30 35 40 45])
ax = gca; ax.FontSize = 12;  
ax.MinorGridColor = [0 0 0];
ax.GridAlpha = 0.2;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0]; 
xlabel('Tempo (s)','FontSize',14)
ylabel('Ciclo de trabalho','FontSize',14)

set(ha(1:3),'XTickLabel',''); %set(ha([1,3]),'YTickLabel','');