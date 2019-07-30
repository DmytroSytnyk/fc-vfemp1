function x=splitsol(self,X,Num)
% aaa
  if nargin==2, Num=self.Num;end
  if self.m==1, x=X; return; end
  VFInd=FEM.getVFindices(Num,self.m,self.Th.nq);
  x=cell(self.m,1);
  I=1:self.Th.nq;
  for i=1:self.m
    x{i}=X(VFInd(I,i));
  end
end