function M = DAssemblyP1_OptV3new(Th,Op,varargin)
% A supprimer
  %
  assert( strcmp(class(Op),'Loperator') );
  assert( strcmp(class(Th),'siMeshElt') );
  assert(Th.d==Op.d);
  p = inputParser;
  %p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
  p.parse(varargin{:});
  R=p.Results;
  Kg=FEM.KgP1_OptV3(Th,Op);
  if R.local
    ndof=Th.nq;
    [Ig,Jg]=FEM.IgJgP1_OptV3(Th.d,Th.nme,Th.me);
  else
    ndof=Th.nqParent;
    [Ig,Jg]=FEM.IgJgP1_OptV3(Th.d,Th.nme,Th.toParent(Th.me));
  end
  M=sparse(Ig(:),Jg(:),Kg(:),ndof,ndof);
end
