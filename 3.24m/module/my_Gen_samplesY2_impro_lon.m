
function [Xtrain,Ltrain,Xtest,Ltest,Atrain,Atest,Btrain,Btest,Dtrain,Dtest,Ytrain] = ...
    my_Gen_samplesY2_impro_lon(...
    Xpar1,Xpar2,...
    posY,negY,...
    posScoresA,negScoresA,...
    posScoresB,negScoresB,...
    posScoresD,negScoresD,...
    labelPar1,labelPar2,...
    indPar1,indPar2,...
    i)

% separately sampling from each class

test1 = (indPar1==i);      
train1 = ~test1;        

Xtest1 = Xpar1(test1,:);
Ltest1 = labelPar1(test1,:);
posAtest = posScoresA(test1,:);
posBtest = posScoresB(test1,:);
% posCtest = posScoresC(test1,:); 
posDtest = posScoresD(test1,:);

Xtrain1 = Xpar1(train1,:);     % fea * ins
Ltrain1 = labelPar1(train1,:);	% label*1
posYtrain = posY(train1,:);     % score * ins
posAtrain = posScoresA(train1,:);
posBtrain = posScoresB(train1,:);
% posCtrain = posScoresC(train1,:); 
posDtrain = posScoresD(train1,:);

test2 = (indPar2 ==i);    
train2 = ~test2;

Xtest2 = Xpar2(test2,:);
Ltest2 = labelPar2(test2,:);
negAtest = negScoresA(test2,:);
negBtest = negScoresB(test2,:);
% negCtest = negScoresC(test2,:); 
negDtest = negScoresD(test2,:);

Xtrain2 = Xpar2(train2,:);     %% fea * ins
Ltrain2 = labelPar2(train2,:);	%% label*1
negYtrain = negY(train2,:);     %% score * ins
negAtrain = negScoresA(train2,:);
negBtrain = negScoresB(train2,:);
% negCtrain = negScoresC(train2,:); 
negDtrain = negScoresD(train2,:);

% Final results
Xtrain = [Xtrain1; Xtrain2];     % Training samples, including positive and negative samples; corresponding labels and scores below
Ltrain = [Ltrain1; Ltrain2];     % Training labels, including positive and negative samples
Ytrain = [posYtrain; negYtrain]; % Processed score samples for training, including positive and negative samples
Atrain = [posAtrain; negAtrain]; % ScoresA for training, including positive and negative samples
Btrain = [posBtrain; negBtrain]; % ScoresB for training, including positive and negative samples
% Ctrain = [posCtrain; negCtrain]; % ScoresA for training, including positive and negative samples 
Dtrain = [posDtrain; negDtrain]; % ScoresB for training, including positive and negative samples

Xtest = [Xtest1; Xtest2];        % Testing samples, including both positive and negative; corresponding labels and scores below
Ltest = [Ltest1; Ltest2];        % Testing labels
Atest = [posAtest; negAtest];    % ScoresA for testing
Btest = [posBtest; negBtest];    % ScoresB for testing
% Ctest = [posCtest; negCtest];    % ScoresA for testing 
Dtest = [posDtest; negDtest];    % ScoresB for testing

