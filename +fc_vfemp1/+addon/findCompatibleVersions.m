function Versions=findCompatibleVersions(name)
  V=fc_vfemp1.addon.getVersions(name);
  Versions={};
  ver=fc_vfemp1.version();
  k=1;
  for i=1:length(V)
    if ismember(ver,V{i}.compatibility)
      Versions{k}=V{i}.version;k=k+1;
    end
  end
  if k==1
    fprintf('[fc-vfemp1] No compatible version found for addon %s with fc-vfemp1 %s\n',name,ver)
  else
    Versions=sort(Versions);
  end
end