fc_tools.utils.cleaning()
N=30;
[bvp,info]=fc_vfemp1.examples.setBVPStationaryConvectionDiffusion2D01(N,2);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[u,SolveInfo]=bvp.solve('time',true); 
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(u));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  options=fc_tools.graphics.DisplayFigures('nfig',7);
  interpreter=@(x) fc_tools.graphics.interpreter(x);
  isOctave=fc_tools.comp.isOctave();

  Th=bvp.Th;
  figure(1)
  fc_siplt.plotmesh(Th,'inlegend',true)
  hold on,axis off,axis image;
  set(legend('show'),options.legend{:})
  fc_siplt.plotmesh(Th,'d',1,'Linewidth',2,'Color','k')

  figure(2)
  fc_siplt.plotmesh(Th,'Color',0.85*[1,1,1])
  hold on,axis off,axis image;
  fc_siplt.plotmesh(Th,'d',1,'Linewidth',2,'inlegend',true)
  set(legend('show'),options.legend{:})

  figure(3)
  fc_siplt.plot(Th,u)
  axis off;axis image,shading interp
  title(interpreter(sprintf('Numerical solution ( $n_q=%d$, $n_{me}=%d$ )',Th.nq,Th.get_nme())),options.interpreter{:},options.title{:});
  h=colorbar();
  set(get(h,'title'),'string',interpreter('$u$'),options.interpreter{:},options.title{:})
  set(h,options.colorbar{:})

  figure(4)
  fc_siplt.plot(Th,u)
  hold on,axis off,axis image
  fc_siplt.plotiso(Th,u,'isorange',0,'Color','w','Linewidth',1.5);
  shading interp
  title(interpreter(sprintf('Numerical solution ( $n_q=%d$, $n_{me}=%d$ )',Th.nq,Th.get_nme())),options.interpreter{:},options.title{:});
  h=colorbar();
  set(get(h,'title'),'string',interpreter('$u$'),options.interpreter{:},options.title{:})
  set(h,options.colorbar{:})

  figure(5)
  fc_siplt.plot(Th,u,'FaceAlpha',0.8);
  hold on,axis off,axis image
  if isOctave % FaceAlpha not implemented in Octave
    fc_siplt.plotiso(Th,u,'niso',20,'Linewidth',1.5,'color','w');
    set(colorbar(),options.colorbar{:})
  else
    [~,~,cax]=fc_siplt.plotiso(Th,u,'niso',20,'Linewidth',1.5,'isocolorbar',true,'format','%.3f');
    set(cax,options.colorbar{:})
  end
  shading interp
  title(interpreter(sprintf('Numerical solution ( $n_q=%d$, $n_{me}=%d$ )',Th.nq,Th.get_nme())),options.interpreter{:},options.title{:});

  figure(6)
  fc_siplt.plot(Th,u,'FaceColor','interp','FaceAlpha',0.8,'EdgeColor','none');
  hold on
  if isOctave
    fc_siplt.plotiso(Th,u,'niso',20,'Linewidth',1.5,'color','w');
    set(colorbar(),options.colorbar{:})
  else
    [~,~,cax]=fc_siplt.plotiso(Th,u,'niso',20,'Linewidth',1.5,'isocolorbar',true,'format','%.3f');
    set(cax,options.colorbar{:})
  end
  fc_siplt.plotiso(Th,u,'isorange',0,'Color','k','Linewidth',1.5);
  view(106,27)
  xlabel('x'),ylabel('y'),zlabel('z')
  set(gca,options.axes{:})

  figure(7)
  clf
  V=Th.eval(info.V);
  fc_siplt.plotquiver(Th,V,'colordata',u,'scale',0.005,'freq',1);
  hold on,axis image, axis off
  set(colorbar(),options.colorbar{:})
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',2)
  drawnow
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
