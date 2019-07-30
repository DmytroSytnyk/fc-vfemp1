function [x,varargout]=classicSolve(A,b,ndof,gD,ID,IDc,options)
  x=zeros(ndof,1);
  x(ID)=gD(ID);
  bb=b(IDc)-A(IDc,:)*gD;
  x(IDc)=A(IDc,IDc)\bb;
  if nargout==2
    varargout{1}=0;
  end
end