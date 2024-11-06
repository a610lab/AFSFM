function svrData = my_getSvrData(trainData,trainScoresA,testData,testScoresA,cmd)


    A_SVR_MMR = svmtrain(trainScoresA, trainData, cmd);
    % Apre_MMR is the predicted value, and the second parameter of Aacc is the mean squared error
    % Aacc = sum(T.*T) / n, where T is the error and n is the sample size; 
    % Aacc£ºa vector with accuracy, 
    %       mean squared error, 
    %       squared correlation coefficient
    % Adec£ºIf selected, probability estimate vector 
    

    [ ~, Aacc, Adec ] = svmpredict(testScoresA, testData, A_SVR_MMR);
    if Aacc(1,1)==0 
        Adec(isinf(Adec)) = eps;  
        Adec(isnan(Adec)) = eps; 
        Adec(~isreal(Adec)) = eps;
        Aacc(isinf(Aacc)) = eps;   
        Aacc(isnan(Aacc)) = eps;  
        Aacc(~isreal(Aacc)) = eps;
        svrData.ccSqrt=sqrt(Aacc(3,1)); 
 
    else 
        svrData.ccSqrt=0.5; 
    end
    
    svrData.Adec=Adec;              
    svrData.RMSE=sqrt(Aacc(2,1));	
    svrData.ccOrg=Aacc(3,1);
    svrData.Atest=testScoresA;

end