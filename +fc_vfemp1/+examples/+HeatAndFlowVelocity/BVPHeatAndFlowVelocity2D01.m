fc_tools.utils.cleaning()

dim=2;d=2;
N=120;

af=@(x,y) 0.1+y.^2;
gD=@(x,y) 20*y;
b=0.01;
geofile=fc_vfemp1.get_geo(2,2,'disk5holes.geo');

fprintf('------------------------------------------------------\n'); 
fprintf('      2D stationary heat and flow velocity BVPs\n');
fprintf('         on GMSH mesh from %s.geo\n\n',geofile);
fprintf(' 1) 2D velocity potential BVP, (unknow phi)\n')
fprintf('               - Delta phi = 0\n')
fprintf('    and boundary conditions :\n');
fprintf('      * Dirichlet on [20,21]\n');
fprintf('          phi = -20 on [21], 20 on [20]\n');
fprintf('      * Neumann on [1,22,23]\n');
fprintf('          du/dn = 0 on [1,22,23]\n');
fprintf('    (Potential flow V = grad phi ) \n');
fprintf(' 2) 2D stationary heat with potential flow BVP, (unknow u)\n')
fprintf('               - div(a grad u) + <V,grad u> + b u = f\n')
fprintf(' and boundary conditions :\n');
fprintf('   * Dirichlet on [21,22,23]\n');
fprintf('       u = gD on [21], 0 on [22] and 0 on [23]  \n');
fprintf('   * Neumann on [1,10,20]\n');
fprintf('       du/dn = 0 on [1,10,20]\n');
fprintf(' with \n');
fprintf('   a = %s \n',fc_tools.utils.fun2str(af));
fprintf('   b = %g \n',b);
fprintf('   gD = %s \n',fc_tools.utils.fun2str(gD));
fprintf('------------------------------------------------------\n');

fprintf('*** Building the mesh using GMSH\n');
tstart=tic();
meshfile=gmsh.buildmesh(geofile,N,'d',d);
Th=siMesh(meshfile);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)
fprintf('    -> Mesh sizes : nq=%d, nme=%d, h=%.3e\n',Th.nq,Th.get_nme(),Th.get_h());

fprintf('*** Setting 2D velocity potential BVP\n');
tstart=tic();
d=2;  
Lop=Loperator(d,d,{1,[];[],1},[],[],[]);
bvpPotential=BVP(Th,PDE(Lop));
bvpPotential.setDirichlet(20,20);
bvpPotential.setDirichlet(21,-20);
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Solving 2D velocity potential BVP\n')
[phi,SolveInfo]=bvpPotential.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(phi));
fc_vfemp1.examples.print_info(SolveInfo)

fprintf('*** Computing 2D potential flow from velocity potential\n');
tstart=tic();
Hop=Hoperator(Th.dim,d,d);
Hop.H{1,1}=Loperator(d,d,[],[],{1,0},[]);
Hop.H{2,2}=Loperator(d,d,[],[],{0,1},[]);
V=Hop.apply(Th,{phi,phi});
tcpu=toc(tstart);
fprintf('    -> Done it in %.3f(s)\n',tcpu)

fprintf('*** Setting 2D stationary heat BVP with potential flow\n');
tstart=tic();
Lop=Loperator(d,d,{af,[];[],af},[],V,b);
bvpHeat=BVP(Th,PDE(Lop));
bvpHeat.setDirichlet(21,gD);
bvpHeat.setDirichlet(22, 0);
bvpHeat.setDirichlet(23, 0);
fprintf('*** Solving 2D stationary heat BVP with potential flow\n');
[u,SolveInfo2]=bvpHeat.solve('time',true);
fprintf('    -> ndof (number of degrees of freedom) = %d\n',length(u));
fc_vfemp1.examples.print_info(SolveInfo2)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  
  fc_vfemp1.examples.HeatAndFlowVelocity.plots2D(Th,u,phi,V)
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
