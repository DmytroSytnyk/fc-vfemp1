fc_tools.utils.cleaning()
N=300;

[bvp,info]=fc_vfemp1.examples.elasticity.setBVPElasticity2D_ex01(N,2);
fprintf('*** Solving 2D Elasticity B.V.P. problem\n');
U=bvp.solve('split',true);
E=FEM.errors(bvp.Th,U,info.solex);
fprintf('*** Relative Errors\n');
fprintf('    -> Norm Inf: %.4e\n',E(1));
fprintf('    -> Norm L2 : %.4e\n',E(2));
fprintf('    -> Norm H1 : %.4e\n',E(3));

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphic representations\n');
  ctitle={'u_1 error','u_2 error'};
  Th=bvp.Th;
  for i=1:2
    figure(i)
    fc_siplt.plot(Th,abs(U{i}-Th.eval(info.solex{i})))
    axis off;axis image
    shading interp
    colorbar
    title(ctitle{i})
  end
  ctitle={'u_1','u_2'};
  for i=1:2
    figure(i+2)
    fc_siplt.plot(Th,Th.eval(info.solex{i}))
    axis off;axis image
    shading interp
    colorbar
    title(ctitle{i})
  end
end

