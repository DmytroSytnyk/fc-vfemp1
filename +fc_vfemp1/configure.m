function varargout=configure(varargin)
% FUNCTION fc_vfemp1.configure()
%   Configures the toolbox/package by setting <fc-simesh> toolbox directory.
%   Theses informations will be stored in ... file.
%
% <COPYRIGHT>
  [conffile,isFileExists]=fc_vfemp1.getLocalConfFile();
  if isFileExists
    run(conffile);
  else
    fullname=mfilename('fullpath');
    I=strfind(fullname,filesep);
    Path=fullname(1:(I(end-1)-1));
    simesh_dir='';    % empty if pkg or toolbox in path
  end
  p = inputParser;
  p.addParamValue('simesh_dir'   ,simesh_dir,@ischar);
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.parse(varargin{:});
  R=p.Results;verbose=R.verbose;
 
  simesh_dir=get_tbxpath('simesh','vfemp1',R.simesh_dir);
  
  vprintf(verbose,1,'[fc-vfemp1] Writing in %s\n',conffile);
  fid=fopen(conffile,'w');
  if (fid==0), error('Unable to open file :\n %s\n',conffile);end
  fprintf(fid,'%% Automaticaly generated with fc_vfemp1.configure()\n');
  fprintf(fid,'simesh_dir=''%s'';\n',simesh_dir);
  fclose(fid);
  vprintf(verbose,2,'  -> done\n');
  vprintf(verbose,2,'[fc-vfemp1] configured with\n');
  vprintf(verbose,2,'   -> simesh_dir     =''%s'';\n',simesh_dir);
  vprintf(verbose,2,'[fc-vfemp1] done\n');
  if nargout==1,varargout{1}=conffile;end
  rehash;
end

%
% DO NOT MODIFY THIS FUNCTION: IT IS AUTOMATICALLY ADDED
%
function tbxpath=get_tbxpath(tbxname,tbxfrom,givenpath,varargin) % tbxname is the toolbox to 'include' in the toolbox <tbxfrom>
  p = inputParser;
  p.addParamValue('stop'   ,true,@islogical);
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.parse(varargin{:});
  stop=p.Results.stop;verbose=p.Results.verbose;
  tbxpath='';
  if ~isempty(givenpath) 
    if ~isdir(givenpath) 
      vprintf(verbose,2,'[fc-%s] The given path does not exists:\n   -> %s\n',tbxfrom,tbxname,givenpath)
      vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname)
      if stop
        error(sprintf('fc-%s::configure',tbxfrom))
      else
        warning(sprintf('fc-%s::configure',tbxfrom))
      end
    end
    tbxpath=givenpath;
    addpath(tbxpath);rehash path;
    failed=false;
    try % check if the toolbox can be found
      eval(sprintf('fc_%s.version();',tbxname))
    catch
      vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in given path:\n  %s\n',tbxfrom,tbxname,tbxpath)
      if stop
        error(sprintf('fc-%s::configure',tbxfrom),'step 1')
%        else
%          warning(sprintf('fc-%s::configure',tbxfrom),'step 1')
      end
      failed=true;
    end
    rmpath(tbxpath);rehash path;
    if ~failed, return;end
  end
  failed=false;
  try % check if the toolbox is in current Matlab path
    eval(sprintf('fc_%s.version();',tbxname))
  catch
    vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in current path\n',tbxfrom,tbxname)
    failed=true;
  end
  if ~failed, return;end
  failed=false;
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end-2)-1));
  
  lstdir=dir(Path); % try to guess directory. I don't use dir command due to trouble with octave
  C=arrayfun(@(x) x.name,lstdir, 'UniformOutput', false);
  I=strfind(C,['fc-',tbxname]);
  i=find(cellfun(@(x) ~isempty(x),I)==1);
  if ~isempty(i)
    k=1;
    while k<=length(i)
      tbxpath=[Path,filesep,C{i(k)}];
      addpath(tbxpath);rehash path;
      try % check if the toolbox is in new current Matlab path
        eval(sprintf('fc_%s.version();',tbxname))
      catch
        failed=true;
        vprintf(verbose,2,'[fc-%s] Unable to load the fc-%s toolbox/package in guess path\n  %s\n',tbxfrom,tbxname,tbxpath)
        vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname)
        if stop
          error(sprintf('fc-%s::configure',tbxfrom),'step 2')
%          else
%            warning(sprintf('fc-%s::configure',tbxfrom),'step 2')
        end
      end
      rmpath(tbxpath);rehash path;
      if ~failed
        vprintf(verbose,2,'[fc-%s] Loading the fc-%s toolbox/package in guess path\n  %s\n',tbxfrom,tbxname,tbxpath)
        return;
      end
      k=k+1;
    end
  else
    vprintf(verbose,2,'[fc-%s] Guess path does not exists:\n   -> %s\n',tbxfrom,tbxname,tbxpath)
    vprintf(verbose,2,'[fc-%s] Use fc_%s.configure(''fc_%s_dir'',<DIR>) to correct this issue\n\n',tbxfrom,tbxfrom,tbxname);
    if stop
      error(sprintf('fc-%s::configure',tbxfrom),'step 3')
%      else
%        warning(sprintf('fc-%s::configure',tbxfrom),'step 3')
    end
    failed=true;
  end
  if failed
      tbxpath='';
  else
    vprintf(verbose,2,'[fc-%s] fc-%s toolbox/package found in path:\n   -> %s\n',tbxfrom,tbxname,tbxpath)
  end
end

function vprintf(verbose,level,varargin)
  if verbose>=level, fprintf(varargin{:});end
end

