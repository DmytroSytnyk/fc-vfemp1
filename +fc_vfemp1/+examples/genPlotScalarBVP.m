function genPlotScalarBVP(bvp,info,U,stitle,verbose)
  Th=bvp.Th;
  is_solex=false;
  if isfield(info,'solex') && ~isempty(info.solex)
      Uex=Th.eval(info.solex);
      E=abs(U-Uex);
      is_solex=true;
  end
  if verbose>=2, fprintf('*** Graphic representations\n');end
  
  if Th.d==2
    figure(1)
    fc_siplt.plotmesh(Th,'color','LightGray')
    hold on
    fc_siplt.plotmesh(Th,'inlegend',true,'d',1,'LineWidth',2)
    legend('show')
    axis off,axis image

    figure(2)
    fc_siplt.plot(Th,U)
    axis off,axis image
    colorbar
    shading interp
    title(sprintf('%s, P1-FEM solution',stitle))

    if is_solex
      figure(3)
      fc_siplt.plot(Th,E)
      axis off,axis image
      colorbar
      shading interp
      title(sprintf('%s, P1-FEM error',stitle))
    end
  elseif Th.d==3
    figure(1)
    fc_siplt.plotmesh(Th,'inlegend',true)
    legend('show')
    axis off,axis image
    figure(2)
    fc_siplt.plotmesh(Th,'inlegend',true,'d',2)
    legend('show')
    axis off,axis image
    
    MidPoint=0.5*(Th.bbox(2:2:end)-Th.bbox(1:2:end));
    P=[fc_tools.graphics.PlaneCoefs(MidPoint,[1 0 0]); ...
       fc_tools.graphics.PlaneCoefs(MidPoint,[0 1 0]); ...
       fc_tools.graphics.PlaneCoefs(MidPoint,[0 0 1])];
    
    figure(3)
    fc_siplt.plot(Th,U)
    axis image;axis off;colorbar
    title(sprintf('%s, P1-FEM solution',stitle))
    figure(4)
    fc_siplt.slice(Th,U,P)%, 'FaceColor','interp', 'EdgeColor','none')
    hold on
    fc_siplt.sliceiso(Th,U,P,'niso',10,'Color','w')
    axis image;axis off;colorbar
    title(sprintf('%s, P1-FEM solution',stitle))
    
    if is_solex
      figure(5)
      colormap('jet')
      fc_siplt.plot(Th,E)
      axis image;axis off;colorbar
      title(sprintf('%s, P1-FEM error',stitle))
      figure(6)
      colormap('jet')
      fc_siplt.slice(Th,E,P)%, 'FaceColor','interp', 'EdgeColor','none')
      hold on
      fc_siplt.sliceiso(Th,E,P,'niso',10,'Color','w')
      axis image;axis off;colorbar
      title(sprintf('%s, P1-FEM error',stitle))
    end
  else
    P = mfilename();
    fprintf('In function %s: not yet implemented for Th.d=%d\n',P,Th.d);
    P = mfilename('fullpath');
    fprintf('in file :\n  %s\n',P);
  end
  
  fc_tools.graphics.DisplayFigures()
end
