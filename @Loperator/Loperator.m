classdef Loperator %< handle
  properties %(SetAccess = protected)
    dim = 0; % space dimension
    d   = 0; % 
    label = []; % subdomains label
    A = [];
    b = [];
    c = [];
    a0 =[];
    order = 0;
    sym = false;
    m=1;
  end

  methods
    function self=Loperator(dim,d,A,b,c,a0)
      if nargin==0, return;end
      self.d=d;
      self.dim=dim;
      %if nargin==2, return; end
      if ~isempty(A) 
        assert( iscell(A) && ( size(A,1)==dim ) && ( size(A,2)==dim ) );
        self.A=cell(dim,dim);
        self.order=2;
        for i=1:dim
          for j=1:dim
            if~isempty(A{i,j}), self.A{i,j}=Fdata(A{i,j});end
          end
        end
      end
      if ~isempty(b) 
        assert( iscell(b) && ( length(b)==dim ) );
        self.b=cell(dim,1);
        self.order=max(self.order,1);
        for i=1:dim
          self.b{i}=Fdata(b{i});
        end
      end
      if ~isempty(c) 
        assert( iscell(c) && ( length(c)==dim ) );
        self.c=cell(dim,1);
        self.order=max(self.order,1);
        for i=1:dim
          self.c{i}=Fdata(c{i});
        end
      end
      if ~isempty(a0)
          self.a0=Fdata(a0);
      end  
%        if nargin==6,self.label=label;end
%        if strcmp(class(Th),'P1Element')
%          self.label=Th.label;
%        end
    end % Loperator
    
    function obj=mtimes(obj1,obj2)
      assert( isscalar(obj1) && isnumeric(obj1))
      assert( strcmp(class(obj2),'Loperator') )
      dim=obj2.dim;
      A=obj2.A;
      if ~isempty(A)
        for i=1:dim
          for j=1:dim
            if ~isempty(A{i,j}), A{i,j}=obj1*A{i,j};end
          end
        end
      end
      b=obj2.b;
      if ~isempty(b) 
        for i=1:dim
          if ~isempty(b{i}), b{i}=obj1*b{i};end
        end
      end
      c=obj2.c;
      if ~isempty(c) 
        for i=1:dim
          if ~isempty(c{i}), c{i}=obj1*c{i};end
        end
      end
      a0=obj2.a0;
      if ~isempty(a0), a0=obj1*a0;end
      obj=Loperator(obj2.dim,obj2.d,A,b,c,a0);
    end % mtimes
    
    function obj=plus(obj1,obj2)
      assert( strcmp(class(obj1),'Loperator') )
      assert( strcmp(class(obj2),'Loperator') )
      assert( obj1.dim==obj2.dim && obj1.d==obj2.d )
      dim=obj2.dim;
      A=obj1.A;A2=obj2.A;
      if ~isempty(A2)
        for i=1:dim
          for j=1:dim
            if ~isempty(A2{i,j})
              if isempty(A{i,j})
                A{i,j}=A2{i,j};
              else
                A{i,j}=A{i,j}+A2{i,j};
              end
            end
          end
        end
      end
      b=obj2.b;
      if ~isempty(b) 
        for i=1:dim
          if ~isempty(b{i}), b{i}=obj1*b{i};end
        end
      end
      c=obj2.c;
      if ~isempty(c) 
        for i=1:dim
          if ~isempty(c{i}), c{i}=obj1*c{i};end
        end
      end
      a0=obj2.a0;
      if ~isempty(a0), a0=obj1*a0;end
      obj=Loperator(obj2.dim,obj2.d,A,b,c,a0);
    end % mtimes
   
  end % methods
end % classdef