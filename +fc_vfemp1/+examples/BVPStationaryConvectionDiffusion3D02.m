fc_tools.utils.cleaning()

[bvp,info]=fc_vfemp1.examples.setBVPStationaryConvectionDiffusion3D01(30,1);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving 3D stationary convection-diffusion BVP\n')
[U,SolveInfo]=bvp.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(U));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  fc_tools.graphics.DisplayFigures('nfig',2);
  Th=bvp.Th;
  figure(1);
  P=fc_tools.graphics.PlaneCoefs([0 0 1],[0 1 1]);
  fc_siplt.slice(Th,U,P)
  axis off,axis image,hold on
  fc_siplt.plot(Th,U,'d',2,'labels',[100,101], 'FaceColor','interp', 'EdgeColor','none')
  caxis([min(U),max(U)])
  isorange=linspace(min(U),max(U),10);
  fc_siplt.plot(Th,U,'d',2,'labels',[10,20,21], 'FaceColor','none', 'EdgeColor','interp')
  fc_siplt.plotiso(Th,U,'labels',[100,101], 'isorange',isorange, 'color','w')
  fc_siplt.sliceiso(Th,U,P,'isorange',isorange, 'color','w')
  view(-114,11)
  title(sprintf('nq=%d, nme=%d',Th.nq,Th.get_nme()));

  figure(2)
  P1=fc_tools.graphics.PlaneCoefs([0 0 1],[1 0 0]);
  fc_siplt.slice(Th,U,P1)
  hold on
  P2=fc_tools.graphics.PlaneCoefs([0 0 1],[0 1 0]);
  fc_siplt.slice(Th,U,P2)
  P3=fc_tools.graphics.PlaneCoefs([0 0 1],[0 0 1]);
  fc_siplt.slice(Th,U,P3)
  fc_siplt.sliceiso(Th,U,P3,'isorange',isorange, 'color','w')
  fc_siplt.plot(Th,U,'d',2,'labels',[100,101], 'FaceColor','interp','EdgeColor','none')
  fc_siplt.plotiso(Th,U,'labels',[100,101], 'isorange',isorange, 'color','w')
  fc_siplt.plot(Th,U,'d',2,'labels',[10,20,21], 'FaceColor','none', 'EdgeColor','interp')
  caxis([min(U),max(U)])
  fc_siplt.plotmesh(Th,'d',1, 'Color','k', 'Linewidth',1.5)
  axis off,axis image
  title(sprintf('nq=%d, nme=%d',Th.nq,Th.get_nme()));
  
  drawnow
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
