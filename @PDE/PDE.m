classdef PDE %< handle
  properties %(SetAccess = protected)
    Op = [];
    f  = [];
    delta =[];
    dim = 0;
    d=0;
    m = 0;
    %ndof = 0;
    sym = false;
    name= '';
    AssemblyVersion='OptV3';
  end

  methods
    function self=PDE(Op,f,delta)
      if nargin==0, return;end
      assert( strcmp(class(Op),'Loperator') || strcmp(class(Op),'Hoperator') )
      self.dim=Op.dim;self.m=Op.m;self.d=Op.d;
      self.Op=Op;
      if nargin>=2
        if iscell(f)
          assert(length(f)==self.m);
          self.f=cell(1,self.m);
          for i=1:self.m
            self.f{i}=Fdata(f{i});
          end
        else
          self.f=Fdata(f);
        end
      end
      if nargin==3, self.delta=delta;else self.delta=zeros(1,self.m);end
    end
    
  end % methods
end % classdef