function [U,errors]=genSolveScalarBVP(bvp,info,verbose,varargin)
if verbose>=2, fprintf('*** Solving B.V.P. problem\n');end
tstart=tic();
U=bvp.solve(varargin{:});
tcpu=toc(tstart);
if verbose>=2
  fprintf('  -> ndof (number of degrees of freedom) = %d\n',length(U));
  fprintf('  -> solved in %.3f(s)\n',tcpu);
end

errors=[];
is_solex=false;
if isfield(info,'solex')
  if ~isempty(info.solex)
    is_solex=true;
    errors=FEM.errors(bvp.Th,U,info.solex);
    if verbose>=2
      fprintf('*** Computation errors\n');
      fprintf('  -> rel. Inf. error : %.4e\n',errors(1));
      fprintf('  -> rel. L2 error   : %.4e\n',errors(2));
      fprintf('  -> rel. H1 error   : %.4e\n',errors(3));
    end
  end
end

end
