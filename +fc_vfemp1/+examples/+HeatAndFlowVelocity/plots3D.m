function plots3D(Th,U,Phi,V)
  options=fc_tools.graphics.DisplayFigures('nfig',8);
  interpreter=@(x) fc_tools.graphics.interpreter(x);
  isorange=linspace(min(Phi),max(Phi),20);
  isOctave=fc_tools.comp.isOctave();

  figure(1)
  fc_siplt.plotmesh(Th,'d',2,'inlegend',true,'EdgeColor','none')
  xlabel('x'),ylabel('y'),zlabel('z')
  axis image
  legend('show')
    
  figure(2)
  fc_siplt.plotmesh(Th,'d',2,'inlegend',true,'EdgeColor','none','labels',[10,11,31,1000,1020,1021,2000,2020,2021])
  xlabel('x'),ylabel('y'),zlabel('z')
  axis image
  view([-80.5,10])
  legend('show')
    
  P1=fc_tools.graphics.PlaneCoefs([0 0 1],[0 0 1]);
    
  figure(3)
  fc_siplt.plot(Th,Phi,'d',2,'FaceColor','interp','EdgeColor','none')
  hold on,axis off,axis image
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  fc_siplt.plotiso(Th,Phi,'isorange',isorange,'Color','w')
  colorbar(options.colorbar{:})
  set(get(colorbar(),'title'),'string',interpreter('$\phi$'),options.title{:},options.interpreter{:})
  if ~isOctave,camzoom(1.3);end
  
  figure(4)
  fc_siplt.plot(Th,Phi,'d',2,'labels',[10,11,31,1000,1020,1021,2000,2020,2021],'FaceColor','interp','EdgeColor','none')
  hold on,axis off,axis image
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  fc_siplt.plotiso(Th,Phi,'labels',[10,11,31,1000,1020,1021,2000,2020,2021],'isorange',isorange,'Color','w')
  fc_siplt.slice(Th,Phi,P1,'FaceColor','interp')
  fc_siplt.sliceiso(Th,Phi,P1,'isorange',isorange,'Color','w')
  set(get(colorbar(),'title'),'string',interpreter('$\phi$'),options.title{:},options.interpreter{:})
  view(-35,26)
  if ~isOctave,camzoom(1.3);end

  isorange=linspace(min(U),max(U),20);
  figure(5)
  colormap(jet)
  fc_siplt.plot(Th,U,'d',2,'FaceColor','interp','EdgeColor','none')
  hold on,axis off,axis image
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  fc_siplt.plotiso(Th,U,'isorange',isorange,'Color','w')
  colorbar(options.colorbar{:})
  set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})
  if ~isOctave,camzoom(1.3);end
  
  figure(6)
  colormap(jet)
  fc_siplt.plot(Th,U,'d',2,'labels',[10,11,31,1000,1020,1021,2000,2020,2021],'FaceColor','interp','EdgeColor','none')
  hold on,axis off,axis image
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  fc_siplt.plotiso(Th,U,'labels',[10,11,31,1000,1020,1021,2000,2020,2021],'isorange',isorange,'Color','w')
  P1=fc_tools.graphics.PlaneCoefs([0 0 1],[0 0 1]);
  fc_siplt.slice(Th,U,P1,'FaceColor','interp')
  fc_siplt.sliceiso(Th,U,P1,'isorange',isorange,'Color','w')
  set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})
  view(-35,26)
  if ~isOctave,camzoom(1.3);end
  
  VelocityMagnitude=sqrt(V{1}.^2+V{2}.^2+V{3}.^2);
  mV=max(VelocityMagnitude);
  
  figure(7)
  colormap(jet)
  fc_siplt.plotmesh(Th,'d',2,'labels',[10,11,31],'FaceColor',0.8*[1,1,1],'EdgeColor',0.9*[1,1,1])
  hold on,axis off,axis image
  fc_siplt.plotquiver(Th,V,'colordata',U,'scale',1.3*Th.get_h()/mV,'freq',1)
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  colorbar(options.colorbar{:})
  set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})
  view(84,-84)
  if ~isOctave,camzoom(1.3);end
  
  figure(8)
  colormap(jet)
  fc_siplt.plotmesh(Th,'d',2,'labels',[10,11,31],'FaceColor',0.8*[1,1,1],'EdgeColor',0.9*[1,1,1])
  hold on,axis off,axis image
  fc_siplt.plotquiver(Th,V,'colordata',U,'scale',2*Th.get_h()/mV,'freq',2)
  %caxis([min(U),max(U)])
  fc_siplt.plotmesh(Th,'d',1,'Color','k','Linewidth',1.5)
  colorbar(options.colorbar{:})
  set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})
  axis image, axis off
  view([-80.5,10])
  if ~isOctave,camzoom(1.3);end
end
