function f=apply(self,Th,u)
  bvp=BVP(Th,PDE(self));
  [A,b]=bvp.Assembly('local',true);
  Lop=Loperator(self.dim,self.d,[],[],[],1);
  bvp=BVP(Th,PDE(Lop));
  [M,b]=bvp.Assembly('local',true);
  f=M\(A*u);
end
  
