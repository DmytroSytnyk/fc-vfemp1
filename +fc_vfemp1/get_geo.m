function fullgeofile=get_geo(dim,d,geofile)
  [PATHSTR,NAME,EXT] = fileparts(geofile);
  assert(strcmp(EXT,'.geo') || isempty(EXT), 'Extension must be .geo in %s',geofile)
  if ~isempty(PATHSTR)
    assert(fc_tools.sys.isfileexists(geofile),'Unable to open geofile %s',geofile)
    fullgeofile=geofile;
    return
  end
  D=fc_vfemp1.get_geodirs(dim,d);
  for i=1:length(D)
    file=fullfile(D{i},[NAME,'.geo']);
    if fc_tools.sys.isfileexists(file)
      fullgeofile=file;
      return
    end
  end
  fullgeofile=[];
  return
end
