fc_tools.utils.cleaning()

%
N=20;dim=3;d=3;
geofile=fc_vfemp1.get_geo(dim,d,'cylinderkey.geo');

af=@(x,y,z) 1+(z-1).^2;
gD10=@(x,y,z) 10*(abs(z-1)>0.5);
b=0.01;

fprintf('------------------------------------------------------\n'); 
fprintf('      3D stationary heat and flow velocity BVPs\n');
fprintf('         on GMSH mesh from %s.geo\n\n',geofile);
fprintf(' 1) 3D velocity potential BVP, (unknow phi)\n')
fprintf('               - Laplacian phi = 0\n')
fprintf('    and boundary conditions :\n');
fprintf('      * Dirichlet on [1020,1021,2020,2021]\n');
fprintf('          phi = -1 on [1020,2020], 1 on [1021,2021]\n');
fprintf('      * Neumann on [1,10,11,31,1000,2000]\n');
fprintf('          du/dn = 0 \n');
fprintf('    (Velocity V = grad phi ) \n');
fprintf(' 2) 3D stationary heat with potential flow BVP, (unknow u)\n')
fprintf('               - div(a grad u) + <V,grad u> + b u = f\n')
fprintf(' and boundary conditions :\n');
fprintf('   * Dirichlet on [10,1020,2020]\n');
fprintf('       u = gD on [10], 30 on [1020,2020]  \n');
fprintf('   * Neumann on [1,11,31,1000,1021,2000,2021]\n');
fprintf('       du/dn = 0 \n');
fprintf(' with \n');
fprintf('   a = %s \n',fc_tools.utils.fun2str(af));
fprintf('   b = %s \n',fc_tools.utils.fun2str(b));
fprintf('   gD = %s \n',fc_tools.utils.fun2str(gD10));
fprintf('------------------------------------------------------\n');


fprintf('*** Building the mesh using GMSH\n');
tstart=tic();
meshfile=gmsh.buildmesh(geofile,N,'d',d);
Th=siMesh(meshfile,'dim',3);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)
fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());

fprintf('*** Setting 3D potential velocity/flow BVP\n');
tstart=tic();
Lop=Loperator(dim,d, {1,[],[];[],1,[];[],[],1},[],[],[]);
bvpFlow=BVP(Th,PDE(Lop));
bvpFlow.setDirichlet(1021,1.);
bvpFlow.setDirichlet(2021,1.);
bvpFlow.setDirichlet(1020,-1.);
bvpFlow.setDirichlet(2020,-1.);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Solving 3D potential velocity/flow BVP\n')
[Phi,SolveInfo]=bvpFlow.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(Phi));
fc_vfemp1.examples.print_info(SolveInfo)

fprintf('*** Computing 3D velocity flow from potential velocity\n');
tstart=tic();
V=cell(1,3);
Lop=Loperator(dim,d,[],[],{1,0,0},[]); 
V{1}=Lop.apply(Th,Phi);
Lop=Loperator(dim,d,[],[],{0,1,0},[]);
V{2}=Lop.apply(Th,Phi);
Lop=Loperator(dim,d,[],[],{0,0,1},[]);
V{3}=Lop.apply(Th,Phi);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Setting 3D stationnary heat BVP with potential flow\n');
tstart=tic();
Lop=Loperator(dim,d, {af,[],[];[],af,[];[],[],af},[], {V{1},V{2},V{3}},b);
bvpHeat=BVP(Th,PDE(Lop));
bvpHeat.setDirichlet(1020,30.);
bvpHeat.setDirichlet(2020,30.);
bvpHeat.setDirichlet(10, gD10);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Solving 3D stationnary heat BVP with potential flow\n');
[u,SolveInfo2]=bvpHeat.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(u));
fc_vfemp1.examples.print_info(SolveInfo2)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  fc_vfemp1.examples.HeatAndFlowVelocity.plots3D(Th,u,Phi,V)
  
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
