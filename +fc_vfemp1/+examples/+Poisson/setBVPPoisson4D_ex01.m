function [bvp,info]=setBVPPoisson4D_ex01(N,verbose,varargin)
  if nargin==1, verbose=10*(N==0);end
  name='4D Poisson BVP[ex01]';
  MadeWith='HyperCube function';
  uex=@(x1,x2,x3,x4) cos(2*x1-x2-x3+x4).*sin(x1-2*x2+x3-2*x4);
  f=@(x1,x2,x3,x4) 2*cos(x1 - 2*x2 + x3 - 2*x4).*sin(2*x1 - x2 - x3 + x4) + 17*cos(2*x1 - x2 - x3 + x4).*sin(x1 - 2*x2 + x3 - 2*x4);
  ar=1;
  gradu={@(x1,x2,x3,x4) cos(2*x1 - x2 - x3 + x4).*cos(x1 - 2*x2 + x3 - 2*x4) - 2*sin(2*x1 - x2 - x3 + x4).*sin(x1 - 2*x2 + x3 - 2*x4), ...
         @(x1,x2,x3,x4) -2*cos(2*x1 - x2 - x3 + x4).*cos(x1 - 2*x2 + x3 - 2*x4) + sin(2*x1 - x2 - x3 + x4).*sin(x1 - 2*x2 + x3 - 2*x4), ...
         @(x1,x2,x3,x4) cos(2*x1 - x2 - x3 + x4).*cos(x1 - 2*x2 + x3 - 2*x4) + sin(2*x1 - x2 - x3 + x4).*sin(x1 - 2*x2 + x3 - 2*x4), ...
         @(x1,x2,x3,x4) -2*cos(2*x1 - x2 - x3 + x4).*cos(x1 - 2*x2 + x3 - 2*x4) - sin(2*x1 - x2 - x3 + x4).*sin(x1 - 2*x2 + x3 - 2*x4)};    
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
           sprintf('#      %s on unit 4D-hypercube:\n',name), ...
           sprintf('#               -Delta(u) = f\n'), ...
           sprintf('# with exact solution : %s\n',fc_tools.utils.fun2str(uex)), ...
           sprintf('# and boundary conditions :\n'), ...
           sprintf('#   * Dirichlet on [1,3,5,7]\n'), ...
           sprintf('#       u = gD \n'), ...
           sprintf('#   * Robin boundary condition on [2,4]\n'), ...
           sprintf('#       du/dn + ar*u = gR\n'), ...
           sprintf('#         with ar=%s\n',fc_tools.utils.fun2str(ar)), ...
           sprintf('#   * Neumann boundary condition on [6,8]\n'), ...
           sprintf('#       du/dn = gN\n'), ...
           S];
  strpres=[strpres,sprintf('# Mesh : fc_simesh.hypercube(4,N)\n'),S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function
  if verbose>=1
    fprintf('%s',strpres);       
    if verbose==10, return;end
  end

  if verbose>=2,fprintf('*** Setting the mesh using %s\n',MadeWith);end
  tstart=tic();
  Th=fc_simesh.HyperCube(4,N);
  tname{1}='Hypercube';
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, h=%.3e\n',Th.nq,Th.get_h());
    fprintf('*** Setting the %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(4,4,{1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1},[],[],[]);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  for lab=[1,3,5,7], bvp.setDirichlet( lab, uex);end
  bvp.setRobin(2,@(x1,x2,x3,x4) gradu{1}(x1,x2,x3,x4)+ar*uex(x1,x2,x3,x4),ar);
  bvp.setRobin(4,@(x1,x2,x3,x4) gradu{2}(x1,x2,x3,x4)+ar*uex(x1,x2,x3,x4),ar);
  bvp.setRobin(6,@(x1,x2,x3,x4) gradu{3}(x1,x2,x3,x4),[]);
  bvp.setRobin(8,@(x1,x2,x3,x4) gradu{4}(x1,x2,x3,x4),[]);
  tcpu(2)=toc(tstart);
  tname{2}='Setting_BVP';
  info.solex=uex;
  info.f=f;
  info.tcpu=tcpu;
  info.tname=tname;
  info.presentation=strpres;
end
