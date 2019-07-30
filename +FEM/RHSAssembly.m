function b=RHSAssembly(sTh,f,varargin)
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
  p.addParamValue('block',false,@islogical);
  p.addParamValue('m',1,@isscalar);
  p.parse(varargin{:});
  R=p.Results;
  m=R.m;
  if R.local, nq=sTh.nq;else nq=sTh.nqGlobal;end
  ndof=m*nq;
  if R.block
    b=cell(m,1);
  else
    b=zeros(ndof,1);
  end
  if ~isempty(f)
    assert( length(f)==m )
    VFInd=FEM.getVFindices(R.Num,m,nq);
    I=1:nq;
    Mop=Loperator(sTh.dim,sTh.d,[],[],[],1);
    M=FEM.DAssemblyP1_OptV3new(sTh,Mop);
    for i=1:m
%        if m==1, 
%          fh=f.eval(sTh);
%        else
      if ~isempty(f{i})
        fh=f{i}.eval(sTh);
        if length(fh)==1, fh=fh*ones(nq,1);end
        if (length(fh)==sTh.nme)
          Mop2=Loperator(sTh.dim,sTh.d,[],[],[],Fdata(fh,sTh.label,'P0'));
          M2=FEM.DAssemblyP1_OptV3new(sTh,Mop2);
          Fh=M2*ones(length(M2),1);
        else
          Fh=M*fh;
        end
      %end
        
        if R.block
          b{i}=Fh;
        else
          J=VFInd(I,i);
          b(VFInd(I,i))=Fh;
        end
      end
    end
  end
end