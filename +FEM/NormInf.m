function NInf = NormInf(Th,V,varargin)
  assert( strcmp(class(Th),'siMeshElt') || strcmp(class(Th),'siMesh') )
  p = inputParser;
  p.addParameter('Num',1);
  p.parse(varargin{:});
  Num=p.Results.Num;
  if iscell(V)
    m=length(V);NInf=0;
    for i=1:m
      assert(length(V{i})==Th.nq)
      Vi=V{i};
      NInf=max(NInf,norm(Vi,Inf));
    end
  else
    m=fix(length(V)/Th.nq);
    assert(m*Th.nq==length(V));
    NInf=0;I=[1:Th.nq]';VFInd=FEM.getVFindices(Num,m,Th.nq);
    for i=1:m
      Vi=V(VFInd(I,i));
      NInf=max(NInf,norm(Vi,Inf));
    end
  end
end