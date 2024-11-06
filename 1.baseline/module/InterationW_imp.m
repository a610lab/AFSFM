function [W] = InterationW_imp(L,X,lamda2,gamma,F,dim)
%L: laplacian matrix
%X: data matrix(num*dim)
%lamda2  ¦Ë2
%gamma: coefficient of L21
%dim: dimension of X

INTER_W = 100;
Q = eye(dim);
p=1; 
for i = 1:INTER_W
    
    W = ((lamda2*X'*X+gamma*Q)^-1)*lamda2*X'*F;
    tempQ = 0.5*p * (sqrt(sum(W.^2,2)+eps)).^(p-2);
    Q = diag(tempQ);
    w1(i) = lamda2 * trace((X*W-F)'*(X*W-F)); % log Tr(WXLXW)
    w2(i) = gamma*sum(sqrt(sum(W.^2,2)));% gama*||W||_21
    WResult(i) = w1(i)+w2(i);
    if i > 1 && abs(WResult(i-1)-WResult(i)) < 0.0001
        break;
    end;
    
end;

end