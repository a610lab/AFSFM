
function RunFunction2_impro_SVR2_lambda_4_add_age_sex_lon(groupSelect,mergeDataSelect,regScoreSelect,kFold,subFold,svmParc,svmParg,parsLambda1,parsLambda2,parsLambda3,parsLambda4,parsIte,meanSelect,matName,isYscoresCentering)
% groupSelect: NCvsPD NCvsSWEDD PDvsSWEDD
% mergeDataSlect:feature combinations
% kFold£º Perform kFold division of samples
% subFold£ºNumber of subsets for each division
% svmParc£º libsvm parameter setting
% svmParg£º libsvm parameter setting

disp(groupSelect);
disp(mergeDataSelect);
disp(regScoreSelect);
disp({'isYscoresCentering=',num2str(isYscoresCentering)})

[trainData_b,trainFlag_b,Atrain_b,Btrain_b,Dtrain_b,Ytrain_b]=generage_train_data(groupSelect,mergeDataSelect,regScoreSelect,isYscoresCentering); 
%Remove zero columns.
Is_zero_feature=all(trainData_b==0); 
trainData_b(:,Is_zero_feature)=[];

load final_mat_24m_data;  
dataT1_CSF_DTI=final_mat_24m_data(:,2:end);
dataT1_CSF_DTI=cell2mat(dataT1_CSF_DTI);


T1_G_116=dataT1_CSF_DTI(:,1:116);   % 116 GM
T1_W_116=dataT1_CSF_DTI(:,117:232); % 116 WM
T1_C_116=dataT1_CSF_DTI(:,233:348); % 116 T1_CSF
FA_116=dataT1_CSF_DTI(:,349:464);   % 116 DTI_FA
MD_116=dataT1_CSF_DTI(:,465:580);   % 116 DTI_MD
L1_116=dataT1_CSF_DTI(:,581:696);   % 116 DTI_L1
L2_116=dataT1_CSF_DTI(:,697:812);   % 116 DTI_L2
L3_116=dataT1_CSF_DTI(:,813:928);   % 116 DTI_L3
V1_116=dataT1_CSF_DTI(:,929:1044);  % 116 DTI_V1
V2_116=dataT1_CSF_DTI(:,1045:1160); % 116 DTI_V2
V3_116=dataT1_CSF_DTI(:,1161:1276); % 116 DTI_V3
DSSM=dataT1_CSF_DTI(:,1277:1279);   % scores
label=dataT1_CSF_DTI(:,1280);        % label

age=dataT1_CSF_DTI(:,1281);
sex=dataT1_CSF_DTI(:,1282);

isNC=(label==1);           
isPD=(label==-1);
isSWEDD=(label==2);

IndexStirng=['Index_',groupSelect{3},'_vs_',groupSelect{4}];
load (IndexStirng); % Read cross-validation grouping labels

D=[T1_G_116,T1_W_116,T1_C_116,FA_116,MD_116,L1_116,L2_116,L3_116,V1_116,V2_116,V3_116,DSSM,label,age,sex];	
COMPOSE1=D(eval(groupSelect{1}),:);                 
COMPOSE2=D(eval(groupSelect{2}),:);                       
data=[COMPOSE1;COMPOSE2];

data_T1_G_116=data(:,1:116);   % 116 GM
data_T1_W_116=data(:,117:232); % 116 WM
data_T1_C_116=data(:,233:348); % 116 T1_CSF
data_FA_116=data(:,349:464);   % 116 DTI_FA
data_MD_116=data(:,465:580);   % 116 DTI_MD
data_L1_116=data(:,581:696);   % 116 DTI_L1
data_L2_116=data(:,697:812);   % 116 DTI_L2
data_L3_116=data(:,813:928);   % 116 DTI_L3
data_V1_116=data(:,929:1044);  % 116 DTI_V1
data_V2_116=data(:,1045:1160); % 116 DTI_V2
data_V3_116=data(:,1161:1276); % 116 DTI_V3

depScores=data(:,1277);
sleepScores=data(:,1278);
MoCAScores=data(:,1279);
data_label=data(:,1280);

data_age=data(:,1281);
data_sex=data(:,1282);

flagCOMPOSE1=ones(size(COMPOSE1,1),1);      % Positive sample label
flagCOMPOSE2=-1*ones(size(COMPOSE2,1),1);	% Negative sample label
mergeflag=[flagCOMPOSE1;flagCOMPOSE2];     

data_YScore=[];
for i=1:length(regScoreSelect)
    % depScores sleepScores smellScores MoCAScores
    if(isequal(regScoreSelect{i},'depScores'))
        data_YScore=[data_YScore,eval(regScoreSelect{i})];    
    elseif(isequal(regScoreSelect{i},'sleepScores'))
        data_YScore=[data_YScore,eval(regScoreSelect{i})]; 
    elseif(isequal(regScoreSelect{i},'smellScores'))
        data_YScore=[data_YScore,eval(regScoreSelect{i})]; 
    elseif(isequal(regScoreSelect{i},'MoCAScores'))
        data_YScore=[data_YScore,eval(regScoreSelect{i})]; 
    end
end

data_YScore=[data_YScore,mergeflag];
 

X1=data_T1_G_116;   
X1=my_convert2Sparse_impro(X1); % Subtract the mean from each value, divide by the standard deviation, and convert the result into a sparse matrix.

X2=data_T1_W_116;  
X2=my_convert2Sparse_impro(X2); 

M=data_T1_C_116;  
M=my_convert2Sparse_impro(M); 

Y=data_FA_116;
Y=my_convert2Sparse_impro(Y); 

Z=data_MD_116;
Z=my_convert2Sparse_impro(Z); 

L1=data_L1_116;
L1=my_convert2Sparse_impro(L1); 

L2=data_L2_116;
L2=my_convert2Sparse_impro(L2); 

L3=data_L3_116;
L3=my_convert2Sparse_impro(L3); 

V1=data_V1_116;
V1=my_convert2Sparse_impro(V1); 

V2=data_V2_116;
V2=my_convert2Sparse_impro(V2); 

V3=data_V3_116;
V3=my_convert2Sparse_impro(V3); 

A=[data_age,data_sex,depScores,sleepScores,MoCAScores];
A=my_convert2Sparse_impro(A);

L=data_YScore;
if(isYscoresCentering==1)  
    L=my_convert2Sparse_impro(L); 
end

mergeData=[];
for mLen=1:length(mergeDataSelect)   % mergeDataSlect 'X1','L1','V1'
    mergeData=[mergeData,eval(mergeDataSelect{mLen})];
end
mergeYScore=L;              


pars.k1 = subFold; 
parc = svmParc; % Parameter settings in libsvm
parg = svmParg; % Parameter settings in libsvm

pars.lambda1 = parsLambda1;
pars.lambda2 = parsLambda2;
pars.lambda3 = parsLambda3;
pars.lambda4 = parsLambda4;
pars.Ite=parsIte;


posSampleNum=length(flagCOMPOSE1);

%Remove zero columns.
mergeData(:,Is_zero_feature)=[];

Xpar1=mergeData(1:posSampleNum,:);      
Xpar2=mergeData(posSampleNum+1:end,:);	

Ypar1=mergeYScore(1:posSampleNum,:);        
Ypar2=mergeYScore(posSampleNum+1:end,:);	

 % depScores sleepScores smellScores MoCAScores
scoresApar1=depScores(1:posSampleNum,:);
scoresApar2=depScores(posSampleNum+1:end,:);
scoresBpar1=sleepScores(1:posSampleNum,:);
scoresBpar2=sleepScores(posSampleNum+1:end,:);
% scoresCpar1=smellScores(1:posSampleNum,:);
% scoresCpar2=smellScores(posSampleNum+1:end,:);  
scoresDpar1=MoCAScores(1:posSampleNum,:);
scoresDpar2=MoCAScores(posSampleNum+1:end,:);

labelPar1=flagCOMPOSE1;           % Positive sample label
labelPar2=flagCOMPOSE2;           % Negative sample label

tic
len4=length(pars.lambda4);
len3=length(pars.lambda3);  
len2=length(pars.lambda2);
len1=length(pars.lambda1);
TOTAL=len1*len2*len3*len4;   

SelectFeaIdx=cell(kFold,pars.k1);  
W=cell(kFold,pars.k1);              
Ite=pars.Ite;                       

Res1=my_initialRes_impro_uar; 

meanDegree=meanSelect;  % selection threshold

for l4=1:len4
    lamb4=pars.lambda4(l4); 
    for l3 = 1:len3 
        lamb3=pars.lambda3(l3); 
        for l2 = 1:len2 
            lamb2=pars.lambda2(l2); 
            for l1 = 1:len1  
                lamb1=pars.lambda1(l1); 
                singleStartTime=toc;             
                hasFinished=(l4-1)*len3*len2*len1+(l3-1)*len2*len1+(l2-1)*len1+l1; 
                fprintf('Doing£ºl4=%d/%d l3=%d/%d l2=%d/%d l1=%d/%d.\nAfter this will finish:%.2f%%(%d/%d) %.2f%%\n',l4,len4,l3,len3,l2,len2,l1,len1,hasFinished/TOTAL*100,hasFinished,TOTAL,Res1.svmUar*100);

                for kk = 1:kFold %Kfold
                    indPar1=ind1(:,kk);
                    indPar2=ind2(:,kk);
                    parfor ii = 1:pars.k1 

                        [trainData,trainFlag,testData,testFlag,Atrain,Atest,Btrain,Btest,Dtrain,Dtest,Ytrain] = my_Gen_samplesY2_impro_lon(...
                            Xpar1,Xpar2,...             % X Positive sample/Negative sample label
                            Ypar1,Ypar2,...             % Positive sample/Negative sample label scores+lable
                            scoresApar1,scoresApar2,...	% Positive sample/Negative sample label depScores
                            scoresBpar1,scoresBpar2,...	% Positive sample/Negative sample label sleepScores
                            scoresDpar1,scoresDpar2,... % Positive sample/Negative sample label MoCAScores
                            labelPar1,labelPar2,...     % Positive sample/Negative sample label label
                            indPar1,indPar2,...         % k-th Positive sample/Negative sample split
                            ii);
                        trainData=[trainData;trainData_b];
                        trainFlag=[trainFlag;trainFlag_b];
                        Atrain=[Atrain;Atrain_b];
                        Btrain=[Btrain;Btrain_b];
                        Dtrain=[Dtrain;Dtrain_b];
                        Ytrain=[Ytrain;Ytrain_b];
                       
                        warning('off');

                        [W{kk,ii}] = AFSFM(trainData',trainFlag,Ytrain,lamb1,lamb2,lamb3,lamb4,size(Ytrain,2));  
                        
                        % feature selection  
                        normW = sqrt(sum(W{kk,ii}.*W{kk,ii},2)); 
                        normW( normW <= meanDegree * mean(normW) )=0; 
                        SelectFeaIdx{kk,ii} = find(normW~=0); 

                        newTrainData = trainData(:,SelectFeaIdx{kk,ii});
                        newTestData = testData(:,SelectFeaIdx{kk,ii});
                        
                        %associate weights with brain regions
                        W{kk,ii}= Recover_weight(W{kk,ii},Is_zero_feature);

                        [fsAcc(kk,ii),fsSen(kk,ii),fsSpec(kk,ii),fsPrec(kk,ii),maxFscore(kk,ii),fsAuc1(kk,ii),...
                            maxAcc1(kk,ii),minArmse1(kk,ii),maxBcc1(kk,ii),minBrmse1(kk,ii),maxDcc1(kk,ii),minDrmse1(kk,ii),...
                            Rs1{kk,ii},Ra1{kk,ii},Rb1{kk,ii},Rd1{kk,ii}]=my_combineSVM_SVR_maxFS_impro_SVR2_add_age_sex_lon_impro(...
                            newTrainData,trainFlag,Atrain,Btrain,Dtrain,...
                            newTestData,testFlag,Atest,Btest,Dtest,parc,parg);
                        
                    end
                end            

                singleEndTime=toc; 
                fprintf('time taken for this iteration: %f\n',singleEndTime-singleStartTime);
                Res1=my_updateRes_impro_lambda_4_lon_impro_uar(Res1,fsAcc,fsSen,fsSpec,fsPrec,maxFscore,fsAuc1,...
                    maxAcc1,minArmse1,maxBcc1,minBrmse1,maxDcc1,minDrmse1,...
                    Rs1,Ra1,Rb1,Rd1,l1,l2,l3,l4,SelectFeaIdx,W); 
            end
        end
    end    
end



toc
endTime=toc;
fprintf('%fs\n',endTime);
fprintf('%s_vs_%s\n',groupSelect{3},groupSelect{4});
save(matName,'Res1');



%    SVM for classification on class label
% cc:
% rmse:
% SVM.acc:  accuracy 
% SVM.sen:  sensitivity 
% SVM.spec: specificity 
% SVM.Fscore: fscore f-measure: 2PR/(P+R)
% SVM.Prec:	precision 
% SVM.auc:	AUC

end



