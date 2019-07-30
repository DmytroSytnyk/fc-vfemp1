fc_tools.utils.cleaning()
N=80;
[bvp,info]=fc_vfemp1.examples.setBVPElectrostatic2D01(N,2);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[phi,SolveInfo]=bvp.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(phi));
fc_vfemp1.examples.print_info(SolveInfo)

fprintf('*** Computing the electric field E\n')
Th=bvp.Th;
tstart=tic();
Lop=Loperator(2,2,[],[],{-1,0},[]);
Ex=Lop.apply(Th,phi); 
Lop=Loperator(2,2,[],[],{0,-1},[]);
Ey=Lop.apply(Th,phi); 
E=[Ex,Ey];
ENorm=sqrt(Ex.^2+Ey.^2);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  options=fc_tools.graphics.DisplayFigures('nfig',7);
  interpreter=@(x) fc_tools.graphics.interpreter(x);

  figure(1)
  fc_siplt.plotmesh(Th,'inlegend',true)
  set(legend(),options.legend{:})
  axis image
  set(gca,options.axes{:})

  figure(2)
  fc_siplt.plotmesh(Th,'color',[0.8,0.8,0.8])
  fc_siplt.plotmesh(Th,'d',1,'LineWidth',1.5,'inlegend',true)
  set(legend(),options.legend{:})
  axis image
  set(gca,options.axes{:})

  figure(3)
  fc_siplt.plotmesh(Th,'d',1,'color',[0,0,0])
  hold on
  fc_siplt.plot(Th,phi,'EdgeColor','None')
  axis image;axis off;
  set(colorbar(),options.colorbar{:})
  fc_siplt.plotiso(Th,phi,'niso',20,'color','w','LineWidth',1) 
  fc_siplt.plotmesh(Th,'d',1,'color','w','LineWidth',1.5)
  shading interp
  title(interpreter('potentiel $\varphi$'),options.interpreter{:},options.title{:})

  figure(4)
  fc_siplt.plotmesh(Th,'color',[0.85,0.85,0.85])
  hold on
  fc_siplt.plotmesh(Th,'d',1,'color',[0,0,0])
  [~,~,cax]=fc_siplt.plotiso(Th,phi,'niso',25,'isocolorbar',true,'format','%.3f');
  set(cax,options.colorbar{:})
  axis image;axis off;
  title(interpreter('potentiel $\varphi$'),options.interpreter{:},options.title{:})

  idxlab=Th.find(2,10);
  figure(5)
  fc_siplt.plotmesh(Th,'d',1,'color','k')
  hold on
  [~,~,cax]=fc_siplt.plotiso(Th,phi,'niso',25,'isocolorbar',true,'format','%.3f');
  set(cax,options.colorbar{:})
  fc_siplt.plotquiver(Th,E,'d',2,'labels',[10],'colordata',phi)
  axis image;axis off;
  title(interpreter('potentiel $\varphi$ and electric field $E$'),options.interpreter{:},options.title{:})

  figure(6)
  fc_siplt.plot(Th,ENorm,'EdgeColor','None')
  hold on
  axis image;axis off;
  set(colorbar(),options.colorbar{:})
  fc_siplt.plotiso(Th,ENorm,'niso',20,'color','w','LineWidth',1) 
  fc_siplt.plotmesh(Th,'d',1,'color','k','LineWidth',1.5)
  shading interp
  title(interpreter('Norm of the electric field $E$'),options.interpreter{:},options.title{:})

  figure(7)
  fc_siplt.plotmesh(Th,'d',1,'color',[0,0,0])
  hold on
  [~,~,cax]=fc_siplt.plotiso(Th,ENorm,'niso',25,'isocolorbar',true,'format','%.3f');
  set(cax,options.colorbar{:})
  axis image;axis off;
  title(interpreter('Norm of the electric field $E$'),options.interpreter{:},options.title{:})
  
  drawnow
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
