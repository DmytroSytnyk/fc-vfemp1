classdef BVP < handle
  properties %(SetAccess = protected)
    Th = [];
    pdes = [];
    system=[];
    dim = 0;
    d=0;
    m = 0;
    ndof = 0;
    sym = false;
    Num = 1;
    name= '';
    AssemblyVersion='OptV3';
    info = [];
  end

  methods
    function self=BVP(Th,pde,labels)
      if nargin==0, return;end
      assert( strcmp(class(Th),'siMesh') )
      assert( strcmp(class(pde),'PDE') )
      assert( Th.dim == pde.dim);
      if nargin==2, idxlab=Th.find(pde.d);
      else idxlab=Th.find(pde.d,labels);end
      self.dim=pde.dim;
      self.d=Th.d;
      self.m=pde.m; % Scalar for the moment
      self.Th=Th;
      self.system=struct('A',[],'b',[],'ID',[],'IDc',[],'gD',[]);
      self.ndof=self.m*Th.nq; % For P1-Lagrange only!
      self.pdes=cell(1,Th.nsTh);
      for i=idxlab, self.pdes{i}=pde;end
    end
    
  end % methods
end % classdef