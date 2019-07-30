fc_tools.utils.cleaning()

% caoutchouc
E = 21e5; nu = 0.45; %nu = 0.28; 
N=10;scale=50;
[bvp,info]=fc_vfemp1.examples.elasticity.setBVPElasticity2D01(N,1,'E',E,'nu',nu);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[U,SolveInfo]=bvp.solve('split',true,'time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',sum(cellfun(@(x) size(x,1),U)));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  Th=bvp.Th;
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  figure(1)
  fc_siplt.plotmesh(Th,'color',0.85*[1,1,1])
  hold on,axis image,axis off
  fc_siplt.plotmesh(Th,'d',1,'LineWidth',1.5,'inlegend',true)
  legend('show')
  figure(2)
  fc_siplt.plotmesh(Th,'move',scale*[U{1}';U{2}'])
  title(sprintf('Displacement scale by %g',scale))
  axis image
  fc_tools.graphics.DisplayFigures()
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end

