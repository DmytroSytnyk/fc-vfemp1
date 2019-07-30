function self=zeros(self,dim,d,m)
  self.dim=dim;
  self.d=d;
  self.m=m;
  self.delta=zeros(1,m);
  self.Op=Hoperator(dim,d,m);
  self.f=cell(1,m);
end