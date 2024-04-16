% clear all; 
close all; clc

%Preparando curvas para plotar
t = -10:0.01:10;
y = sin(t);
  
%Plotando a figura 
fig = figure;
LW = 2; %Largura da linha
subplot(3,1,1)
plot(t,y,'k','LineWidth',LW)
axis([-10 10 -1 1])
hx = xlabel('Time (s)'); %Label do eixo x
hy = ylabel('i_{L} (A)'); %Label do eixo y
hl = legend('Signal 1','Location','northoutside','Orientation','horizontal'); %Cria a legenda
ax = gca;  
grid on %Ativa o grid maior
ax.GridColor = [0 0 0]; %Cor do grid maior: [0 0 0] para cor preta
ax.GridAlpha = 0.2; %Espessura do grid maior
grid minor %Ativa os grids menores entre o grid maior
ax.MinorGridColor = [0 0 0]; %Cor do grid menor: [0 0 0] para cor preta
ax.XColor = [0 0 0]; %Cor no eixo x: [0 0 0] para cor preta
ax.YColor = [0 0 0]; %Cor no eixo y: [0 0 0] para cor preta
ax.TickLabelInterpreter = 'latex';
set(fig,'Units','Inches'); %Definindo unidade padrão
hx.FontName = 'Times New Roman'; %Fonte label eixo x
hx.FontSize = 10; %Tamanho da fonte do label do eixo x
hx.Interpreter = 'tex'; %Interpreter de latex do label do eixo x
hy.FontName = 'Times New Roman'; %Fonte label eixo y
hy.FontSize = 10; %Tamanho da fonte do label do eixo y
hy.Interpreter = 'tex'; %Interpreter de latex do label do eixo y
hl.FontName = 'Times New Roman'; %Fonte legenda
hl.FontSize = 10; %Tamanho da fonte da legenda
hl.Interpreter = 'tex'; %Interpreter de latex da legenda



fig.Units = 'centimeters';
fig.Position(3) = 8.89; %Largura de uma coluna do artigo
fig.Position(4) = 10; %Altura da figura
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';





