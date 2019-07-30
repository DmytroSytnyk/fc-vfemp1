function f=apply(self,Th,u)
% FC: to improve
  bvp=BVP(Th,PDE(self));
  [A,b]=bvp.Assembly('local',true);
  Hop=Hoperator(self.dim,self.d,self.m);
  Lop=Loperator(self.dim,self.d,[],[],[],1);
  for i=1:self.m, Hop.H{i,i}=Lop;end
  bvp=BVP(Th,PDE(Hop));
  [M,b]=bvp.Assembly('local',true);
  U=[];
  for i=1:self.m,U=[U;u{i}];end
  f=M\(A*U);
  f=bvp.splitsol(f);
end
  
