function D=get_geodirs(dim,d)
  s=get_pathname(dim,d);
  assert(~isempty(s),'Unable to find geo directory for dim=%d and d=%d',dim,d)
  env=fc_vfemp1.environment();
  loc_dir=fullfile(env.Path,'geodir',s);
  D=fc_simesh.get_geodirs(dim,d);
  D={loc_dir,D{:}};
end

function s=get_pathname(dim,d)
  if dim==2 && d==2
    s='2d';
    return
  end
  if dim==3 && d==2
    s='3ds';
    return
  end
  if dim==3 && d==3
    s='3d';
    return
  end
  s=[];
end