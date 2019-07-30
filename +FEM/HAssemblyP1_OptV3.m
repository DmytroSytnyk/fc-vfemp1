function M=HAssemblyP1_OptV3(sTh,Hop,varargin)
% Num==0 alternate basis, Num == 1 block basis
  assert( strcmp(class(Hop),'Hoperator') );
  assert( strcmp(class(sTh),'siMeshElt') );
  assert(sTh.d==Hop.d);
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
  p.addParamValue('block',false,@islogical);
  p.parse(varargin{:});
  R=p.Results;
  m=Hop.m;
  if R.local 
    nq=sTh.nq;
    [Ig,Jg]=FEM.IgJgP1_OptV3(sTh.d,sTh.nme,sTh.me);
  else 
    nq=sTh.nqGlobal;
    [Ig,Jg]=FEM.IgJgP1_OptV3(sTh.d,sTh.nme,sTh.toGlobal(sTh.me));
  end
  ndof=m*nq;d=sTh.d;
  VFInd=FEM.getVFindices(R.Num,m,nq);
  if R.block
    M=cell(m,m);
  else
    M=sparse(ndof,ndof);
  end
  %M=spalloc(ndof,ndof,4*(m*(d+1))^2*ndof);
  Ig=Ig(:);Jg=Jg(:);
  for i=1:m
    for j=1:m
      if ~isempty(Hop.H{i,j})
        Kg=FEM.KgP1_OptV3(sTh,Hop.H{i,j});
        if R.block
          M{i,j}=sparse(Ig,Jg,Kg(:),nq,nq);
        else
          M=M+sparse(VFInd(Ig,i),VFInd(Jg,j),Kg(:),ndof,ndof);
        end
      end
    end
  end
end