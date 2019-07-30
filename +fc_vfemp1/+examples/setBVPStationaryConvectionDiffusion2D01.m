function [bvp,info]=setBVPStationaryConvectionDiffusion2D01(N,verbose)
  %
  name='2D stationary convection-diffusion BVP[01]';
  geofile='disk3holes';
  fullgeofile=fc_vfemp1.get_geo(2,2,geofile);
  if isempty(fullgeofile), error('geofile %s not found',geofile);end 
  af=@(x,y) 0.1+y.^2;
  Vx=@(x,y) -10*y;Vy=@(x,y) 10*x;
  b=0.01;g2=4;g4=-4;
  f=@(x,y) -200.0*exp(-((x-0.75).^2+y.^2)/(0.1));
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      %s\n',name), ...
    sprintf('#         on GMSH mesh from %s.geo\n',geofile), ...
    sprintf('#               - div(a grad u) + <V,grad u> + b u = f\n'), ...
    sprintf('# and boundary conditions :\n'), ...
    sprintf('#   * Dirichlet on [2,4,20,21]\n'), ...
    sprintf('#       u = 4 on [2], -4 on [4] and 0 on [20,21]  \n'), ...
    sprintf('#   * Neumann on [1,3,10]\n'), ...
    sprintf('#       du/dn = 0 on [2,3,10]\n'), ...
    sprintf('# with \n'), ...
    sprintf('#   a = %s \n',fc_tools.utils.fun2str(af)), ...
    sprintf('#   V = [%s,%s] \n',fc_tools.utils.fun2str(Vx),fc_tools.utils.fun2str(Vy)), ...
    sprintf('#   b = %s \n',fc_tools.utils.fun2str(b)), ...
    sprintf('#   f = %s \n',fc_tools.utils.fun2str(f)), ...
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
  meshfile=gmsh.buildmesh2d(fullgeofile,N,'verbose',verbose,'force',true);
  Th=siMesh(meshfile);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(Th.dim,Th.d,{af,[];[],af},[],{Vx,Vy},b);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  bvp.setDirichlet(2, g2);
  bvp.setDirichlet(4, g4);
  bvp.setDirichlet(20, 0.);
  bvp.setDirichlet(21, 0.);
  tcpu(2)=toc(tstart);

  info.name=name;
  info.solex=[];
  info.V={Vx,Vy};
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'GMSH','Setting_BVP'};
  info.presentation=strpres;
end
