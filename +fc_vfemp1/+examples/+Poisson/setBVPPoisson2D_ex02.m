function [bvp,info]=setBVPPoisson2D_ex02(N,verbose)
  if nargin<=1, verbose=0;end
  uex=@(x,y) cos(4*pi*(x.^2 + y.^2)).*exp(-2*(x.^2 +y.^2));
  f=@(x,y) 64*pi^2*x.^2.*cos(4*pi*(x.^2 + y.^2)).*exp(-2*x.^2 - 2*y.^2) + ...
           64*pi^2*y.^2.*cos(4*pi*(x.^2 + y.^2)).*exp(-2*x.^2 - 2*y.^2) - ...
           64*pi*x.^2.*exp(-2*x.^2 - 2*y.^2).*sin(4*pi*(x.^2 + y.^2)) - ...
           64*pi*y.^2.*exp(-2*x.^2 - 2*y.^2).*sin(4*pi*(x.^2 + y.^2)) - ...
           16*x.^2.*cos(4*pi*(x.^2 + y.^2)).*exp(-2*x.^2 - 2*y.^2) - ...
           16*y.^2.*cos(4*pi*(x.^2 + y.^2)).*exp(-2*x.^2 - 2*y.^2) + ...
           16*pi*exp(-2*x.^2 - 2*y.^2).*sin(4*pi*(x.^2 + y.^2)) + ...
           8*cos(4*pi*(x.^2 + y.^2)).*exp(-2*x.^2 - 2*y.^2);
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
           sprintf('#      2D Poisson B.V.P. problem on unit square:\n'), ...
           sprintf('#               - Delta(u) = f\n'), ...
           sprintf('# with exact solution : %s\n',fc_tools.utils.fun2str(uex)), ...
           sprintf('# and Dirichlet boundary conditions on [1,2,3,4]\n'), ...
           S, ...
           sprintf('# Mesh : fc_simesh.HyperCube(2,N)\n'), ...
           S];
           
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function
  if verbose>=1
    fprintf('%s',strpres); 
    if verbose==10, return;end
  end

  if verbose>=2,fprintf('*** Get mesh using HyperCube function\n');end
  tstart=tic();
  Th=fc_simesh.HyperCube(2,N);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('     Mesh sizes : nq=%d\n',Th.nq);
    fprintf('*** Set 2D Poisson B.V.P. problem\n');
  end
  tstart=tic();
  Lop=Loperator(2,2,{1,0;0,1},[],[],[]);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet( 1, uex);
  bvp.setDirichlet( 2, uex);
  bvp.setDirichlet( 3, uex);
  bvp.setDirichlet( 4, uex);
  tcpu(2)=toc(tstart);

  info.solex=uex;
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'Hypermesh','Setting_BVP'};
  info.presentation=strpres;
end
