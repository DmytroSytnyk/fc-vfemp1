function [bvp,info]=setBVPStationaryConvectionDiffusion3D01(N,verbose)
  name='3D stationary convection-diffusion BVP[01]';
  [default_geodir,default_meshdir]=fc_vfemp1.default_directories(3);
  geofile='cylinder3holes';  
  fullgeofile=fc_vfemp1.get_geo(3,3,geofile);
  if isempty(fullgeofile), error('geofile %s not found',geofile);end 
  af=@(x,y,z) 0.7+ z/10;
  beta=0.01;
  V={@(x,y,z) -10*y ,@(x,y,z) 10*x ,@(x,y,z) 10*z};
  f=@(x,y,z) -800*exp(-10*((x-0.65).^2+y.^2+(z-0.5).^2)) + 800*exp(-10*((x+0.65).^2+y.^2+(z-0.5).^2));
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      %s\n',name), ...
    sprintf('#         on GMSH mesh from %s.geo\n',geofile), ...
    sprintf('#               - div(a grad u) + <V,grad u> + b u = f\n'), ...
    sprintf('# and boundary conditions :\n'), ...
    sprintf('#   * Neumann on [1,10,100,101]\n'), ...
    sprintf('#       du/dn = 0   \n'), ...
    sprintf('#   * Robin on [20,21]\n'), ...
    sprintf('#       du/dn + u = +0.05 on [20]\n'), ...
    sprintf('#       du/dn + u = -0.05 on [21]\n'), ...
    sprintf('# with \n'), ...
    sprintf('#   a = %s \n',func2str(af)), ...
    sprintf('#   V = [%s,%s,%s] \n',func2str(V{1}),func2str(V{2}),func2str(V{3})), ...
    sprintf('#   b = %g \n',beta), ...
    sprintf('#   f = %s \n',func2str(f)), ...
    S, ...
    sprintf('# Mesh : gmsh.buildmesh3d(''%s.geo'',N)\n',geofile), ...
    S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function 
  if verbose>=1
    fprintf('%s',strpres);
    if verbose==10, return;end
  end

  if verbose>=2,fprintf('*** Building the mesh using GMSH\n');end
  tstart=tic();
  meshfile=gmsh.buildmesh3d(fullgeofile,N,'verbose',verbose,'force',true);
  Th=siMesh(meshfile,'dim',3);
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(Th.dim,Th.d,{af,[],[];[],af,[];[],[],af},[],V,beta);
  pde=PDE(Lop,f);
  bvp=BVP(Th,pde);
  bvp.setRobin(20,0.05,1);
  bvp.setRobin(21,-0.05,1);
  tcpu(2)=toc(tstart);

  info.name=name;
  info.solex=[];
  info.V=V;
  info.f=f;
  info.tcpu=tcpu;
  info.tname={'GMSH','Setting_BVP'};
  info.presentation=strpres;
end
