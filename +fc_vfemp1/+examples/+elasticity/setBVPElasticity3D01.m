function [bvp,info]=setBVPElasticity3D01(N,verbose,varargin)
  name='3D elasticity BVP[01]';
  p = inputParser;
  p.addParamValue('E',21e5,@isscalar);
  p.addParamValue('nu',0.45,@isscalar);
  %p.addParamValue('verbose',0,@isscalar);
  p.addParamValue('L',5,@isscalar);
  p.parse(varargin{:});
  E=p.Results.E;nu=p.Results.nu;L=p.Results.L;
  %verbose=p.Results.verbose;
  %if N==0, verbose=10*(N==0);end
  dim=3;
  mu= E/(2*(1+nu));
  lam = E*nu/((1+nu)*(1-2*nu));

  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      %s on [0,%g]x[0,1]x[0,1]\n',name,L), ...
    sprintf('#         on transform hypercube mesh\n'), ...
    sprintf('#             -div(sigma(u)) = f \n'), ...
    sprintf('# and boundary conditions :\n'), ...
    sprintf('#   * Dirichlet on [1]\n'), ...
    sprintf('#       u_1 = u_2 = u_3 = 0 on [1],\n'), ...
    sprintf('#   * Neumann on [2,3,4,5,6]\n'), ...
    sprintf('#       sigma(u).n = 0\n'), ...
    sprintf('# with f=(0,0,-1)^t, lambda=%g, mu=%g\n',lam,mu), ...
    S, ...
    sprintf('# Mesh : fc_simesh.HyperCube(3,[%g*N,N,N],''trans'',@(q) [%g*q(1,:);q(2,:);q(3,:)])\n',round(L),L), ...
    S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function 
  if verbose>=1
    fprintf('%s',strpres); 
    if verbose==10, return;end
  end
  
  if verbose>=2,fprintf('*** Building mesh using HyperCube function\n');end
  tstart=tic();
  Th=fc_simesh.HyperCube(dim,[round(L)*N,N,N],'trans',@(q) [L*q(1,:);q(2,:);q(3,:)]);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  
  tstart=tic();
  Hop=Hoperator();
  Hop.opStiffElas(dim,lam,mu);
  f={0,0,-1};
  pde=PDE(Hop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet(1,0.,1:3);
  tcpu(2)=toc(tstart);
  
  info.name=name;
  info.solex=[];
  info.E=E;info.nu=nu;info.L=L;
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'Hypermesh','Setting_BVP'};
  info.presentation=strpres;
end
