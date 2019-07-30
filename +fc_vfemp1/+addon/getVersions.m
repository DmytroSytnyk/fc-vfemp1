function varargout=getVersions(name)
  urlbase=fc_vfemp1.addon.getUrl();
  urlfile=[urlbase,name,filesep,'depedency'];
  urlwrite(urlfile,'depedency');
  fid=fopen('depedency','r');
  assert(fid>0, sprintf('Unable to read <depedency> file') )
  L=fgetl(fid);
  assert(strcmp(L(1:3),'###'),sprintf('Trouble with <depedency> file! First line must start with "###"'))
  i=1;
  V={};
  while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    tline=strtrim(tline);
    if (tline(1)~='#')
      S=strsplit(tline,':');
      assert(length(S)==2)
      v=S{1};
      C=strsplit(S{2},',');
      V{i}.version=v;
      V{i}.compatibility=C;
      i=i+1;
    end
  end
  fclose(fid);
  delete('depedency')
  assert(length(V)>0)
  if nargout==0
    printVersions(name,V)
    return
  end
  if nargout==1
    varargout{1}=V;
  end
end

function printVersions(name,V)
  for i=1:length(V)
    fprintf('[fc-vfemp1] addon %s version %s\n',name,V{i}.version)
    fprintf('    -> Compatibility with fc-vfemp1 versions : ')
    fprintf(' %s ',V{i}.compatibility{:})
    fprintf('\n')
  end
end