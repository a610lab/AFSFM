function [W] = AFSFM(X,y,Ytrain,lamda1,lamda2,gamma,k,d)
% Input
% X: dim*num data matrix       
% y: num*1 label vector        
% Ytrain: label+scores
% lamda1  ¦Ë1
% lamda2  ¦Ë2
% gamma:  ¦Ë3
% d: projection dim of W(dim*d)    
% k: nearest neighobrs

%Output
%id: sorted features by ||w_i||_2

num = size(X,2);  %number of samples
dim = size(X,1);  %dimensions

X0 = X';
mX0 = mean(X0);
X1 = X0 - ones(num,1)*mX0;      
scal = 1./sqrt(sum(X1.*X1)+eps);    
scalMat = sparse(diag(scal));   
X = X1*scalMat;       
X = X';              

distX = L2_distance_1(X,X);    %Calculate Euclidean distance

I1 = find(y==1);  
I2 = find(y==-1);

for i=1:num
    distX(i,y~=y(i))=inf;
end
%%%%%%%%%%%%%
[distX1, idx] = sort(distX,2); 
A = zeros(num); 
rr = zeros(num,1); 
for i = 1:num                
    di = distX1(i,2:k+2);   
    rr(i) = 0.5*(k*di(k+1)-sum(di(1:k)));  
    id = idx(i,2:k+2);
    A(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end;
r = mean(rr);
A0 = (A+A')/2;
D0 = diag(sum(A0));
L = D0 - A0;       %Laplacian matrix    L = D - A 


W = eye(dim,d);
NITER = 50;
I = eye(num);
for iter = 1:NITER
    F = ((I+lamda2*I+2*lamda1*L)^-1)*(Ytrain+lamda2*X'*W);
    distx = L2_distance_1(F',F');
    for i=1:num
        distx(i,y~=y(i))=inf;
    end
    %%%%%%%%%%%%%%%%%%
    if iter>5
        [~, idx] = sort(distx,2);
    end;
    A = zeros(num);
    for i=1:num
        idxa0 = idx(i,2:k+1);
        dxi = distx(i,idxa0);
        ad = -(dxi)/(2*r);
        A(i,idxa0) = EProjSimplex_new(ad);
        
    end;
    A = (A+A')/2;
    D = diag(sum(A));
    L = D-A;
    [W] = InterationW_imp(L,X',lamda2,gamma,F,dim);
end;
end



