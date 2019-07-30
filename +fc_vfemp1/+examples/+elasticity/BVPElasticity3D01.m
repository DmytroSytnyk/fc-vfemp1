fc_tools.utils.cleaning()
% caoutchouc
E = 21e5; nu = 0.45; %nu = 0.28; 
N=10;scale=2000;

[bvp,info]=fc_vfemp1.examples.elasticity.setBVPElasticity3D01(N,2,'E',E,'nu',nu);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[U,SolveInfo]=bvp.solve('split',true,'time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',sum(cellfun(@(x) size(x,1),U)));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  Th=bvp.Th;
  
  figure(1)
  fc_siplt.plotmesh(Th,'d',2,'inlegend',true)
  axis image
  legend('show')

  figure(2)
  if fc_tools.comp.isOctave()
    fc_siplt.plotmesh(Th,'d',1,'Color','b','LineWidth',2)
  else
    fc_siplt.plotmesh(Th,'d',2,'FaceColor','b','FaceAlpha',0.5)
  end
  hold on
  axis image
  move=scale*[U{1}';U{2}';U{3}'];
  fc_siplt.plotmesh(Th,'Color','r','move',move)
  view(-16,9)
  title(sprintf('Displacement scale by %g',scale))
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end

