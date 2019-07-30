function install(varargin)
% 'mfile' 
% install('name','eigs')
  assert(nargin>=2)
  p = inputParser; 
  p.addParamValue('name', '', @ischar );
  p.addParamValue('version', '', @ischar );
%  p.addParamValue('url', '', @ischar );
%  p.addParamValue('mfile','' , @ischar );
  p.parse(varargin{:});
  R=p.Results;
  Versions=fc_vfemp1.addon.findCompatibleVersions(R.name);
  if isempty(Versions), fprintf('[fc-vfemp1] Addon %s installation failed!',R.name);return;end
  if ~isempty(R.version)
    if ismember(R.version,Versions)
      version=R.version;
    else
      fprintf('[fc-vfemp1] Addon %s version %s not compatible with fc-vfemp1 version %s!',R.name,R.version,fc_vfemp1.version());return;
    end
  else
    version=Versions{end};
  end
  isOctave=fc_tools.comp.isOctave();
  if isOctave
    base=sprintf('ofc-vfemp1-%s-%s',R.name,version);
  else
    base=sprintf('mfc-vfemp1-%s-%s',R.name,version);
  end
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end)-1));
  filename=[Path,filesep,R.name,'-filelist']
  
  alreadyinstalled=true;
  try
    eval(sprintf('ver=fc_vfemp1.addon.%s.version();',R.name))
  catch
    alreadyinstalled=false;
  end
  if alreadyinstalled
    fprintf('[fc-vfemp1] Addon %s version %s already installed!\n',R.name,ver)
    return
  end
  
  urlbase=fc_vfemp1.addon.getUrl();
  urlfile=[urlbase,R.name,filesep,version,filesep,base,'.tar.gz'];
  env=fc_vfemp1.environment();
  try
    filelist=untar(urlfile,env.Path);
  catch
    error('Unable to get :\n  -> %s\n',urlfile);
  end
    
  filename=[Path,filesep,R.name,'-filelist']
  fid=fopen(filename,'w');
  for i=1:length(filelist)
    fprintf(fid,'%s\n',filelist{i});
  end
  fclose(fid)
  fprintf('[fc-vfemp1] uninstall file list for addon %s written in\n    -> %s\n',R.name,filename)
  
  if isOctave
    % rehash not works
    fprintf('\n*** Needs restart Octave for using <%s> add-on! ***\n',R.name)
  else
    eval(['Ver=fc_vfemp1.addon.',R.name,'.version();']);
    fprintf('Addon %s version %s successfully installed\n',R.name,Ver);
  end
end
