function [A,B]=LinearRegression_quan(y,x)
    [~,~,band]=size(x);
 for i=1:band
    x_ceng=x(:,:,i);
    y_ceng=y(:,:,i); 
    x_lie=x_ceng(:);%将矩阵按列存为列向量
    y_lie=y_ceng(:);
    X=[ones(length(y_lie),1),x_lie];
    bb=regress(y_lie,X);  %[b,bint,r,rint,stats]----b:回归系数;bint:回归系数的区间估计;r:残差;rint:残差置信区间
    B(i)=bb(1);
    A(i)=bb(2);      
end
end