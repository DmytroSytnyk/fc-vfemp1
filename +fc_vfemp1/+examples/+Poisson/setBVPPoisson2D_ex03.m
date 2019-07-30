function [bvp,info]=setBVPPoisson2D_ex03(N,verbose,varargin)
  if nargin<=1, verbose=0;end
  p = inputParser;
  p.addParamValue('hypercube',true,@islogical); % Using hypercube otherwise gmsh with square4.geo
  p.parse(varargin{:});
  name='2D Poisson BVP[ex03]';
  isHypercube=p.Results.hypercube;
  if ~isHypercube
    geofile='square4';
    fullgeofile=fc_vfemp1.get_geo(2,2,geofile);
    if isempty(fullgeofile), error('geofile %s not found',geofile);end 
    MadeWith='GMSH';
  else
    MadeWith='HyperCube function';
  end
  dim=2;d=2;
  uex=@(x,y) cos(2*x+y);
  f=@(x,y) 5*cos(2*x+y);
  gradu{1}=@(x,y) -2*sin(2*x+y);
  gradu{2}=@(x,y) -sin(2*x+y);
  ar3=@(x,y) 1+x.^2+y.^2;
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
           sprintf('#      %s on unit square:\n',name), ...
           sprintf('#               -Delta(u) = f\n'), ...
           sprintf('# with exact solution : %s\n',fc_tools.utils.fun2str(uex)), ...
           sprintf('# and boundary conditions :\n'), ...
           sprintf('#   * Dirichlet on [1,2]\n'), ...
           sprintf('#       u = gD \n'), ...
           sprintf('#   * Robin boundary condition on [3]\n'), ...
           sprintf('#       du/dn + ar*u = gR\n'), ...
           sprintf('#         with ar=%s\n',fc_tools.utils.fun2str(ar3)), ...
           sprintf('#   * Neumann boundary condition on [4]\n'), ...
           sprintf('#       du/dn = gN\n'), ...
           S];
  if isHypercube         
    strpres=[strpres,sprintf('# Mesh : fc_simesh.hypercube(2,N)\n'),S];
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
    Th=fc_simesh.HyperCube(2,N);
    tname{1}='Hypercube';
  else
    meshfile=gmsh.buildmesh2d(fullgeofile,N,'verbose',verbose,'force',true);
    Th=siMesh(meshfile);
    tname{1}='GMSH';
  end
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, h=%.3e\n',Th.nq,Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(dim,d,{1,0;0,1},[],[],[]);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet( 1, uex);
  bvp.setDirichlet( 2, uex);
  bvp.setRobin( 3, @(x,y)  -gradu{2}(x,y)+ar3(x,y).*uex(x,y),ar3);
  bvp.setRobin( 4, gradu{2},[]);
  tcpu(2)=toc(tstart);

  info.solex=uex;
  info.f=f;
  info.gradu=gradu;
  info.ar3=ar3;
  info.tcpu=tcpu;
  info.tname={'Hypermesh','Setting_BVP'};
  info.presentation=strpres;
end
