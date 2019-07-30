classdef Fdata < handle 

  properties %(SetAccess = protected)
    type ={};
    label = [];
    fun = {};
  end
  
  methods
    function self = Fdata(fun,label,type)
      if nargin==0, return;end
      if ( (nargin==1) && ( strcmp(class(fun),'Fdata') ) )
        self=fun;
        return;
      end
      if nargin==1, label=[];end
      if nargin<=2, type='P1';end
      if (isnumeric(fun) && isscalar(fun)), type='C';end
      assert( ismember(type,{'C','P0','P1'}) );
      self.type{1}=type;
      self.fun{1}=fun;
      if ~isempty(label), self.label(1)=label;end
    end
    
    function type=get_type(self,sTh)
      if isempty(self.label), type=self.type{1};return;end
      i=find(self.label==sTh.label);
      if (~isempty(i)), type=self.type{i};else type=[];end
    end
    
    function u=eval(self,sTh)
%        if (length(self.fun{1})==sTh.nme) || (length(self.fun{1})==sTh.nq)
%          u=self.fun{1};
%          return
%        end
      if isempty(self.label)
        fun=self.fun{1};type=self.type{1};
      else
        i=find(self.label==sTh.label);
        if isempty(i),u=[];return;else
          fun=self.fun{i};type=self.type{i};
        end
      end
      switch type
        case 'C'
          u=fun;
        case 'P1'
          if strcmp(class(fun),'function_handle')
            if nargin(fun)==1,u=fun(sTh.q).';else
            %if sTh.dim==1, u=fun(sTh.q).';else
              u=eval(['fun(sTh.q(1,:)',sprintf(',sTh.q(%d,:)',2:sTh.dim),').'';']) ; 
            end
            if length(u)==1, u=u*ones(sTh.nq,1);end
          elseif isnumeric(fun)
            if size(fun,1) == sTh.nq
              u=fun;return
            end
            if size(fun,1) == sTh.nqGlobal
              u=fun(sTh.toGlobal);return
            end
            if size(fun,2) == sTh.nqGlobal
              u=fun(sTh.toGlobal).';return
            end
            if size(fun,1) == sTh.nqParent
              u=fun(sTh.toParent);return
            end
            if size(fun,2) == sTh.nqParent
              u=fun(sTh.toParent).';return
            end
            sTh
            whos
            self
            %fun
            assert(0)
          else
            error('Unknow fun : %s',class(fun))
          end
        case 'P0'
          if strcmp(class(fun),'function_handle')
            Ba=sTh.barycenters();
            u=eval(['fun(Ba(1,:)',sprintf(',Ba(%d,:)',2:sTh.dim),').'';']) ; 
          elseif isnumeric(fun)
            %size(fun)
            %sTh.nme
            %assert( (size(fun) == [sTh.nme,1]) | (size(fun) == [1,sTh.nme]));
            if size(fun) == [sTh.nme,1]
              u=fun;
            elseif size(fun) == [1, sTh.nme]
              u=fun';
            else
              assert(1)
            end
          else
            error('Unknow fun : %s',class(fun))
          end
      end
    end
    
    function obj=mtimes(obj1,obj2)
      if  ( strcmp(class(obj1),'Fdata') && strcmp(class(obj2),'Fdata') )
        f1=obj1.fun{1};f2=obj2.fun{1};
        if fc_tools.utils.isfunhandle(f1) && fc_tools.utils.isfunhandle(f2)
          assert(nargin(f1)==nargin(f2)); % to improve
          sarg=argfunhandle(f1);
          assert(strcmp(sarg,argfunhandle(f2)))
          obj=Fdata();
          obj.label=obj1.label
          obj.type=obj1.type;
          n=nargin(f1);
          obj.fun{1}=eval([sarg ,'(',strfunhandle(f1),').*(',strfunhandle(f2),')']);
        else
          error('Not yet implemented...')
        end
      elseif ( strcmp(class(obj1),'Fdata') && isnumeric(obj2) )
        obj=Fdata();
        obj.label=obj1.label
        obj.type=obj1.type;
        fun=obj1.fun{1}
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj2),';']) ;
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),sprintf(' %.16e*(',obj2),cfun(I+1:end),')'];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+obj2;
        end
      elseif ( strcmp(class(obj2),'Fdata') && isnumeric(obj1) )
        obj=Fdata();
        obj.label=obj2.label
        obj.type=obj2.type;
        fun=obj2.fun{1};
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj1),';']) ; 
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),sprintf(' %.16e*(',obj1),cfun(I+1:end),')'];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+obj1;
        end
      else
        error('[Fdata] Incompatible type %s and %s',class(obj1),class(obj2))
      end
    end
    
    
    function obj=plus(obj1,obj2)
      if  ( strcmp(class(obj1),'Fdata') && strcmp(class(obj2),'Fdata') )
        f1=obj1.fun{1};f2=obj2.fun{1};
        if fc_tools.utils.isfunhandle(f1) && fc_tools.utils.isfunhandle(f2)
          assert(nargin(f1)==nargin(f2)); % to improve
          sarg=argfunhandle(f1);
          assert(strcmp(sarg,argfunhandle(f2)))
          obj=Fdata();
          obj.label=obj1.label
          obj.type=obj1.type;
          n=nargin(f1);
          obj.fun{1}=eval([sarg ,'(',strfunhandle(f1),')+(',strfunhandle(f2),')']);
        else
          error('Not yet implemented...')
        end
      elseif ( strcmp(class(obj1),'Fdata') && isnumeric(obj2) )
        obj=Fdata();
        obj.label=obj1.label
        obj.type=obj1.type;
        fun=obj1.fun{1}
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj2),';']) ;
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),' (',cfun(I+1:end),')+',sprintf('%.16e',obj2)];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+c;
        end
      elseif ( strcmp(class(obj2),'Fdata') && isnumeric(obj1) )
        obj=Fdata();
        obj.label=obj2.label
        obj.type=obj2.type;
        fun=obj2.fun{1};
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj1),';']) ; 
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),sprintf(' %.16e+(',obj1),cfun(I+1:end),')'];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+c;
        end
      else
        error('[Fdata] Incompatible type %s and %s',class(obj1),class(obj2))
      end
    end
    
    function obj=minus(obj1,obj2)
      if  ( strcmp(class(obj1),'Fdata') && strcmp(class(obj2),'Fdata') )
        f1=obj1.fun{1};f2=obj2.fun{1};
        if fc_tools.utils.isfunhandle(f1) && fc_tools.utils.isfunhandle(f2)
          assert(nargin(f1)==nargin(f2)); % to improve
          sarg=argfunhandle(f1);
          assert(strcmp(sarg,argfunhandle(f2)))
          obj=Fdata();
          obj.label=obj1.label
          obj.type=obj1.type;
          n=nargin(f1);
          obj.fun{1}=eval([sarg ,'(',strfunhandle(f1),')-(',strfunhandle(f2),')']);
        else
          error('Not yet implemented...')
        end
      elseif ( strcmp(class(obj1),'Fdata') && isnumeric(obj2) )
        obj=Fdata();
        obj.label=obj1.label
        obj.type=obj1.type;
        fun=obj1.fun{1}
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj2),';']) ;
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),' (',cfun(I+1:end),')-',sprintf('%.16e',obj2)];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+c;
        end
      elseif ( strcmp(class(obj2),'Fdata') && isnumeric(obj1) )
        obj=Fdata();
        obj.label=obj2.label
        obj.type=obj2.type;
        fun=obj2.fun{1};
        if strcmp(class(fun),'function_handle')
          %n=nargin(fun);
          %obj.fun{1}=eval(['@(a1',sprintf(',a%d',2:n),') ','fun(a1',sprintf(',a%d',2:n),')+',sprintf('%.16f',obj1),';']) ; 
          cfun=char(fun);
          I=strfind(cfun,')');I=I(1);
          cexp=[cfun(1:I),sprintf(' %.16e-(',obj1),cfun(I+1:end),')'];
          obj.fun{1}=eval(cexp);
        else % numerical
          obj.fun{1}=fun+c;
        end
      else
        error('[Fdata] Incompatible type %s and %s',class(obj1),class(obj2))
      end
    end
    
    function types=get_types(self)
      types={'C','P0','P1'};
    end
  end % methods
end %classdef