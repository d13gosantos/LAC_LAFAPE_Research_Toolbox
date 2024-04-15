function setgrid(axhandle)
    grid on
    axhandle.GridColor = [0 0 0]; %Cor do grid maior: [0 0 0] para cor preta
    axhandle.GridAlpha = 0.2; %Espessura do grid maior
    grid minor %Ativa os grids menores entre o grid maior
    axhandle.MinorGridColor = [0 0 0]; %Cor do grid menor: [0 0 0] para cor preta
    axhandle.XColor = [0 0 0]; %Cor no eixo x: [0 0 0] para cor preta
    axhandle.YColor = [0 0 0]; %Cor no eixo y: [0 0 0] para cor preta   
end
