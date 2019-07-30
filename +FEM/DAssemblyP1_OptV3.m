function M=DAssemblyP1_OptV3(Th,Op,nq)
  %
  assert( strcmp(class(Op),'Loperator') );
  if strcmp(class(Th),'siMeshElt')
    assert(Th.d==Op.d);
    Kg=FEM.KgP1_OptV3(Th,Op);
    if nargin<=2
      nq=Th.nq;
      [Ig,Jg]=FEM.IgJgP1_OptV3(Th.d,Th.nme,Th.me);
    else
      if nq==Th.nq
        [Ig,Jg]=FEM.IgJgP1_OptV3(Th.d,Th.nme,Th.me);
      else
        [Ig,Jg]=FEM.IgJgP1_OptV3(Th.d,Th.nme,Th.toGlobal(Th.me));
      end
    end
    M=sparse(Ig(:),Jg(:),Kg(:),nq,nq);
  elseif strcmp(class(Th),'siMesh')
    iSub=Th.find(Op.d);
    M=sparse(Th.nq,Th.nq);
    for i=iSub
      M=M+FEM.DAssemblyP1_OptV3(Th.sTh{i},Op,Th.nq);
    end
  else
    error('Unknow class %s',class(Th))
  end
end
