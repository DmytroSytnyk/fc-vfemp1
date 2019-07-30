function [Aout,bout]=Assembly(self,varargin)
  % A ameliorer!!!
  p = inputParser;
  p.addParamValue('Num',1,@(x) ismember(x,[0,1]));
  p.addParamValue('local',true,@islogical);
  p.addParamValue('physical',true,@islogical);
  p.addParamValue('interface',false,@islogical);
  p.addParamValue('Robin',true,@islogical); % Change in Robin
  p.addParamValue('Dirichlet',true,@islogical);
  p.addParamValue('dom',true,@islogical);
  %p.addParamValue('nq',self.Th.nq,@isscalar);
  p.parse(varargin{:});
  R=p.Results;
  A=spalloc(double(self.ndof),double(self.ndof),double(5*self.ndof));
  b=zeros(self.ndof,1);
  VFInd=FEM.getVFindices(R.Num,self.m,self.Th.nq);
  if R.dom
    idxlab=self.Th.find(self.Th.d);
    [A,b]=Assembly_main(self,A,b,VFInd,idxlab,R.local);
  end
  
  if R.Robin 
    [A,b]=Assembly_BC(self,A,b,VFInd,R,@Assembly_Robin);
  end
  if R.Dirichlet 
    [A,b]=Assembly_BC(self,A,b,VFInd,R,@Assembly_Dirichlet);
  end
  
%    for dd=self.Th.d-1:-1:0 % 
%      Allidxlab=self.Th.find(dd);
%      if ~isempty(Allidxlab)
%        idxlab=[];
%        if R.physical
%          I=find((self.Th.sThlab(Allidxlab)>=0) & (self.Th.sThlab(Allidxlab)<10000));
%          idxlab=[idxlab,Allidxlab(I)];
%        end
%        if R.interface
%          I=find((self.Th.sThlab(Allidxlab)<0)|(self.Th.sThlab(Allidxlab)>=10000));
%          idxlab=[idxlab,Allidxlab(I)];
%        end
%        if R.Robin, [A,b]=Assembly_Robin(self,A,b,VFInd,idxlab);end
%  
%        if R.Dirichlet, [A,b]=Assembly_Dirichlet(self,A,b,VFInd,idxlab);end % ATTENTION BUG POSSIBLE : FAIRE ROBIN PUIS DIRICHLET
%      end
%    end
  
  if ~R.local
    nq=self.Th.nqParents(1);idx=self.Th.toParents{1};
    Aout=sparse(nq,nq);bout=zeros(nq,1);
    Aout(idx,idx)=A;
    bout(idx)=b;
%      Aout=sparse(R.nq,R.nq);bout=zeros(R.nq,1);
%      Aout(self.Th.toGlobal,self.Th.toGlobal)=A;
%      bout(self.Th.toGlobal)=b;
  else
    Aout=A;
    bout=b;
  end
end

function [A,b]=Assembly_main(self,A,b,VFInd,idxlab,local)
  for i=idxlab
    if ~isempty(self.pdes{i})
      [Ai,bi]=self.pdes{i}.Assembly(self.Th.sTh{i},'local',local,'block',true);
      for l=1:self.m
        tgl=VFInd(self.Th.sTh{i}.toParent,l);
        for s=1:self.m
          tgs=VFInd(self.Th.sTh{i}.toParent,s);
          if ~isempty(Ai{l,s}), A(tgl,tgs)=A(tgl,tgs)+Ai{l,s};end
        end
        if ~isempty(bi{l}), b(tgl)=b(tgl)+bi{l};end
      end
    end 
  end
end

%  function [A,b]=Assembly_boundaries(self,A,b,VFInd
%    for dd=self.Th.d-1:-1:0 % 
%      Allidxlab=self.Th.find(dd);
%      if ~isempty(Allidxlab)
%        idxlab=[];
%        if R.physical
%          I=find((self.Th.sThlab(Allidxlab)>=0) & (self.Th.sThlab(Allidxlab)<10000));
%          idxlab=[idxlab,Allidxlab(I)];
%        end
%        if R.interface
%          I=find((self.Th.sThlab(Allidxlab)<0)|(self.Th.sThlab(Allidxlab)>=10000));
%          idxlab=[idxlab,Allidxlab(I)];
%        end
%  end
function [A,b]=Assembly_BC(self,A,b,VFInd,R,Assemblyfun);
  for dd=self.Th.d-1:-1:0 % 
    Allidxlab=self.Th.find(dd);
    if ~isempty(Allidxlab)
      idxlab=[];
      if R.physical
        I=find((self.Th.sThlab(Allidxlab)>=0) & (self.Th.sThlab(Allidxlab)<10000));
        idxlab=[idxlab,Allidxlab(I)];
      end
      if R.interface
        I=find((self.Th.sThlab(Allidxlab)<0)|(self.Th.sThlab(Allidxlab)>=10000));
        idxlab=[idxlab,Allidxlab(I)];
      end
      if ~isempty(idxlab)
        [A,b]=Assemblyfun(self,A,b,VFInd,idxlab);
      end
    end
  end
end

function [A,b]=Assembly_Robin(self,A,b,VFInd,idxlab)
  for i=idxlab 
    if ~isempty(self.pdes{i})
      [Ai,bi]=self.pdes{i}.Assembly(self.Th.sTh{i},'block',true);
      for l=1:self.m
        if self.pdes{i}.delta(l)==1 % Robin
          tgl=VFInd(self.Th.sTh{i}.toParent,l);   
          for k=1:self.m
            if ~isempty(Ai{l,k})
              tgk=VFInd(self.Th.sTh{i}.toParent,k);    
              A(tgl,tgk)=A(tgl,tgk)+Ai{l,k};
            end
          end
          if ~isempty(bi{l}), b(tgl)=b(tgl)+bi{l};end         
        end
      end
    end
  end
end

function [A,b]=Assembly_Dirichlet(self,A,b,VFInd,idxlab)
  for i=idxlab % Puis Dirichlet
    if ~isempty(self.pdes{i})
      [Ai,bi]=self.pdes{i}.Assembly(self.Th.sTh{i},'block',true);
      for l=1:self.m
        if self.pdes{i}.delta(l)==0 % Dirichlet
          tgl=VFInd(self.Th.sTh{i}.toParent,l);
          %if self.pdes{i}.delta(l)==0 % Dirichlet
            for k=1:self.m
              if ~isempty(Ai{l,k})
                tgk=VFInd(self.Th.sTh{i}.toParent,k);
                A(tgl,:)=0;
                A(tgl,tgk)=Ai{l,k};
              end
            end
            if ~isempty(bi{l}), b(tgl)=bi{l};end
          %end
        end
      end
    end
  end
end
