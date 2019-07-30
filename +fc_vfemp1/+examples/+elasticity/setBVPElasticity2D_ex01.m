function [bvp,info]=setBVPElasticity2d_ex01(N,verbose,varargin)
  p = inputParser;
  p.addParamValue('E',21e5,@isscalar);
  p.addParamValue('nu',0.45,@isscalar);
  %p.addParamValue('verbose',0,@isscalar);
  p.parse(varargin{:});
  E=p.Results.E;nu=p.Results.nu;
  %verbose=p.Results.verbose;
  %if N==0, verbose=10*(N==0);end
  mu= E/(2*(1+nu));
  lam = E*nu/((1+nu)*(1-2*nu));
  uex={@(x,y) cos(2*x+y),@(x,y) sin(x-3*y)};
  f={@(x,y) 4*lam*cos(2*x + y) + 9*mu*cos(2*x + y) + 3*lam*sin(-x + 3*y) + 3*mu*sin(-x + 3*y), ...
    @(x,y) 2*lam*cos(2*x + y) + 2*mu*cos(2*x + y) - 9*lam*sin(-x + 3*y) - 19*mu*sin(-x + 3*y)};
  g2={@(x,y) -3*lam*cos(-x + 3*y) - 2*lam*sin(2*x + y) - 4*mu*sin(2*x + y), ...
      @(x,y) mu*(cos(-x + 3*y) - sin(2*x + y))};
  
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      2D Elasticity B.V.P. problem on unit square:\n'), ...
    sprintf('#         - div sigma(u) = f\n'), ...
    sprintf('# with  * Dirichlet boundary conditions on [1,3,4]\n'), ...
    sprintf('#       * Neumann boundary conditions on [2]\n'), ...
    sprintf('# and Young modulus E=%g, Poisson ration nu=%g\n',E,nu), ...
    sprintf('# exact sol. : [%s,%s]\n',fc_tools.utils.fun2str(uex{1}),fc_tools.utils.fun2str(uex{2})), ...
    S, ...
    sprintf('# Mesh : fc_simesh.hypermesh(2,N)\n'), ...
    S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function   
  if verbose>=1
    fprintf('%s',strpres); 
    if verbose==10, return;end
  end
  dim=2;
  
  if verbose>=2,fprintf('*** Building mesh using HyperCube function\n');end
  tstart=tic();
  Th=fc_simesh.HyperCube(dim,N);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d\n',Th.nq);
    fprintf('*** Setting 2D Elasticity BVP\n');
  end
  
  tstart=tic();
  Hop=Hoperator();
  Hop.opStiffElas(dim,lam,mu);
  %Hop=Hoperator.StiffElas(dim,lam,mu);
  pde=PDE(Hop,f);
  bvp=BVP(Th,pde);
  for lab=[1,3,4]
    bvp.setDirichlet(lab,uex,1:2);
  end
  bvp.setRobin(2,g2,[],1:2);
  tcpu(2)=toc(tstart);
  info.solex=uex;
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'Hypermesh','Setting_BVP'};
  info.presentation=strpres;
end
