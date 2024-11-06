function [trainData,trainFlag,Atrain,Btrain,Dtrain,Ytrain]=generage_train_data(groupSelect,mergeDataSelect,regScoreSelect,isYscoresCentering)
%Train data
%
%
% load PPMI_T1_T1_DTI_CSF_DSSM_Label_208;
load PPMI_238_62NC_142PD_34SWEDD_mat_add_age_sex;
dataT1_CSF_DTI=PPMI_238_62NC_142PD_34SWEDD_mat_add_age_sex(:,2:end);
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
DSSM=dataT1_CSF_DTI(:,1277:1280);   % scores
label=dataT1_CSF_DTI(:,1281);        % label

age=dataT1_CSF_DTI(:,1282);
sex=dataT1_CSF_DTI(:,1283);

isNC=(label==1);           
isPD=(label==-1);
isSWEDD=(label==2);
   
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
smellScores=data(:,1279);
MoCAScores=data(:,1280);
data_label=data(:,1281);

data_age=data(:,1282);
data_sex=data(:,1283);


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
for mLen=1:length(mergeDataSelect)   
    mergeData=[mergeData,eval(mergeDataSelect{mLen})];
end

mergeYScore=L;            

%set train data
%[trainData,trainFlag,testData,testFlag,Atrain,Atest,Btrain,Btest,Ctrain,Ctest,Dtrain,Dtest,Ytrain]
trainData=mergeData;
trainFlag=mergeflag;
Atrain=depScores;
Btrain=sleepScores;
Dtrain=MoCAScores;
Ytrain=mergeYScore;

end