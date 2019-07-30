function plots2D(Th,u,phi,V)
options=fc_tools.graphics.DisplayFigures('nfig',8);
interpreter=@(x) fc_tools.graphics.interpreter(x);

figure(1)
fc_siplt.plotmesh(Th,'color','LightGray')
hold on
fc_siplt.plotmesh(Th,'d',1,'inlegend',true);
legend('show')
axis off,axis image
text(-0.5,0.5,interpreter('$\Omega$'),options.title{:},options.interpreter{:})
title(interpreter('2D stationary heat with potential flow - domain $\Omega$'),options.title{:},options.interpreter{:});

figure(2)
fc_siplt.plot(Th,u)%,'PlotOptions',{'SpecularStrength',0.95})
colormap(jet)
hold on,axis off,axis image
colorbar(options.colorbar{:})
fc_siplt.plotiso(Th,u,'isorange',1:16,'Color','w')
axis off;axis image
shading interp
title('2D stationary heat with potential flow',options.title{:},options.interpreter{:})
colorbar(options.colorbar{:})
set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})

figure(3)
fc_siplt.plotmesh(Th,'color','LightGray')
hold on,axis off;axis image
fc_siplt.plotmesh(Th,'d',1,'color','k','LineWidth',2)
colormap(jet)
fc_siplt.plotiso(Th,u,'niso',25,'isocolorbar',true,'format','%2.3f')
title('2D stationary heat with potential flow',options.title{:},options.interpreter{:})

figure(4)
fc_siplt.plot(Th,phi)
hold on,axis off,axis image
fc_siplt.plotiso(Th,phi,'Color','w')
shading interp
colorbar(options.colorbar{:})
title(interpreter('Velocity potential $\phi$'),options.title{:},options.interpreter{:})
set(get(colorbar(),'title'),'string',interpreter('$\phi$'),options.title{:},options.interpreter{:})

figure(5)
fc_siplt.plotmesh(Th,'color','LightGray')
hold on,axis off;axis image
fc_siplt.plotmesh(Th,'d',1,'color','k','LineWidth',2)
fc_siplt.plotiso(Th,phi,'niso',25,'isocolorbar',true,'format','%2.3f','plan',true)
title('Velocity potential $\phi$',options.title{:},options.interpreter{:})


v2=sqrt(V{1}.^2+V{2}.^2);
figure(6)
fc_siplt.plot(Th,v2)
hold on,axis off,axis image
fc_siplt.plotiso(Th,v2,'niso',15,'Color','w')
shading interp
colorbar(options.colorbar{:})
title('Potential flow',options.title{:},options.interpreter{:})
set(get(colorbar(),'title'),'string',interpreter('$\| \mathbf{V} \|_2$'),options.title{:},options.interpreter{:})

mv2=max(v2);
figure(7)
clf
colormap(jet)
fc_siplt.plotquiver(Th,[V{1},V{2}],'colordata',u,'scale',5*Th.get_h()/mv2,'freq',10);
hold on,axis image, axis off
colorbar(options.colorbar{:})
fc_siplt.plotmesh(Th,'d',1,'color','k','Linewidth',2)
title(interpreter('Potential flow $\mathbf{V}$ colorized with heat $u$'),options.title{:},options.interpreter{:})
set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})

figure(8)
colormap(jet)
fc_siplt.plotquiver(Th,[V{1},V{2}],'colordata',u,'scale',4*Th.get_h()/mv2,'freq',3);
hold on,axis image, axis off
colorbar(options.colorbar{:})
fc_siplt.plotmesh(Th,'d',1,'color','k','Linewidth',2)
title(interpreter('Potential flow $\mathbf{V}$ colorized with heat $u$ (zoom)'),options.title{:},options.interpreter{:})
set(get(colorbar(),'title'),'string',interpreter('$u$'),options.title{:},options.interpreter{:})
if fc_tools.comp.isOctave
  axis([-1   -0.14   -0.45    0.4])
else
  camdolly(-0.2,0,0)
  camzoom(5)
end

