function [Ig,Jg]=IgJgP1_OptV3(d,nme,me)
% ndfe=d+1   
% Ig, Jg : ndfe-by-ndfe-by-nme
  ndfe=d+1;
  Ig=zeros(nme,ndfe,ndfe);
  Jg=zeros(nme,ndfe,ndfe);
  for il=1:ndfe
    mel=me(il,:);
    for jl=1:ndfe
      Ig(:,il,jl)=mel;
      Jg(:,jl,il)=mel;
    end
  end
end