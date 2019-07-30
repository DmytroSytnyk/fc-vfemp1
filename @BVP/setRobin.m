function self=setRobin(self,label,fun,ar,Lm)
  idxlab=self.Th.find(self.d-1,label);
  if length(idxlab)==1
  %assert(length(idxlab)==1)
    if ~isempty(ar)
      LopD=Loperator(self.dim,self.d-1,[],[],[],ar);
    else
      LopD=[];
    end
    if nargin<=4
      Lm=1:self.m;
    end
    if isempty(self.pdes{idxlab})
      self.pdes{idxlab}=PDE();
      self.pdes{idxlab}=self.pdes{idxlab}.zeros(self.dim,self.d-1,self.m);
    end
    i=1;
    for l=Lm
      self.pdes{idxlab}.delta(l)=1;
      for k=1:self.m
        if k~=l
          self.pdes{idxlab}.Op=[];
        else
          self.pdes{idxlab}.Op=LopD;
        end
      end
      if iscell(fun)
        self.pdes{idxlab}.f=Fdata(fun{i});
      elseif fc_tools.utils.isfunhandle(fun)
        self.pdes{idxlab}.f=Fdata(fun);
      elseif size(fun,1)==length(Lm)
        self.pdes{idxlab}.f=Fdata(fun(i,:));
      elseif size(fun,2)==length(Lm)
        self.pdes{idxlab}.f=Fdata(fun(:,i));
      else
        self.pdes{idxlab}.f{l}=Fdata(fun);
      end
      i=i+1;
    end
  end  
  
end
  