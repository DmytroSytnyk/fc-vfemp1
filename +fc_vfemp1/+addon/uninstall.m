function uninstall(varargin)
% 'mfile' 
% install('name','eigs')
  assert(nargin>=2)
  p = inputParser; 
  p.addParamValue('name', '', @ischar );
  p.addParamValue('verbose',false, @islogical );
  p.addParamValue('full',false, @islogical ); % suppress addon <name> directory
  p.parse(varargin{:});
  R=p.Results;
  isOctave=fc_tools.comp.isOctave();
  try
    eval(sprintf('ver=fc_vfemp1.addon.%s.version();',R.name))
  catch
    fprintf('[fc-vfemp1] addon <%s> not found!\n',R.name)
    return
  end
  
  fullname=mfilename('fullpath');
  I=strfind(fullname,filesep);
  Path=fullname(1:(I(end)-1));
  filename=[Path,filesep,R.name,'-filelist']
  if ~exist(filename,'file')
    fprintf('[fc-vfemp1] Missing file for uninstalling addon <%s>:\n   -> %s\n',R.name,filename)
    return
  end
  fprintf('[fc-vfemp1] Deleting files for uninstalling addon <%s>\n',R.name)
  fid=fopen(filename,'r');
  while 1
    tline=getl(fid);
    if ~ischar(tline), break,end
    if R.verbose, fprintf('   -> %s\n',tline);end      
    delete(tline)
  end  
  fclose(fid)
  if R.verbose, fprintf('   -> %s\n',filename);end      
  delete(filename)
  fprintf('[fc-vfemp1] Deleting directory for uninstalling addon <%s>\n',R.name)
  if R.full
    dirname=[Path,filesep,R.name];
    if R.verbose, fprintf('   -> %s\n',dirname);end
    rmdir(dirname,'s')
  end
end
