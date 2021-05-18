function [A,B]=LinearRegression_quan(y,x)
    [~,~,band]=size(x);
 for i=1:band
    x_ceng=x(:,:,i);
    y_ceng=y(:,:,i); 
    x_lie=x_ceng(:);
    y_lie=y_ceng(:);
    X=[ones(length(y_lie),1),x_lie];
    bb=regress(y_lie,X);
    B(i)=bb(1);
    A(i)=bb(2);      
end
end
