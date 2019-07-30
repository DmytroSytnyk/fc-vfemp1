classdef Hoperator < handle
  properties %(SetAccess = protected)
    dim = 0; % space dimension
    d=0;
    m   = 0;
    H = {};
    sym = false;
    name= '';
  end

  methods
    function self=Hoperator(dim,d,m)
      if nargin==0, return;end
      self.dim=dim;self.m=m;self.d=d;
      self.H=cell(m,m);
    end
    
  end % methods
end % classdef