close all
tpause=5; 

Demos={'BVPPoisson2D_ex01','BVPPoisson2D_ex02','BVPPoisson2D_ex03', ...
       'BVPPoisson3D_ex01'};
nbDemos=length(Demos);
fprintf('*************************\n')
fprintf('*   POISSON BVP DEMOS   *\n')
fprintf('*************************\n')

for i=1:nbDemos
  fprintf('\n**** POISSON BVP DEMO %2d/%d ****\n',i,nbDemos);
  eval(sprintf('fc_vfemp1.examples.Poisson.%s',Demos{i}));
  fc_tools.graphics.DisplayFigures();drawnow
  fprintf('\n waiting %d(s)...',tpause);pause(tpause);fprintf('\n\n');
  close all
end
