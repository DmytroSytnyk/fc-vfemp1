function self=set(self,i,j,Lop)
  assert( strcmp(class(Lop),'Loperator') );
  assert( Lop.dim == self.dim);
  assert(sum(~ismember(i,1:self.m))==0);
  assert(sum(~ismember(j,1:self.m))==0);
  for l=1:length(i)
    self.H{i(l),j(l)}=Lop;
  end
end