function varargout=solve(self,varargin) 
% Optional key/value parameters:
%   'solver' :
%         @(A,b) gmres(A,b,10,1e-12,100)
%      default, @mldivide
  p = inputParser;
  p.addParamValue('solver',@mldivide,@(f) strcmp(class(f),'function_handle'));
  p.addParamValue('perm',[],@(f) strcmp(class(f),'function_handle') || isempty(f));
  p.addParamValue('local',true,@islogical);
  p.addParamValue('verbose',0,@isscalar);
  p.addParamValue('split',false,@islogical);
  p.addParamValue('time',false,@islogical);
  %p.addParamValue('info',false,@islogical);
  p.parse(varargin{:});
  R=p.Results;
  funsolve=p.Results.solver;
  perm=p.Results.perm;
  tstart=tic();  [Ag,bg]=self.Assembly('local',p.Results.local);  tcpu(1)=toc(tstart);
  tname{1}='Assembly';
  nout_solve=nargout-p.Results.time;
  assert(nout_solve>=1,'With time option 2 output are required')
  
  if fc_tools.comp.isOctave(), varargout=cell(1,nargout); end % Needed by Octave
  if isempty(perm)
      tstart=tic();  varargout{1:nout_solve}=funsolve(Ag,bg);  tcpu(2)=toc(tstart);
%        res=norm(Ag*varargout{1}-bg,Inf);
%        if p.Results.verbose>0
%          fprintf('[fc-vfemp1] BVP.solve, residu : %.16f\n',res)
%        end
  else
    tstart=tic();
    pe=perm(Ag);
    varargout{1:nout_solve}=funsolve(Ag(pe,pe),bg(pe));
    varargout{1}(pe)=varargout{1};
    tcpu(2)=toc(tstart);
  end
  tname{2}='Solve';

  if p.Results.time
    solveInfo.tcpu=tcpu;solveInfo.tname=tname;solveInfo.solver=fc_tools.utils.fun2str(funsolve);
    solveInfo.matrixsize=size(Ag);solveInfo.residu=norm(Ag*varargout{1}-bg,Inf);
    solveInfo.nnz=nnz(Ag);
%    isfield(info
    
    varargout{nargout}=solveInfo;
  end
  if p.Results.split
    varargout{1}=self.splitsol(varargout{1});
  end
end
