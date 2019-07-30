function x=Solve(A,b)
  p=symrcm(A);
  x=zeros(length(b),1);
  x(p)=A(p,p)\b(p);
end