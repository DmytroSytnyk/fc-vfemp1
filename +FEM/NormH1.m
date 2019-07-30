function [NH1,varargout] = NormH1(Th,V,varargin)
  assert( strcmp(class(Th),'siMeshElt') || strcmp(class(Th),'siMesh') )
  p = inputParser;
  p.addParameter('Mass',[]);
  p.addParameter('Stiff',[]);
  p.addParameter('Num',1);
  p.parse(varargin{:});
  M=p.Results.Mass;K=p.Results.Stiff;Num=p.Results.Num;
  if isempty(M), M=FEM.DAssemblyP1_OptV3(Th,Loperator(Th.dim,Th.d,[],[],[],1)); end
  Id=cell(Th.dim,Th.dim);
  for i=1:Th.dim, Id{i,i}=1;end
  if isempty(K), K=FEM.DAssemblyP1_OptV3(Th,Loperator(Th.dim,Th.d,Id,[],[],[])); end
  if iscell(V)
    m=length(V);NH1=0;
    for i=1:m
      assert(length(V{i})==Th.nq)
      Vi=V{i};
      NH1=NH1+dot(M*Vi,Vi)+dot(K*Vi,Vi);
    end
    NH1=sqrt(NH1);
  else  
    m=fix(length(V)/Th.nq);
    assert(m*Th.nq==length(V));
    NH1=0;I=[1:Th.nq]';VFInd=FEM.getVFindices(Num,m,Th.nq);
    for i=1:m
      Vi=V(VFInd(I,i));
      NH1=NH1+dot(M*Vi,Vi)+dot(K*Vi,Vi);
    end
    NH1=sqrt(NH1);
  end
  if nargout>=2, varargout{1}=M;end
  if nargout==3, varargout{2}=K;end
end