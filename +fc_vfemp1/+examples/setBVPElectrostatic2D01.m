function [bvp,info]=setBVPElectrostatic2D01(N,verbose,varargin)
  [default_geodir,default_meshdir]=fc_vfemp1.default_directories(2);
  p = inputParser; 
  p.addParamValue('sigma1',1,@isscalar); 
  p.addParamValue('sigma2',10,@isscalar);
  %p.addParamValue('verbose',0,@isscalar); % select labels to draw
  %p.addParamValue('geodir',default_geodir,@ischar);  % not used!
  p.addParamValue('meshdir',default_meshdir,@ischar);
  p.parse(varargin{:});
  R=p.Results;
  sigma1=R.sigma1;sigma2=R.sigma2;%verbose=R.verbose;
  geofile='square4holes6dom.geo';
  dim=2;d=2;
  fullgeofile=fc_vfemp1.get_geo(dim,d,geofile);
  if isempty(fullgeofile), error('geofile %s not found',geofile);end 
  name='2D electrostatic BVP[01]';
  S=fc_tools.utils.line_text_delimiter();
  strpres=[S, ...
    sprintf('#      %s\n',name), ...
    sprintf('#        on square [-1,1]x[-1,1] with \n'), ...
    sprintf('#        4 holes and 6 domains \n'), ...
    S, ...
    sprintf('# PDE :\n'), ...
    sprintf('#    * -div(sigma grad(phi)) = 0   on domain [2,4,6,8,10,20]\n'), ...
    sprintf('# Local electrical conductivity : \n'), ...
    sprintf('#    * sigma=sigma1=%g on domain [10]\n',sigma1), ...
    sprintf('#    * sigma=sigma2=%g on domain [2,4,6,8,20]\n',sigma2), ...
    sprintf('# Dirichlet boundary condition on boundaries [1,3,5,7]\n'), ...
    sprintf('#    * on [1,5] : phi = 12\n'), ...
    sprintf('#    * on [3,7] : phi = 0\n'), ...
    sprintf('# Neumann boundary condition on boundary [20]\n'), ...
    sprintf('#    * on [20] : sigma d(phi)/dn = 0\n'), ...
    S, ...
    sprintf('# Mesh : gmsh.buildmesh2d(''%s.geo'',N)\n',geofile), ...
    S];
  if verbose==-1, bvp=strpres;info=mfilename();return;end % uses in fc_vfemp1.examples.bench function 
  if verbose>=1
    fprintf(strpres);
    if verbose==10, return;end
  end
  if verbose>=2,fprintf('*** Building the mesh using GMSH\n  -> from %s.geo\n',geofile);end
  tstart=tic();
  meshfile=gmsh.buildmesh(fullgeofile,N,'d',d,'meshdir',R.meshdir,'verbose',verbose);%,'force',true),'geodir',R.geodir
  Th=siMesh(meshfile,'dim',2,'format','gmsh');
  tcpu(1)=toc(tstart);
  if verbose>=2
    fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());
    fprintf('*** Setting %s\n',name);
  end
  tstart=tic();
  Lop=Loperator(dim,d,{sigma2,0;0,sigma2},[],[],[]);
  pde=PDE(Lop);
  bvp=BVP(Th,pde);
  Lop=Loperator(dim,d,{sigma1,0;0,sigma1},[],[],[]);
  pde=PDE(Lop);
  bvp.setPDE(2,10,pde);
  bvp.setDirichlet( 1, 12);
  bvp.setDirichlet( 3, 0);
  bvp.setDirichlet( 5, 12);
  bvp.setDirichlet( 7, 0);
  tcpu(2)=toc(tstart);
%    
  info.name=name;
  info.tcpu=tcpu;
  info.sigma1=R.sigma1;
  info.sigma1=R.sigma2;
  info.tname={'GMSH','Setting_BVP'};
  info.presentation=strpres;
end
