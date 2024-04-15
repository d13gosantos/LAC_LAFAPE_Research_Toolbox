%% Plotando as respostas para o controle da MR CA
clear all
close all
clc
%%
%Carregando as variáveis como estrutura com tempo no workspace

saveVarsMat = load('w.mat');
w = saveVarsMat.w;
clear saveVarsMat;

saveVarsMat = load('E.mat');
E = saveVarsMat.E;
clear saveVarsMat;

saveVarsMat = load('Pcarga.mat');
Pcarga = saveVarsMat.Pcarga;
clear saveVarsMat;

saveVarsMat = load('P.mat');
P = saveVarsMat.P;
clear saveVarsMat;

saveVarsMat = load('Prede.mat');
Prede = saveVarsMat.Prede;
clear saveVarsMat;

saveVarsMat = load('Pref.mat');
Pref = saveVarsMat.Pref;
clear saveVarsMat;


saveVarsMat = load('Qcarga.mat');
Qcarga = saveVarsMat.Qcarga;
clear saveVarsMat;

saveVarsMat = load('Qrede.mat');
Qrede = saveVarsMat.Qrede;
clear saveVarsMat;

saveVarsMat = load('Q.mat');
Q = saveVarsMat.Q;
clear saveVarsMat;

saveVarsMat = load('Qref.mat');
Qref = saveVarsMat.Qref;
clear saveVarsMat;

saveVarsMat = load('Vcap.mat');
Vcap = saveVarsMat.Vcap;
clear saveVarsMat;

saveVarsMat = load('Vrede.mat');
Vrede = saveVarsMat.Vrede;
clear saveVarsMat;


%%
%Definindo as escalas de tempo e redução por fatores de escala

reduceDataFactor=500;  %Redução da densidade de pontos
tempo= downsample(w.time,reduceDataFactor);  %Escala de tempo


%Definindo as saídas

y1 = downsample(w.signals.values,reduceDataFactor)/(2*pi*60);
Eref_vd = 220*sqrt(2);
y2 = downsample(E.signals.values,reduceDataFactor)/Eref_vd;

y3 = downsample(P.signals.values,reduceDataFactor);
y4 = downsample(Prede.signals.values,reduceDataFactor);
y5 = downsample(Pcarga.signals.values,reduceDataFactor);

y6 = downsample(Q.signals.values,reduceDataFactor);
y7 = downsample(Qrede.signals.values,reduceDataFactor);
y8 = downsample(Qcarga.signals.values,reduceDataFactor);

y9 = downsample(Pref.signals.values,reduceDataFactor);
y10 = downsample(Qref.signals.values,reduceDataFactor);

y11 = downsample(Vcap.signals.values,reduceDataFactor);
y12 = downsample(Vrede.signals.values,reduceDataFactor);
%%
%Plotando w, E, P e Q

figure('Renderer', 'painters', 'Position', [10 10 800 600])
   
subplot(4,1,1)
plot(tempo,y1,'k','LineWidth',2)
grid on  
axis([0 36 0.9 1.1]) 
ax = gca;
ax.LineWidth=1.3;  
ax.GridColor = 'black';
ax.GridAlpha = 0.3;
ax.XColor = 'k';
ax.YColor = 'k';
xticks([0 4 8 12 16 20 24 28 32 36])
ylabel('\omega (pu)','FontSize',12,'Color','k')
%%
xBox = [0 4 4 0];
yBox = [0.9 0.9 1.1 1.1];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
hold on
xBox = [8 12 12 8];
yBox = [0.9 0.9 1.1 1.1];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
hold on
xBox = [16 20 20 16];
yBox = [0.9 0.9 1.1 1.1];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
hold on
xBox = [24 28 28 24];
yBox = [0.9 0.9 1.1 1.1];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
hold on
xBox = [32 36 36 32];
yBox = [0.9 0.9 1.1 1.1];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none');
%%


subplot(4,1,2)
plot(tempo,y3,'k','LineWidth',2)
hold on
plot(tempo,y9,'r','LineWidth',2)
hold on
grid on  
axis([0 36 -0.5 12000])
legend('Saída','Referência')
ax = gca;
ax.LineWidth=1.3;  
ax.GridColor = 'black';
ax.GridAlpha = 0.3;
ax.XColor = 'k';
ax.YColor = 'k'; 
xticks([0 4 8 12 16 20 24 28 32 36])
yticks([0 3000 6000 9000 12000])
ylabel('P (W)','FontSize',12,'Color','k')
xBox = [0 4 4 0];  
yBox = [0 0 12000 12000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [8 12 12 8];
yBox = [0 0 12000 12000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [16 20 20 16];
yBox = [0 0 12000 12000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [24 28 28 24];
yBox = [0 0 12000 12000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [32 36 36 32];
yBox = [0 0 12000 12000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');



subplot(4,1,3)
plot(tempo,y2,'k','LineWidth',2)
grid on 
axis([0 36 0.7 1.3])
ax = gca;
ax.LineWidth=1.3;  
ax.GridColor = 'black';
ax.GridAlpha = 0.3;
ax.XColor = 'k';
ax.YColor = 'k';
xticks([0 4 8 12 16 20 24 28 32 36])
ylabel('E (pu)','FontSize',12,'Color','k')
xBox = [0 4 4 0];  
yBox = [0.7 0.7 1.3 1.3];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [8 12 12 8];
yBox = [0.7 0.7 1.3 1.3];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [16 20 20 16];
yBox = [0.7 0.7 1.3 1.3];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [24 28 28 24];
yBox = [0.7 0.7 1.3 1.3];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [32 36 36 32];
yBox = [0.7 0.7 1.3 1.3];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');



subplot(4,1,4)  
plot(tempo,y6,'k','LineWidth',2)
hold on
plot(tempo,y10,'r','LineWidth',2)
grid on
axis([0 36 0 30000])
legend('Saída','Referência')
ax = gca;
ax.LineWidth=1.3;  
ax.GridColor = 'black';
ax.GridAlpha = 0.3;
ax.XColor = 'k';
ax.YColor = 'k';
xticks([0 4 8 12 16 20 24 28 32 36])
yticks([0 7500 15000 22500 30000])
xlabel('Tempo (s)','FontSize',12,'Color','k')
ylabel('Q (VAr)','FontSize',12,'Color','k')
xBox = [0 4 4 0];  
yBox = [0 0 30000 30000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [8 12 12 8];
yBox = [0 0 30000 30000];  
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [16 20 20 16];
yBox = [0 0 30000 30000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [24 28 28 24];
yBox = [0 0 30000 30000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
hold on
xBox = [32 36 36 32];
yBox = [0 0 30000 30000];
patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.1,'LineStyle','none', 'HandleVisibility','off');
