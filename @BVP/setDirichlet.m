function self=setDirichlet(self,label,fun,Lm)
  idxlab=self.Th.find(self.d-1,label);
  %assert(length(idxlab)==1)
  if length(idxlab)==1
    LopD=Loperator(self.dim,self.d-1,[],[],[],1);
    if nargin<=3
      Lm=1:self.m;
    end
    if isempty(self.pdes{idxlab})
      %self.pdes{idxlab}=PDE.zero(self.dim,self.d-1,self.m);
      self.pdes{idxlab}=PDE();
      self.pdes{idxlab}=self.pdes{idxlab}.zeros(self.dim,self.d-1,self.m);
    end
    if self.m==1
      self.pdes{idxlab}.Op=LopD;
      self.pdes{idxlab}.f=Fdata(fun);
      self.pdes{idxlab}.delta=0;
    else
      i=1;
      for l=Lm
        self.pdes{idxlab}.delta(l)=0;
        for k=1:self.m % To improve!!!
          if k~=l
            self.pdes{idxlab}.Op.H{l,k}=[];
          else
            self.pdes{idxlab}.Op.H{l,l}=LopD;
          end
        end
        if iscell(fun)
          self.pdes{idxlab}.f{l}=Fdata(fun{i});
        else
          self.pdes{idxlab}.f{l}=Fdata(fun);
        end
        i=i+1;
      end
    end
  end 
  
end
  