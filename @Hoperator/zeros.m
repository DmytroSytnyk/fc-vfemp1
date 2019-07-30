function self=zeros(self,dim,m)
  assert( isscalar(dim) && isscalar(m) );
  assert( dim>0 && m>0 );
  self.dim=dim;
  self.m=m;
  self.H=cell(m,m);
end