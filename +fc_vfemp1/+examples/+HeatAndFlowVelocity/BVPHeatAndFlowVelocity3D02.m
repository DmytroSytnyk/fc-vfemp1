fc_tools.utils.cleaning()

dim=3;d=3;m=4;N=20;
geofile=fc_vfemp1.get_geo(dim,d,'cylinderkey.geo');

solver=@(A,b) minres(A,b,1e-6,400);

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
Th=siMesh(meshfile);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)
fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());

fprintf('*** Setting 3D potential velocity/flow BVP\n');
tstart=tic();
Hop=Hoperator(dim,d,m);
Hop.set(1,2,Loperator(dim,d,[],{-1,0,0},[],[]));
Hop.set(1,3,Loperator(dim,d,[],{0,-1,0},[],[]));
Hop.set(1,4,Loperator(dim,d,[],{0,0,-1},[],[]));
Hop.set(2,1,Loperator(dim,d,[],[],{-1,0,0},[]));
Hop.set(2,2,Loperator(dim,d,[],[],[],1));
Hop.set(3,1,Loperator(dim,d,[],[],{0,-1,0},[]));
Hop.set(3,3,Loperator(dim,d,[],[],[],1));
Hop.set(4,1,Loperator(dim,d,[],[],{0,0,-1},[]));
Hop.set(4,4,Loperator(dim,d,[],[],[],1));
bvpPotentials=BVP(Th,PDE(Hop));
bvpPotentials.setDirichlet(1020,-1,1);
bvpPotentials.setDirichlet(1021,1,1);
bvpPotentials.setDirichlet(2020,-1,1);
bvpPotentials.setDirichlet(2021,1,1);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Solving 3D potential velocity/flow BVP\n')%,'solver',solver);
[W,SolveInfo]=bvpPotentials.solve('split',true,'time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',sum(cellfun(@(x) size(x,1),W)));
fc_vfemp1.examples.print_info(SolveInfo)

fprintf('*** Setting 3D stationary heat BVP with potential flow\n');
tstart=tic();
Lop=Loperator(dim,d,{af,[],[];[],af,[];[],[],af},[],{W{2},W{3},W{4}},b);
bvpHeat=BVP(Th,PDE(Lop));
bvpHeat.setDirichlet(1020,30.);
bvpHeat.setDirichlet(2020,30.);
bvpHeat.setDirichlet(10, gD10);
fprintf('*** Solving 3D stationary heat BVP with potential flow\n');
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Solving 3D stationary heat BVP with potential flow\n');
[u,SolveInfo2]=bvpHeat.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(u));
fc_vfemp1.examples.print_info(SolveInfo2)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  fc_vfemp1.examples.HeatAndFlowVelocity.plots3D(Th,u,W{1},{W{2},W{3},W{4}})
  
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
