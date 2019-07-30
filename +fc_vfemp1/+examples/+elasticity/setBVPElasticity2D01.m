function [bvp,info]=setBVPElasticity2D01(N,verbose,varargin)
  name='2D elasticity BVP[01]';
  p = inputParser;
  p.addParamValue('E',21e5,@isscalar);
  p.addParamValue('nu',0.45,@isscalar);
  %p.addParamValue('verbose',0,@isscalar);
  p.addParamValue('L',20,@isscalar);
  p.parse(varargin{:});
  E=p.Results.E;nu=p.Results.nu;L=p.Results.L;
  %verbose=p.Results.verbose;
  %if N==0, verbose=10*(N==0);end
  dim=2;
  mu= E/(2*(1+nu));
  lam = E*nu/((1+nu)*(1-2*nu));

  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      %s on [0,%g]x[-1,1]\n',name,L), ...
    sprintf('#         on transformed hypercube mesh\n'), ...
    sprintf('#             -div(sigma(u)) = f \n'), ...
    sprintf('# and boundary conditions :\n'), ...
    sprintf('#   * Dirichlet on [1]\n'), ...
    sprintf('#       u_1 = u_2 = 0 on [1],\n'), ...
    sprintf('#   * Neumann on [2,3,4]\n'), ...
    sprintf('#       sigma(u).n = 0 on [2,3,4]\n'), ...
    sprintf('# with f=(0,-1)^t, lambda=%g, mu=%g\n',lam,mu), ...
    S, ...
    sprintf('# Mesh : fc_simesh.HyperCube(2,[%g*N,N],''trans'',@(q) [%g*q(1,:);-1+2*q(2,:)])\n',round(L/2),L), ...
    S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function   
  if verbose>=1
    fprintf('%s',strpres); 
    if verbose==10, return;end
  end
  dim=2;
  
  if verbose>=2,fprintf('*** Building mesh using HyperCube function\n');end
  tstart=tic();
  Th=fc_simesh.HyperCube(dim,[round(L/2)*N,N],'trans',@(q) [L*q(1,:);-1+2*q(2,:)]);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d\n',Th.nq);
    fprintf('*** Setting %s\n',name);
  end
  
  tstart=tic();
  lambda=lam;
  gamma=lambda+2*mu;
  Hop=Hoperator(dim,dim,dim);
  Hop.set(1,1,Loperator(dim,dim,{gamma,[];[],mu},[],[],[])); 
  Hop.set(1,2,Loperator(dim,dim,{[],lambda;mu,[]},[],[],[]));
  Hop.set(2,1,Loperator(dim,dim,{[],mu;lambda,[]},[],[],[]));
  Hop.set(2,2,Loperator(dim,dim,{mu,[];[],gamma},[],[],[]));
  f={0,-1};
  pde=PDE(Hop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet(1,0.,1:2);
  tcpu(2)=toc(tstart);
  
  info.name=name;
  info.solex=[];
  info.E=E;info.nu=nu;info.L=L;
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'Hypermesh','Setting_BVP'};
  info.presentation=strpres;
end