fc_tools.utils.cleaning()
N=10;
options={'perm',@(A) colamd(A)};
[bvp,info]=fc_vfemp1.examples.setBVPfunny2D01(N,2);
fc_vfemp1.examples.print_info(info)

fprintf('*** Solving %s\n',info.name)
[U,SolveInfo]=bvp.solve('split',true,'time',true,options{:});
fprintf('    -> ndof (number of degrees of freedom) = %d\n',sum(cellfun(@(x) size(x,1),U)));
fc_vfemp1.examples.print_info(SolveInfo)

if fc_tools.utils.is_fcPackage('siplt')
  fprintf('*** Graphics with fc_siplt package\n');
  tstart=tic();
  Th=bvp.Th;
  options=fc_tools.graphics.DisplayFigures('nfig',2); % To present 'nicely' the 2 figures
  figure(1)
  fc_siplt.plot(Th,U{1})
  axis image;axis off;shading interp
  colorbar
  figure(2);
  fc_siplt.plot(Th,U{2})
  axis image;axis off;shading interp         
  colorbar 
  tcpu=toc(tstart);
  fprintf('    -> Done it in %.3f(s)\n',tcpu)
end
