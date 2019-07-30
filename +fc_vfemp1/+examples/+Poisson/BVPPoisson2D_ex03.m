fc_tools.utils.cleaning()

N=50;verbose=2;

[bvp,info]=fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex03(N,verbose);

[U,errors]=fc_vfemp1.examples.genSolveScalarBVP(bvp,info,verbose);

if fc_tools.utils.is_fcPackage('siplt')
  fc_vfemp1.examples.genPlotScalarBVP(bvp,info,U,'Poisson2d[ex03]',verbose)
end
