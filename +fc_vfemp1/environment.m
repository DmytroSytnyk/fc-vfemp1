function env=environment(varargin)
% FUNCTION env=fc_vfemp1.environment()
%   Retrieves the toolbox/package environment directories.
%
% <COPYRIGHT>

  [conffile,isFileExists]=fc_vfemp1.getLocalConfFile();
  if ~isFileExists
    fprintf('Try to use default parameters!\n Use fc_vfemp1.configure to configure.\n')
    fc_vfemp1.configure();
  end
  run(conffile);
  env.simesh_dir=simesh_dir; % fc-simesh toolbox path
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end-1)-1));
  env.Path=Path; % current toolbox path
  env.addon=[Path,filesep,'+fc_vfemp1',filesep,'+addon'];
end
