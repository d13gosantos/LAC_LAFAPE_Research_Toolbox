function resizeFcn(src,event,hAxes,hSubAxes)

  figurePosition = get(get(hAxes,'Parent'),'Position');
  axesPosition = get(hAxes,'Position').*figurePosition([3 4 3 4]);
  width = axesPosition(3);
  height = axesPosition(4);
  minExtent = min(width,height);
  newPosition = [axesPosition(1)+(width-minExtent)/2+0.8*minExtent ...
                 axesPosition(2)+(height-minExtent)/2+0.05*minExtent ...
                 0.15*minExtent ...
                 0.15*minExtent];
  set(hSubAxes,'Units','pixels','Position',newPosition);

end