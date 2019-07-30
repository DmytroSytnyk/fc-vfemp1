function init(varargin)
% FUNCTION fc_vfemp1.init()
%   Initializes the toolbox/package .
%
% <COPYRIGHT>
  p = inputParser;
  p.KeepUnmatched=true;
  p.addParamValue('verbose', 1, @(x) ismember(x,0:2) ); % level of verbosity 
  p.parse(varargin{:});
  R=p.Results;verbose=R.verbose;
  if isOctave()
    warning('off','Octave:shadowed-function')
    more off
  end
  env=fc_vfemp1.environment();
  if isdir(env.simesh_dir), addpath(env.simesh_dir);end
  try
    fc_simesh.init(varargin{:})
  catch ME
    fprintf('[fc-vfemp1] Unable to load the fc-simesh toolbox!\n')
    fprintf('[fc-vfemp1] Use fc_vfemp1.configure(''simesh_dir'',''<PATH>'') to correct this issue\n')
    rethrow(ME)
  end
  
  if verbose==2
    graphics=fc_tools.utils.is_fcPackage('graphics4mesh');
    fprintf('[fc-vfemp1] Using fc-vfemp1 package/toolbox [%s]:\n',fc_vfemp1.version());
    fprintf('  -> %20s %s\n','fc-tools',fc_tools.version());
    fprintf('  -> %20s %s\n','fc-hypermesh',fc_hypermesh.version());
    fprintf('  -> %20s %s\n','fc-oogmsh',fc_oogmsh.version());
    fprintf('  -> %20s %s\n','fc-mesh',fc_mesh.version());
    if is_fcPackage('graphics4mesh')
      fprintf('  -> %20s %s\n','fc-graphics4mesh',fc_graphics4mesh.version());
      fprintf('  -> %20s %s\n','fc-siplt',fc_siplt.version());
    end
  end
  
  if p.Results.verbose>0
    fprintf('Using fc-vfemp1 toolbox [%s]:\n',fc_vfemp1.version());
  end
end  

function bool=isOctave()
  log=ver;bool=strcmp(log(1).Name,'Octave');
end
