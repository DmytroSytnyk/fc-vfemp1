function self=setPDE(self,d,label,pde)
  idxlab=self.Th.find(d,label);
  %assert(length(idxlab)==1)
  %assert( strcmp(class(Op),'Loperator') || strcmp(class(Op),'Hoperator') )
  if length(idxlab)==1
    self.pdes{idxlab}=pde;
  end
end
  