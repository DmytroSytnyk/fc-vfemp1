fc_tools.utils.cleaning()
N=40;verbose=2;

[bvp,info]=fc_vfemp1.examples.Poisson.setBVPPoisson3D_ex01(N,verbose);

[U,errors]=fc_vfemp1.examples.genSolveScalarBVP(bvp,info,verbose);


if fc_tools.utils.is_fcPackage('siplt')
  fc_vfemp1.examples.genPlotScalarBVP(bvp,info,U,'Poisson2d[ex03]',verbose)
end

%  
%  Th=bvp.Th;
%  Uex=Th.eval(info.solex);
%  
%  %  [A,b]=bvp.Assembly('Dirichlet',false);
%  %  [ID,IDc,gD]=bvp.AssemblyDirichlet();
%  %  x=classicSolve(A,b,Th.nq,gD,ID,IDc);
%  Error=abs(U-Uex);
%  
%  if fc_tools.utils.is_fcPackage('siplt')
%    figure(1)
%    fc_siplt.plot(Th,U,'d',2, 'FaceColor','interp', 'EdgeColor','none')
%    hold on
%    fc_siplt.plotiso(Th,U,'niso',15,'Color','w')
%    axis image
%    axis off
%    colorbar
%  
%    figure(2)
%    fc_siplt.plot(Th,Error,'d',2, 'FaceColor','interp', 'EdgeColor','none')
%    hold on
%    fc_siplt.plotiso(Th,Error,'niso',15,'Color','w')
%    axis equal,axis image
%    axis off
%    colorbar
%  end
