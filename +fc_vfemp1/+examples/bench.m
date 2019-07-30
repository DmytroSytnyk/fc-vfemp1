function varargout=bench(varargin)
%
% Optional key/value parameters:
%   'LN'    : list of N value for meshing
%   'info'  : print computer informations.
%             default: true.
%   'setBVP': must be a function handle as 
%               @(N,verbose) fun(N,verbose)
%             which initialize the boundary value problem to solve.
%             default: 
%               @(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex01(N,verbose).
%   @(A,b)gmres(A,b,10,1e-12,100)
%   perm @(A) colamd(A)
%  and all optional key/value parameters of the BVP.solve function
  DateNum=now;
  p = inputParser;
  p.addParamValue('LN',10:10:50);
  %p.addParamValue('setBVP',@(N,verbose,Fprintf) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex01(N,verbose,'fprintf',Fprintf))
  %p.addParamValue('setBVP',@(N,verbose,varargin) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex01(N,verbose,varargin{:}))
  p.addParamValue('setBVP',@(N,verbose) fc_vfemp1.examples.Poisson.setBVPPoisson2D_ex01(N,verbose))
  p.addParamValue('solver',@mldivide,@(f) strcmp(class(f),'function_handle'));
  p.addParamValue('perm',[],@(f) strcmp(class(f),'function_handle') || isempty(f));
  p.addParamValue('info',true,@islogical)
  p.addParamValue('debug',true,@islogical)
  p.addParamValue('file','',@ischar)
  p.addParamValue('force',false,@islogical)
  p.addParamValue('save',false,@islogical)
  p.addParamValue('tag',false,@islogical)
  p.addParamValue('dir','',@ischar)
  p.parse(varargin{:});
  %varargin=fc_tools.utils.deleteCellOptions(varargin,p.Parameters);
  R=p.Results;
  setBVP=R.setBVP;solver=R.solver;perm=R.perm;Debug=R.debug;file=R.file;
  [str_pres,name]=setBVP(0,-1);
  if R.tag,  DN=DateNum;else DN=0;end
  
  if R.save
    dirname=R.dir;
    if isempty(dirname), dirname=autosave_dir();end
    if ~exist(dirname,'dir')
      [success,message,messageid]=mkdir(dirname);
      if success~=1
        error('Unable to create directory %s',fullfile(pwd,dirname))
      end
    end
    if isempty(file), file=fullfile(dirname,autosave_file(name,DN,solver,perm));end
  end
  
  if isempty(file)
    Fprintf=@(varargin) fprintf(varargin{:});
  else
    if fc_tools.sys.isfileexists(file)
      if ~R.force,  error('[fc-vfemp1] output file already exists : %s\n[fc-vfemp1] Use ''force'' option for overwritting\n',file);end
    end
    fid=fopen(file,'w');
    if fid==-1, error('[fc-vfemp1] Unable to create output file  : %s\n',file);end
    Fprintf=@(varargin) {fprintf(varargin{:}),fprintf(fid,varargin{:})};
  end
  
  %fprintf('Bench \n')
  
  Fprintf(str_pres);
  print_solver_info(solver,perm,Fprintf);
  Fprintf(fc_tools.utils.line_text_delimiter());
  if R.info, print_info(Fprintf);Fprintf(fc_tools.utils.line_text_delimiter());end
  LN=R.LN;
  ptitle=false;
  for N=LN
    [bvp,info]=setBVP(N,0);
    [x,solve]=bvp.solve('split',true,'time',true,'solver',solver,'perm',perm);
    if isfield(info,'solex')
      if ~isempty(info.solex)
        solve.errors=FEM.errors(bvp.Th,x,info.solex);
      end
    end
    if ~ptitle
      ptitle=true;
      L=print_title(info,solve,Debug,Fprintf,DateNum);
    end
    print_data(N,bvp.Th.nq,bvp.Th.get_nme(),bvp.Th.get_h(),info,solve,L,Debug,Fprintf);
  end
  if ~isempty(file)
    fclose(fid);
    fprintf('[fc-vfemp1] Bench output written in file: %s\n',file)
  end
  if nargout==1
    varargout{1}=fullfile(pwd,file);
  end
end

function print_solver_info(solver,perm,Fprintf)
  Fprintf('#%12s: %s\n','solver',fc_tools.utils.fun2str(solver));
  if isempty(perm), sperm='None';else sperm=fc_tools.utils.fun2str(perm);end
  Fprintf('#%12s: %s\n','perm',sperm);
end

function print_info(Fprintf)
  CPU=fc_tools.sys.getCPUinfo();
  OS=fc_tools.sys.getOSinfo();
%  fprintf('#---------------------------------------------\n')
  Fprintf('#%12s: %s\n','computer',fc_tools.sys.getComputerName());
  Fprintf('#%12s: %s (%s)\n','system',OS.description,OS.arch);
  Fprintf('#%12s: %s (%d procs/%d cores by proc/%d threads by core)\n','processor',CPU.name,CPU.nprocs,CPU.ncoreperproc,CPU.nthreadspercore);
  Fprintf('#%12s: %3.1f Go\n','RAM',fc_tools.sys.getRAM);
  Fprintf('#%12s: %s\n','software',fc_tools.sys.getSoftware());
  Fprintf('#%12s: %s\n','release',fc_tools.sys.getRelease());
%  fprintf('#---------------------------------------------\n')
end

function L=print_title(info,solve,Debug,Fprintf,DateNum)
  si=strcat(info.tname,'(s)');
  ss=strcat(solve.tname,'(s)');
  %titles={'#labels:    N','      nq','      nme',info.tname{:},solve.tname{:}};
  Fprintf('#date:%s\n',datestr(DateNum,'yyyy/mm/dd HH:MM:SS'));
  format='#format: %d %d %d';
  format=[format,repmat(' %g',1,length(si)+length(ss))];
  titles={'#labels:    N','      nq','      nme',si{:},ss{:}};
  
  if isfield(solve,'errors')
    titles={titles{:},'          h','  Linf-error','    L2-error','    H1-error'};
    format=[format,' %g %g %g %g'];
  end
  if Debug
    titles{end+1}='     Residu';
    titles{end+1}='      MatrixSize';
    titles{end+1}='          nnz';
    titles{end+1}='          ndof';
    format=[format,' %g %s %d %d'];
  end
  L=cellfun(@length,titles)+2;
  L(1)=L(1)-2;
  Fprintf('%s\n',format);
  Fprintf('%s',titles{1});
  Fprintf('  %s',titles{2:end});
  Fprintf('\n');
end

function print_data(N,nq,nme,h,info,solve,L,Debug,Fprintf)
  %
  lidx=3;
  format=sprintf('%%%dd',L(1:3));
  Fprintf(format,[N,nq,nme]);
  sidx=lidx+1;
  lidx=lidx+length(info.tcpu)+length(solve.tcpu);
  format=sprintf('%%%d.3f',L(sidx:lidx));
  Fprintf(format,[info.tcpu,solve.tcpu]);
  if isfield(solve,'errors')
    sidx=lidx+1;lidx=sidx;
    format=sprintf('%%%d.3e',L(sidx));
    Fprintf(format,h);
    sidx=lidx+1;lidx=lidx+3;
    format=sprintf('%%%d.3e',L(sidx:lidx));
    Fprintf(format,solve.errors);
  end
  if Debug
    sidx=lidx+1;lidx=sidx;
    format=sprintf('%%%d.3e',L(sidx));
    Fprintf(format,solve.residu);
    sidx=lidx+1;lidx=sidx;
    sMatSize=sprintf('%dx%d',solve.matrixsize(1),solve.matrixsize(2));
    Fprintf(sprintf('%%%ds',L(sidx)),sMatSize);
    sidx=lidx+1;lidx=sidx;
    format=sprintf('%%%dd',L(sidx));
    Fprintf(format,solve.nnz);
    sidx=lidx+1;lidx=sidx;
    format=sprintf('%%%dd',L(sidx));
    Fprintf(format,solve.matrixsize(1));
  end
  Fprintf('\n');
end

function dirname=autosave_dir()
  OS=fc_tools.sys.getOSinfo();
  host=fc_tools.sys.getComputerName();
  Soft=fc_tools.sys.getSoftware();
  Release=fc_tools.sys.getRelease();
  dirname=fullfile('benchs',[OS.shortname,'_',OS.release,'_',host],[Soft,'_',Release]);
end

function filename=autosave_file(Name,DateNum,solver,perm)
  solvername=fc_tools.utils.funHandleName(solver);
  filename=['bench_',Name,'_',solvername];
  if ~isempty(perm)
    filename=[filename,'_',fc_tools.utils.funHandleName(perm)];
  end
  if DateNum>0
  filename=[filename,'_',datestr(DateNum,'yyyy.mm.dd_HH.MM.SS')];
  end
  filename=[filename,'.out'];
end
