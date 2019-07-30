function E=errors(Th,U,uex)%,varargin)
% function E=errors(Th,U,uex)
% Computes the relative errors norms Inf, L2 and H1 between U and uex.
% E(1) norm Inf, E(2) norm L2  and E(3) norm H1
%    p = inputParser;
%    p.addParamValue('sum',true,@islogical);
%    p.parse(varargin{:});
%    %varargin=fc_tools.utils.deleteCellOptions(varargin,p.Parameters);
%    R=p.Results;
  Uex=Th.eval(uex);
%    if iscell(Uex)
%      assert(iscell(U) && length(U)==length(Uex))
%      m=length(U);E=cell(1,m);
%      for i=1:m,E{i}=U{i}-Uex{i};end
  if iscell(uex)
    m=length(uex);
    assert( size(Uex,2)==m && size(Uex,1)==Th.nq)
    assert( length(U) == m && iscell(U) )
    Err=cell(1,m);
    for i=1:m,Err{i}=U{i}-Uex(:,i);end
  else
    Err=U-Uex;
  end
  eLinf=FEM.NormInf(Th,Err)/(FEM.NormInf(Th,U)+1);
  [eH1,Mass,Stiff]=FEM.NormH1(Th,Err);
  eH1=eH1/(FEM.NormH1(Th,U,'Mass',Mass,'Stiff',Stiff)+1);
  eL2=FEM.NormL2(Th,Err,'Mass',Mass)/(FEM.NormL2(Th,U,'Mass',Mass)+1);
%    if p.Results.sum
%      E=[sum(eLinf),sum(eL2),sum(eH1)];
%    else
    E=[eLinf,eL2,eH1];
  %end
end
