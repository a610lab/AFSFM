

function RunFunProposed_SVR2_lambda_4_add_age_sex_lon(num1,num2,meanSelect,svmParc,svmParg,regScoreSelect,isYscoresCentering)
% num1; %  Select one of the three grouping combinations.  NCvsPD NCvsSWEDD PDvsSWEDD
% num2; % Select one of the feature combinations.
% meanSelect: selection threshold
% svmParc,svmParg SVM parameter
% regScoreSelect£º.
    % depScores sleepScores smellScores MoCAScores 
    % regScoreSelect={'depScores','sleepScores','smellScores','MoCAScores'};  
% isYscoresCentering,centralization



kFold=1;	% Perform kFold division of samples
subFold=5;	
% 
t1=-3:3;  parsLambda1 = 10.^t1;
t2=-3:3;  parsLambda2 = 10.^t2; 
t3=-3:3;  parsLambda3 = 10.^t3;
t4=10;  parsLambda4 = t4;

parsIte=50; % number of iterations

combineSelect1=num1; 
combineSelect2=num2; 

groupSelectCell{1}={'isPD','isNC','PD','NC'};          
groupSelectCell{2}={'isSWEDD','isNC','SWEDD','NC'};
groupSelectCell{3}={'isPD','isSWEDD','PD','SWEDD'};


% X1£ºGM   % X2£ºWM    % M:T1CSF   % Y£ºFA   %Z:MD    %L1 L2 L3    %V1 V2 V3
mergeDataSelectCell{1}={'X1'};              % GM  
mergeDataSelectCell{2}={'X2'};              % WM
mergeDataSelectCell{3}={'M'};               % CSF
mergeDataSelectCell{4}={'Y'};               % FA
mergeDataSelectCell{5}={'Z'};               % MD
mergeDataSelectCell{6}={'L1'};              % L1
mergeDataSelectCell{7}={'L2'};              % L2
mergeDataSelectCell{8}={'L3'};              % L3
mergeDataSelectCell{9}={'V1'};              % V1
mergeDataSelectCell{10}={'V2'};             % V2
mergeDataSelectCell{11}={'V3'};             % V3
mergeDataSelectCell{12}={'X1','L1','V1'};              

groupSelect=groupSelectCell{combineSelect1};
mergeDataSelect=mergeDataSelectCell{combineSelect2};

regScoreShortName=[];

depSelect=0;
sleepSelect=0;
smellSelect=0;
MoCASelect=0;
    
% DSlSm£ºD:depScores,Sl:sleep Sm:smell M:MoCAScores
if(ismember('depScores',regScoreSelect))
    regScoreShortName=[regScoreShortName,'D']; 
    depSelect=1;
end
if(ismember('sleepScores',regScoreSelect))
    regScoreShortName=[regScoreShortName,'Sl'];  
    sleepSelect=1;
end
if(ismember('smellScores',regScoreSelect))
    regScoreShortName=[regScoreShortName,'Sm']; 
    smellSelect=1;
end
if(ismember('MoCAScores',regScoreSelect))
    regScoreShortName=[regScoreShortName,'M'];    
    MoCASelect=1;
end

matNameCell1={{'NCvsPD'},{'NCvsSW'},{'PDvsSW'}};

regSelect=1;  
isCentring='regCentering';
if(isYscoresCentering==0)
    isCentring='noRegCenter';
    regSelect=0;
end

matNameIndexPart1=num2str(regSelect);           
matNameIndexPart2=[num2str(depSelect),num2str(sleepSelect),num2str(smellSelect),num2str(MoCASelect)];   
matNameIndexPart3=num2str(combineSelect1);   
matNameIndexPart4=num2str(combineSelect2);   

matName=[...
    'R',matNameIndexPart1,'_',...
    'D',matNameIndexPart2,'_',...
    matNameIndexPart3,'.',...
    matNameIndexPart4,'.',...
    'Mat_',...
    '_',matNameCell1{combineSelect1}{1},...
    '_','Proposed',...    
    '_',regScoreShortName,...
    '_',isCentring,...
    '_','mean[',num2str(meanSelect*100),']',...
    '_','c[',num2str(min(svmParc)),num2str(max(svmParc)),']',...
    '_','g[',num2str(min(svmParg)),num2str(max(svmParg)),']',...
    '_','p1[',num2str(min(t1)),num2str(max(t1)),']',...
    '_','p2[',num2str(min(t2)),num2str(max(t2)),']',...
    '_','p3[',num2str(min(t3)),num2str(max(t3)),']',...
    '_','p4[',num2str(min(t4)),num2str(max(t4)),']',...
    '_','Ite[',num2str(parsIte),']',...
    '_','SVR2_24m',...
    '.mat'];


RunFunction2_impro_SVR2_lambda_4_add_age_sex_lon(groupSelect,mergeDataSelect,regScoreSelect,kFold,subFold,svmParc,svmParg,parsLambda1,parsLambda2,parsLambda3,parsLambda4,parsIte,meanSelect,matName,isYscoresCentering);

end



