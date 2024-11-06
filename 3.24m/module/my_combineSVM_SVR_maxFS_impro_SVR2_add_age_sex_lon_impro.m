function [fsAcc,fsSen,fsSpec,fsPrec,maxFscore,fsAuc,maxAcc,AccRmse,maxBcc,BccRmse,maxDcc,DccRmse,Rs,Ra,Rb,Rd]=...
    my_combineSVM_SVR_maxFS_impro_SVR2_add_age_sex_lon_impro(trainData,trainFlag,trainScoresA,trainScoresB,trainScoresD,...
    testData,testFlag,testScoresA,testScoresB,testScoresD,parc,parg)

lparc=length(parc);
lparg=length(parg);


svrDataA{lparc,lparg}=[];
Acc(lparc,lparg)=0;
Armse(lparc,lparg)=0;
Adec{lparc,lparg}=[];
Atest{lparc,lparg}=[];

svrDataB{lparc,lparg}=[];
Bcc(lparc,lparg)=0;
Brmse(lparc,lparg)=0;
Bdec{lparc,lparg}=[];
Btest{lparc,lparg}=[];

svrDataD{lparc,lparg}=[];
Dcc(lparc,lparg)=0;
Drmse(lparc,lparg)=0;
Ddec{lparc,lparg}=[];
Dtest{lparc,lparg}=[];


svmData{lparc,lparg}=[];
SVMacc(lparc,lparg)=0;
SVMsen(lparc,lparg)=0;
SVMspec(lparc,lparg)=0;
SVMprec(lparc,lparg)=0;
SVMauc(lparc,lparg)=0;
SVMfscore(lparc,lparg)=0;
SVMldec{lparc,lparg}=[];
SVMltest{lparc,lparg}=[];
SVMtp{lparc,lparg}=[];
SVMfp{lparc,lparg}=[];


for i=1:lparc
    for j=1:lparg
        cmdSVR1 = ['-t 3 -s 3',' -c ' num2str(2^parc(i)),' -g ' num2str(10^parg(j))]; 
        cmdSVM = ['-t 3 -s 0',' -c ' num2str(2^parc(i)),' -g ' num2str(10^parg(j))];
% ---------------- scoreA SVR ---------------------------     
        svrDataA{i,j} = my_getSvrData(trainData,trainScoresA,testData,testScoresA,cmdSVR1);
        Acc(i,j)=svrDataA{i,j}.ccSqrt;                              
%         Acc2(i,j)=svrData{i,j}.ccOrg;
        Armse(i,j)=svrDataA{i,j}.RMSE;
        Adec{i,j}=svrDataA{i,j}.Adec;
        Atest{i,j}=svrDataA{i,j}.Atest;
        
% ---------------- scoreB SVR ---------------------------   
        svrDataB{i,j} = my_getSvrData(trainData,trainScoresB,testData,testScoresB,cmdSVR1);
        Bcc(i,j)=svrDataB{i,j}.ccSqrt;                              
%         Acc2(i,j)=svrData{i,j}.ccOrg;
        Brmse(i,j)=svrDataB{i,j}.RMSE;
        Bdec{i,j}=svrDataB{i,j}.Adec;
        Btest{i,j}=svrDataB{i,j}.Atest;
        
% ---------------- scoreD SVR ---------------------------   
        svrDataD{i,j} = my_getSvrData(trainData,trainScoresD,testData,testScoresD,cmdSVR1);
        Dcc(i,j)=svrDataD{i,j}.ccSqrt;                              
%         Acc2(i,j)=svrData{i,j}.ccOrg;
        Drmse(i,j)=svrDataD{i,j}.RMSE;
        Ddec{i,j}=svrDataD{i,j}.Adec;
        Dtest{i,j}=svrDataD{i,j}.Atest;

% ---------------- SVM  ---------------------------        
        svmData{i,j} = my_getSvmData(trainData,trainFlag,testData,testFlag,cmdSVM);
       
        SVMacc(i,j)=svmData{i,j}.acc;
        SVMsen(i,j)=svmData{i,j}.sen;
        SVMspec(i,j)=svmData{i,j}.spec;
        SVMprec(i,j)=svmData{i,j}.prec;                              
        SVMauc(i,j)=svmData{i,j}.auc;
        SVMfscore(i,j)=svmData{i,j}.fscore; 
        SVMldec{i,j}=svmData{i,j}.Ldec;
        SVMltest{i,j}=svmData{i,j}.Ltest;
        SVMtp{i,j}=svmData{i,j}.tp;
        SVMfp{i,j}=svmData{i,j}.fp;
    end
end


[maxAcc,AccRmse,AccDec,AccTest,AccBest_X,AccBest_Y]=my_findBestCc_SVR_impro(Acc,Armse,Adec,Atest);

[maxBcc,BccRmse,BccDec,BccTest,BccBest_X,BccBest_Y]=my_findBestCc_SVR_impro(Bcc,Brmse,Bdec,Btest);

[maxDcc,DccRmse,DccDec,DccTest,DccBest_X,DccBest_Y]=my_findBestCc_SVR_impro(Dcc,Drmse,Ddec,Dtest);

[fsAcc,fsSen,fsSpec,fsPrec,fsAuc,maxFscore,fsLdec,fsLtest,fsTP,fsFP,fsBest_X,fsBest_Y]=...
    my_findBestFscore_SVM_impro_uar(SVMacc,SVMsen,SVMspec,SVMprec,SVMauc,SVMfscore,SVMldec,SVMltest,SVMtp,SVMfp);

% Ra！！scoreA   Rb！！scoreB     Rs！！ SVM 
Ra.maxAcc_acc=maxAcc;
Ra.maxAcc_rmse=AccRmse;
Ra.maxAcc_Ldex=AccDec;
Ra.maxAcc_Ltest=AccTest;
Ra.maxAcc_X=AccBest_X;
Ra.maxAcc_Y=AccBest_Y;
 
Rb.maxBcc_Bcc=maxBcc;
Rb.maxBcc_rmse=BccRmse;
Rb.maxBcc_Ldex=BccDec;
Rb.maxBcc_Ltest=BccTest;
Rb.maxBcc_X=BccBest_X;
Rb.maxBcc_Y=BccBest_Y;
 
Rd.maxDcc_Dcc=maxDcc;
Rd.maxDcc_rmse=DccRmse;
Rd.maxDcc_Ldex=DccDec;
Rd.maxDcc_Ltest=DccTest;
Rd.maxDcc_X=DccBest_X;
Rd.maxDcc_Y=DccBest_Y;


Rs.maxSvmFs_auc=fsAuc;
Rs.maxSvmFs_Ldec=fsLdec;
Rs.maxSvmFs_Ltest=fsLtest;
Rs.maxSvmFs_tp=fsTP;
Rs.maxSvmFs_fp=fsFP;
Rs.maxSvmFs_X=fsBest_X;
Rs.maxSvmFs_Y=fsBest_Y;

end





