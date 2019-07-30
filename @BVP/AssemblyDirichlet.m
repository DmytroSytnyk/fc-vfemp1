function [ID,IDc,gD]=AssemblyDirichlet(self,varargin)
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.parse(varargin{:});
  R=p.Results;
  gD=zeros(self.ndof,1);
  ID=[];
  VFInd=FEM.getVFindices(R.Num,self.m,self.Th.nq);
  idxlab=self.Th.find(self.Th.d-1);
  for i=idxlab
    if ~isempty(self.pdes{i})  
      tg=self.Th.sTh{i}.toParent;
      if size(tg,1)>1, tg=tg';end
      for l=1:self.m
        if self.pdes{i}.delta(l)==0 % Dirichlet 
          %[Ai,bi]=self.pdes{i}.Assembly(self.Th.sTh{i});
          tgl=VFInd(tg,l);
          %whos
          %gD(tgl)=Ai\bi;
          %gD(tgl)=self.pdes{i}.f{l}.eval(self.Th.sTh{i});
          if self.m==1 % FC : to improve
            gD(tgl)=self.pdes{i}.f.eval(self.Th.sTh{i});
          else
            gD(tgl)=self.pdes{i}.f{l}.eval(self.Th.sTh{i});
          end
          ID=[ID,tgl];
        end
      end
    end 
  end
  ID=unique(ID);
  IDc=setdiff(1:self.ndof,ID);
end