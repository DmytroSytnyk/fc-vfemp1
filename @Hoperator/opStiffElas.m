function self=opStiffElas(self,dim,lambda,mu)
  self.zeros(dim,dim);
  self.dim=dim;
  self.d=dim;
  self.m=dim;
  self.name=sprintf('H%dd_StiffElas',dim);
  self.sym=true;
  gamma=lambda+2*mu;
  switch dim
    case 2
        %self.H=cell(2,2);
        self.set(1,1,Loperator(dim,dim,{gamma,[];[],mu},[],[],[])); 
        self.set(1,2,Loperator(dim,dim,{[],lambda;mu,[]},[],[],[]));
        self.set(2,1,Loperator(dim,dim,{[],mu;lambda,[]},[],[],[]));
        self.set(2,2,Loperator(dim,dim,{mu,[];[],gamma},[],[],[])); 
    case 3
        self.set(1,1,Loperator(dim,dim,{gamma,[],[];[],mu,[];[],[],mu},[],[],[]));
        self.set(1,2,Loperator(dim,dim,{[],lambda,[];mu,[],[];[],[],[]},[],[],[]));
        self.set(1,3,Loperator(dim,dim,{[],[],lambda;[],[],[];mu,[],[]},[],[],[]));
        self.set(2,1,Loperator(dim,dim,{[],mu,[];lambda,[],[];[],[],[]},[],[],[]));
        self.set(2,2,Loperator(dim,dim,{mu,[],[];[],gamma,[];[],[],mu},[],[],[]));
        self.set(2,3,Loperator(dim,dim,{[],[],[];[],[],lambda;[],mu,[]},[],[],[]));
        self.set(3,1,Loperator(dim,dim,{[],[],mu;[],[],[];lambda,[],[]},[],[],[]));
        self.set(3,2,Loperator(dim,dim,{[],[],[];[],[],mu;[],lambda,[]},[],[],[]));
        self.set(3,3,Loperator(dim,dim,{mu,[],[];[],mu,[];[],[],gamma},[],[],[]));
  end
end