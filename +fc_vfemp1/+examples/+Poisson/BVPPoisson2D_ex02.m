fc_tools.utils.cleaning()

N=100;verbose=2;

[bvp,info]=fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex02(N,verbose);

[U,errors]=fc_vfemp1.examples.genSolveScalarBVP(bvp,info,verbose);

if fc_tools.utils.is_fcPackage('siplt')
  fc_vfemp1.examples.genPlotScalarBVP(bvp,info,U,'Poisson2d[ex02]',verbose)
end
