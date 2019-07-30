function [bvp,info]=setBVPPoisson3D_ex01(N,verbose,varargin)
  if nargin==1, verbose=10*(N==0);end
  p = inputParser;
  p.addParamValue('hypercube',true,@islogical); % Using hypercube otherwise gmsh with square4.geo
  p.parse(varargin{:});
  
  name='3D Poisson BVP[ex01]';
  isHypercube=p.Results.hypercube;
  if ~isHypercube
    geofile='cube6';
    fullgeofile=fc_vfemp1.get_geo(3,3,geofile);
    if isempty(fullgeofile), error('geofile %s not found',geofile);end 
    MadeWith='GMSH';
  else
    MadeWith='HyperCube function';
  end
  uex=@(x,y,z) cos(4*x-3*y+5*z);
  f=@(x,y,z) 50*uex(x,y,z);
  ar=1;
  gradu={@(x,y,z) -4*sin(4*x-3*y+5*z), ...
         @(x,y,z)  3*sin(4*x-3*y+5*z), ...
         @(x,y,z) -5*sin(4*x-3*y+5*z)};
         
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
           sprintf('#      %s on unit cube:\n',name), ...
           sprintf('#               -Delta(u) = f\n'), ...
           sprintf('# with exact solution : %s\n',fc_tools.utils.fun2str(uex)), ...
           sprintf('# and boundary conditions :\n'), ...
           sprintf('#   * Dirichlet on [1,3,5]\n'), ...
           sprintf('#       u = gD \n'), ...
           sprintf('#   * Robin boundary condition on [2,4]\n'), ...
           sprintf('#       du/dn + ar*u = gR\n'), ...
           sprintf('#         with ar=%s\n',fc_tools.utils.fun2str(ar)), ...
           sprintf('#   * Neumann boundary condition on [6]\n'), ...
           sprintf('#       du/dn = gN\n'), ...
           S];
  if isHypercube         
    strpres=[strpres,sprintf('# Mesh : fc_simesh.hypercube(3,N)\n'),S];
  else
    strpres=[strpres,sprintf('# Mesh : gmsh with %s\n',fullgeofile),S];
  end
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function
  if verbose>=1
    fprintf('%s',strpres);       
    if verbose==10, return;end
  end

  if verbose>=2,fprintf('*** Setting the mesh using %s\n',MadeWith);end
  tstart=tic();
  if isHypercube
    Th=fc_simesh.HyperCube(3,N);
    tname{1}='Hypercube';
  else
    meshfile=gmsh.buildmesh3d(fullgeofile,N,'verbose',verbose,'force',true);
    Th=siMesh(meshfile,'dim',3);
    tname{1}='GMSH';
  end
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, h=%.3e\n',Th.nq,Th.get_h());
    fprintf('*** Set 3D Poisson B.V.P. problem\n');
  end
  tstart=tic();
  Lop=Loperator(3,3,{1,0,0;0,1,0;0,0,1},[],[],[]);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  for lab=[1,3,5], bvp.setDirichlet( lab, uex);end
  bvp.setRobin(2,@(x,y,z) gradu{1}(x,y,z)+ar*uex(x,y,z),ar);
  bvp.setRobin(4,@(x,y,z) gradu{2}(x,y,z)+ar*uex(x,y,z),ar);
  bvp.setRobin(6,@(x,y,z) gradu{3}(x,y,z),[]);
  tcpu(2)=toc(tstart);
  tname{2}='Setting_BVP';
  info.solex=uex;
  info.f=f;
  info.tcpu=tcpu;
  info.tname=tname;
  info.presentation=strpres;
end
