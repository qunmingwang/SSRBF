function [gapfilled]=SSRBF_function(SLCoff,known)
% Parameters
%
%    w          Half the window side
%    s          The number of similar pixels per moving window
%    sigma1     The empirically determined parameter for the spatial-based RBF
%    sigma2     The empirically determined parameter for the spectral-based RBF


Gapmask=double(logical(SLCoff(:,:,1).*SLCoff(:,:,2).*SLCoff(:,:,3).*SLCoff(:,:,4).*SLCoff(:,:,5).*SLCoff(:,:,6)));
[a,b,c]=size(known);
for n=1:c
    L=known(:,:,n);GL=SLCoff(:,:,n).*Gapmask;
    Lg=L.*Gapmask;
    Lg(find(Lg(:,:)==0))=[];
    GL(find(GL(:,:)==0))=[];
    X(:,:,n)=Lg;
    Y(:,:,n)=GL;
end
[A,B]=LinearRegression_quan(Y,X);
for k=1:c
    Kreg(:,:,k)=A(1,k)*known(:,:,k)+B(k);
end
Se=zeros(a+2*w,b+2*w,c);Ke=zeros(a+2*w,b+2*w,c);
Se(w+1:a+w,w+1:b+w,:)=SLCoff;Ke(w+1:a+w,w+1:b+w,:)=Kreg;
gapfilled_e=Se;
for x=(w+1):a+w
    for y=(w+1):b+w
        if (Se(x,y,1)==0||Se(x,y,2)==0||Se(x,y,3)==0||Se(x,y,4)==0||Se(x,y,5)==0||Se(x,y,6)==0)
            p=1;
            for i=x-w:x+w
                for j=y-w:y+w
                    if (Se(i,j,1)==0||Se(i,j,2)==0||Se(i,j,3)==0||Se(i,j,4)==0||Se(i,j,5)==0||Se(i,j,6)==0)
                        continue;
                    else
                        xx(p)=i;yy(p)=j;
                        R(p)=sqrt(((Ke(i,j,1)-Ke(x,y,1))^2+(Ke(i,j,2)-Ke(x,y,2))^2+(Ke(i,j,3)-Ke(x,y,3))^2+(Ke(i,j,4)-Ke(x,y,4))^2+(Ke(i,j,5)-Ke(x,y,5))^2+(Ke(i,j,6)-Ke(x,y,6))^2)/c);
                        p=p+1;
                    end
                end
            end
            [R,Q]=sort(R(:),'ascend');
            RR=R(1:s,:);
            for m=1:c
                for n=1:s
                    Dif(n,m)=Se(xx(Q(n)),yy(Q(n)),m)-Ke(xx(Q(n)),yy(Q(n)),m);
                end
            end
            
            for n=1:s
                for m=1:s
                    Band=0;
                    for u=1:c
                        Band=Band+(Ke(xx(Q(n)),yy(Q(n)),u)-Ke(xx(Q(m)),yy(Q(m)),u))^2;
                    end
                    Rr(n,m)=sqrt(Band/c);
                end
            end
            
            for n=1:s
                for m=1:s
                    d(n,m)=(xx(Q(n))-xx(Q(m)))^2+(yy(Q(n))-yy(Q(m)))^2;
                    e(n,m)=exp(-sqrt(d(n,m))/sigma1)*exp(-Rr(n,m)/sigma2);
                end
                dd(n)=(x-xx(Q(n)))^2+(y-yy(Q(n)))^2;
                ee(n)=exp(-sqrt(dd(n))/sigma1)*exp(-RR(n)/sigma2);
            end
            e0=inv(e);
            for n=1:c
                gapfilled_e(x,y,n)=Ke(x,y,n)+ee*e0*Dif(:,n);
            end
            clear R
        end
    end
end
gapfilled=gapfilled_e(w+1:w+a,w+1:w+b,:);




