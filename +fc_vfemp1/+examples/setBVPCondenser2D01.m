function [bvp,info]=setBVPCondenser2D01(N,verbose)
  if nargin==1, verbose=10*(N==0);end
  geofile='condenser';
  fullgeofile=fc_vfemp1.get_geo(2,2,geofile);
  if isempty(fullgeofile), error('geofile %s not found',geofile);end
  S=fc_tools.utils.line_text_delimiter();
  name='2D condenser BVP[01]';
  strpres=[S, ...
           sprintf('#      %s on GMSH mesh from %s.geo\n',name,geofile), ...
           sprintf('#               - Delta(u) = 0\n'), ...
           sprintf('# and boundary conditions :\n'), ...
           sprintf('#   * Dirichlet on [1,98,99]\n'), ...
           sprintf('#       u = 0 on [1], -12 on [98] and 12 on [99]  \n'), ...
           S, ...
           sprintf('# Mesh : gmsh.buildmesh2d(''%s.geo'',N)\n',geofile), ...
           S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function 
  if verbose>=1
    fprintf('%s',strpres); 
    if verbose==10, return;end
  end

  if verbose>=2,fprintf('*** Building the mesh using GMSH\n');end
  tstart=tic();
  meshfile=gmsh.buildmesh2d(fullgeofile,N,'force',true,'verbose',verbose);
  Th=siMesh(meshfile);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, h=%.3e\n',Th.nq,Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(2,2,{1,0;0,1},[],[],[]);
  pde=PDE(Lop);
  bvp=BVP(Th,pde);
  bvp.setDirichlet( 1, 0.);
  bvp.setDirichlet( 98, -12.);
  bvp.setDirichlet( 99, +12.);
  tcpu(2)=toc(tstart);

  info.name=name;
  info.solex=[];
  info.f=[];
  info.tcpu=tcpu;
  info.tname={'GMSH','Setting_BVP'};
  info.presentation=strpres;
end
