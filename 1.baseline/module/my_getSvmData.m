

function svmData = my_getSvmData(trainData,trainFlag,testData,testFlag,cmd)


L_SVM_MMR = svmtrain(trainFlag, trainData, cmd);
[~, Lacc, Ldec] = svmpredict(testFlag, testData, L_SVM_MMR);

[FP,TP,~,lauc] = perfcurve(testFlag,Ldec,1);

% [SVMtp,SVMtn]
[SVMacc,SVMsen,SVMspec,SVMfscore,SVMprec,~,~] = my_AccSenSpe(Ldec,testFlag);

svmData.SVMacc = Lacc(1,1);   % Classification accuracy calculated by SVM
svmData.auc = lauc;           % Area Under the Curve (AUC), where higher values indicate better performance
svmData.Ldec = Ldec;          % Save predicted labels
svmData.Ltest = testFlag;     % Save test labels
svmData.tp=TP;
svmData.fp=FP;

svmData.acc=SVMacc;         % SVM.acc:  accuracy 
svmData.sen=SVMsen;         % SVM.sen:  sensitivity 
svmData.spec=SVMspec;       % SVM.spec: specificity 
svmData.fscore=SVMfscore;	% SVM.Fscore: fscore f-measure: 2PR/(P+R)
svmData.prec=SVMprec;       % SVM.Prec:	precision 


end

