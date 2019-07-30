function Kg = KgP1_OptV3(sTh,D)
  ndfe=sTh.d+1;
  Kg=zeros(sTh.nme,ndfe,ndfe);
  Kg=KgP1_OptV3_guv(sTh,D.a0,Kg);
  if ~isempty(D.A)
    for i=1:sTh.dim 
      for j=1:sTh.dim
        Kg=KgP1_OptV3_gdudv(sTh,D.A{i,j},i,j,Kg); 
      end
    end
  end
  if ~isempty(D.b)
    for i=1:sTh.dim 
      Kg=KgP1_OptV3_gudv(sTh,D.b{i},i,Kg);
    end
  end
  if ~isempty(D.c)
    for i=1:sTh.dim 
      Kg=KgP1_OptV3_gduv(sTh,D.c{i},i,Kg);
    end
  end
end

function Kg=KgP1_OptV3_guv(sTh,g,Kg)
  if isempty(g), return, end
  gh=g.eval(sTh);
  %gh=sTh.eval(g);
  if isempty(gh), return, end
  type=g.get_type(sTh);
  d=sTh.d;ndfe=d+1;
  if strcmp(type,'P1')
    gme=gh(sTh.me);
    gs=sum(gme,1);
    KgElem=@(il,jl) (factorial(d)/factorial(d+3))*(1+(il==jl))*(sTh.vols.*(gs+gme(il,:)+gme(jl,:))).';
  else
    KgElem=@(il,jl) (factorial(d)/factorial(d+2))*(1+(il==jl))*(sTh.vols'.*gh);
  end
  Kg=AddToKg(Kg,ndfe,KgElem);
end

function Kg=KgP1_OptV3_gdudv(sTh,g,i,j,Kg)
  if isempty(g), return, end
  gh=g.eval(sTh);
  if isempty(gh), return, end
  type=g.get_type(sTh);
  d=sTh.d;ndfe=d+1;
  G=sTh.gradBaCo;
  if strcmp(type,'P1')
    gme=gh(sTh.me);
    gs=sum(gme,1);
    KgElem=@(il,jl) ((factorial(d)/factorial(d+1))*(sTh.vols.*gs)).'.*(G(:,jl,j).*G(:,il,i));
  else
    KgElem=@(il,jl) (sTh.vols.*gh).'.*(G(:,jl,j).*G(:,il,i));
  end
  Kg=AddToKg(Kg,ndfe,KgElem);
end

function Kg=KgP1_OptV3_gudv(sTh,g,i,Kg)
  if isempty(g), return, end
  gh=g.eval(sTh);
  if isempty(gh), return, end
  type=g.get_type(sTh);
  d=sTh.d;ndfe=d+1;
  G=sTh.gradBaCo;
  if strcmp(type,'P1')
    gme=gh(sTh.me);
    gs=sum(gme,1);
    KgElem=@(il,jl) -(factorial(d)/factorial(d+2))*(sTh.vols.*(gs+gme(jl,:))).'.*G(:,il,i);      
  else
    KgElem=@(il,jl) -(factorial(d)/factorial(d+1))*(sTh.vols.*gh).'.*G(:,il,i);     
  end
  Kg=AddToKg(Kg,ndfe,KgElem);
end

function Kg=KgP1_OptV3_gduv(sTh,g,i,Kg)
  if isempty(g), return, end
  gh=g.eval(sTh);
  if isempty(gh), return, end
  type=g.get_type(sTh);
  d=sTh.d;ndfe=d+1;
  G=sTh.gradBaCo;
  if strcmp(type,'P1')
    gme=gh(sTh.me);
    gs=sum(gme,1);
    KgElem=@(il,jl) (factorial(d)/factorial(d+2))*(sTh.vols.*(gs+gme(il,:))).'.*G(:,jl,i);     
  else
    KgElem=@(il,jl) (factorial(d)/factorial(d+1))*(sTh.vols.*gh).'.*G(:,jl,i);     
  end
  Kg=AddToKg(Kg,ndfe,KgElem);
end

function Kg=AddToKg(Kg,ndfe,KgElem)
  for il=1:ndfe
    for jl=1:ndfe
      Kg(:,il,jl)=Kg(:,il,jl)+KgElem(il,jl);
    end
  end
end