function [bvp,info]=setBVPPoisson2D_ex01(N,verbose,varargin)
  if nargin<=1, verbose=0;end
  p = inputParser;
  p.addParamValue('hypercube',true,@islogical); % Using hypercube otherwise gmsh with square4.geo
  p.parse(varargin{:});
  
  name='2D Poisson BVP[ex01]';
  isHypercube=p.Results.hypercube;
  if ~isHypercube
    geofile='square4';
    fullgeofile=fc_vfemp1.get_geo(2,2,geofile);
    if isempty(fullgeofile), error('geofile %s not found',geofile);end 
    MadeWith='GMSH';
  else
    MadeWith='HyperCube function';
  end
  uex=@(x,y) cos(x-y).*sin(x+y)+exp(-(x.^2+y.^2));
  f=@(x,y) -4*x.^2.*exp(-x.^2-y.^2) - 4*y.^2.*exp(-x.^2-y.^2) + 4*cos(x-y).*sin(x+y) + 4*exp(-x.^2-y.^2);
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
           sprintf('#      %s on unit square:\n',name), ...
           sprintf('#               -Delta(u) = f\n'), ...
           sprintf('# with exact solution : %s\n',fc_tools.utils.fun2str(uex)), ...
           sprintf('# and Dirichlet boundary conditions on [1,2,3,4]\n'), ...
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
  Lop=Loperator(2,2,{1,0;0,1},[],[],[]);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet( 1, uex);
  bvp.setDirichlet( 2, uex);
  bvp.setDirichlet( 3, uex);
  bvp.setDirichlet( 4, uex);
  tcpu(2)=toc(tstart);
  tname{2}='Setting_BVP';
  info.solex=uex;
  info.f=f;
  info.tcpu=tcpu;
  info.tname=tname;
  info.presentation=strpres;
end
