
meanSelect=0.2;   % selection threshold
svmParc=-10:1:10; % libsvm parameter setting
svmParg=-5:1:5;   % libsvm parameter setting


regScoreSelect={'depScores','sleepScores','MoCAScores'};  

csfSelect{4}={''};

finalSelect=[regScoreSelect,csfSelect{4}];

tic
sTime=toc;  

k=1; %centralization

RunFunProposed_SVR2_lambda_4_add_age_sex_lon(2,12,meanSelect,svmParc,svmParg,finalSelect,k)


eTime=toc;  
fprintf('total time spent£º%fs\n',eTime-sTime);




