fc_tools.utils.cleaning()
N=10;
options={'perm',@(A) colamd(A)};
[bvp,info]=fc_vfemp1.examples.setBVPCondenser2D01(N,2);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[U,SolveInfo]=bvp.solve('time',true,options{:});
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(U));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  Th=bvp.Th;
  options=fc_tools.graphics.DisplayFigures('nfig',4); % To present 'nicely' the 4 figures
  figure(1)
  fc_siplt.plotmesh(Th,'inlegend',true)
  axis equal
  set(legend(),options.legend{:})
  set(gca,options.axes{:})

  figure(2)
  fc_siplt.plotmesh(Th,'color',[0.8,0.8,0.8])
  hold on
  fc_siplt.plotmesh(Th,'d',1,'inlegend',true)
  axis equal
  set(legend(),options.legend{:})

  figure(3)
  fc_siplt.plot(Th,U)
  axis off,axis image
  set(colorbar(),options.colorbar{:});
  shading interp
  title('Condenser2D[01], P1-FEM solution',options.title{:})

  figure(4)
  fc_siplt.plotmesh(Th,'d',1,'color','k')
  hold on
  [~,~,cax]=fc_siplt.plotiso(Th,U,'niso',20,'isocolorbar',true,'format','%.3f');
  set(cax,options.colorbar{:});
  axis off,axis image
  title('Condenser2D[01], P1-FEM solution - isolines',options.title{:})
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
