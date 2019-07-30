function [A,b]=Assembly(self,sTh,varargin)
  %if nargin<=2,ndof=sTh.nq;end
  assert( strcmp(class(sTh),'P1Element') )
  assert( (self.dim == sTh.dim) && (self.d == sTh.d) )
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
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
      else b=zeros(sTh.nqGlobal,1);b(sTh.toGlobal)=f;end
    else
      if R.local, b=zeros(sTh.nq,1);else b=zeros(sTh.nqGlobal,1);end
    end
    return
  end
  if strcmp(class(self.Op),'Hoperator')
    A=HAssemblyP1_OptV3(sTh,self.Op,'local',R.local,'Num',R.Num);
    b=RHSAssembly(sTh,self.f,'m',self.m,'local',R.local,'Num',R.Num);
  end
end