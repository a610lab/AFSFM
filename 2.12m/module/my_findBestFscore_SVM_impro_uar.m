function [fsAcc,fsSen,fsSpec,fsPrec,fsAuc,maxFscore,fsLdec,fsLtest,fsTP,fsFP,fsBest_X,fsBest_Y]=...
    my_findBestFscore_SVM_impro_uar(matAcc,matSen,matSpec,matPrec,matAuc,matFscore,matLdec,matLtest,matTP,matFP)

    
%     % -------------------- Fscore -----------------------------
%     maxFscore=max(matFscore(:)); % Find the maximum fscores, which may have duplicates
%     seqIndex=find(matFscore==maxFscore); % Find all indices of the maximum values (by column) if duplicates exist
%     [x,y]=ind2sub(size(matFscore),seqIndex); % Convert indices to matrix coordinates, note x and y are vectors
    
    matUar=(matSen+matSpec)/2;
    maxUar=max(matUar(:));
    seqIndex=find(matUar==maxUar);
    [x,y]=ind2sub(size(matUar),seqIndex);

    maxFscore=[];
    fsAcc=[];
    fsSen=[];
    fsSpec=[];
    fsPrec=[];   
    fsAuc=[];
    fsLdec={};
    fsLtest={};
    fsTP={};
    fsFP={};
    
    fsBest_X=[];   
    fsBest_Y=[];  
    for i=1:length(x)  
        fsBest_X=[fsBest_X,x(i)];
        fsBest_Y=[fsBest_Y,y(i)];
        
        maxFscore=[maxFscore,matFscore(x(i),y(i))];
        fsAcc=[fsAcc,matAcc(x(i),y(i))];        
        fsSen=[fsSen,matSen(x(i),y(i))];
        fsSpec=[fsSpec,matSpec(x(i),y(i))];
        fsPrec=[fsPrec,matPrec(x(i),y(i))];        
        fsAuc=[fsAuc,matAuc(x(i),y(i))];
        
        fsLdec=[fsLdec,matLdec{x(i),y(i)}];
        fsLtest=[fsLtest,matLtest{x(i),y(i)}];
        fsTP=[fsTP,matTP{x(i),y(i)}];
        fsFP=[fsFP,matFP{x(i),y(i)}];
    end
    
    [~,maxMapIndex]=max(fsAcc(:)); 
    maxFscore=maxFscore(maxMapIndex);
    fsAcc=fsAcc(maxMapIndex);
    fsSen=fsSen(maxMapIndex);
    fsSpec=fsSpec(maxMapIndex);
    fsPrec=fsPrec(maxMapIndex);   
    fsAuc=fsAuc(maxMapIndex);
    
    fsLdec=fsLdec{maxMapIndex};
    fsLtest=fsLtest{maxMapIndex};
    fsTP=fsTP{maxMapIndex};
    fsFP=fsFP{maxMapIndex};
    
    fsBest_X=fsBest_X(maxMapIndex);
    fsBest_Y=fsBest_Y(maxMapIndex);

end









