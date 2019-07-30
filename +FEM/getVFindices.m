function VFInd = getVFindices(Num,m,nq)
if (Num==1) 
  VFInd=@(I,i) I+(i-1)*nq;
else 
  VFInd=@(I,i) m*I-(m-i);
end