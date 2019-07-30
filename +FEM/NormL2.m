function [NL2,varargout] = NormL2(Th,V,varargin)
  assert( strcmp(class(Th),'siMeshElt') || strcmp(class(Th),'siMesh') )
  p = inputParser;
  p.addParameter('Mass',[]);
  p.addParameter('Num',1);
  p.parse(varargin{:});
  M=p.Results.Mass;Num=p.Results.Num;
  if isempty(M), M=FEM.DAssemblyP1_OptV3(Th,Loperator(Th.dim,Th.d,[],[],[],1)); end
  if iscell(V)
    m=length(V);NL2=0;
    for i=1:m
      assert(length(V{i})==Th.nq)
      Vi=V{i};
      NL2=NL2+dot(M*Vi,Vi);
    end
    NL2=sqrt(NL2);
  else
    m=fix(length(V)/Th.nq);
    assert(m*Th.nq==length(V));
    NL2=0;I=[1:Th.nq]';VFInd=FEM.getVFindices(Num,m,Th.nq);
    for i=1:m
      Vi=V(VFInd(I,i));
      NL2=NL2+dot(M*Vi,Vi);
    end
    NL2=sqrt(NL2);
  end
  if nargout==2, varargout{1}=M;end
end