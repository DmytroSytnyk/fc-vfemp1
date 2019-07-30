function [A,b]=Assembly(self,sTh,varargin)
  %if nargin<=2,ndof=sTh.nq;end
  assert( strcmp(class(sTh),'siMeshElt') )
  assert( (self.dim == sTh.dim) && (self.d == sTh.d) )
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
  p.addParamValue('block',false,@islogical);
  p.parse(varargin{:});
  R=p.Results;
  
  if strcmp(class(self.Op),'Loperator')
    A=FEM.DAssemblyP1_OptV3new(sTh,self.Op,'local',R.local);
    if ~isempty(self.f)
      Mop=Loperator(sTh.dim,sTh.d,[],[],[],self.f);
      M=FEM.DAssemblyP1_OptV3new(sTh,Mop);
      f=M*ones(sTh.nq,1);
      if R.local
        b=f;
      else b=zeros(sTh.nqParent,1);b(sTh.toParent)=f;end
    else
      if R.local, b=zeros(sTh.nq,1);else b=zeros(sTh.nqParent,1);end
    end
    if R.block, A={A};b={b};end
    return
  end
  if strcmp(class(self.Op),'Hoperator')
    A=FEM.HAssemblyP1_OptV3(sTh,self.Op,'local',R.local,'Num',R.Num,'block',R.block);
    b=FEM.RHSAssembly(sTh,self.f,'m',self.m,'local',R.local,'Num',R.Num,'block',R.block);
  end
end