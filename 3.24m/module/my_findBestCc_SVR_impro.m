function [maxCc,ccRmse,ccDec,ccTest,ccBest_X,ccBest_Y]=...
    my_findBestCc_SVR_impro(matCc,matRmse,matDec,matTest)

    [~,cc_Index]=sort(matCc(:),'descend');
    maxMapIndex=-1;
    for i=1:length(cc_Index)
        if matRmse(cc_Index(i))<=10
            maxMapIndex=cc_Index(i);
            break;
        end
    end
    if maxMapIndex==-1
        maxCc=0;
        ccRmse=8888;
        ccDec=[];
        ccTest=[];
        ccBest_X=0;
        ccBest_Y=0;
    else
        [x,y]=ind2sub(size(matCc),maxMapIndex);
        maxCc=matCc(x,y);
        ccRmse=matRmse(x,y);
        ccDec=matDec{x,y};
        ccTest=matTest{x,y};
        ccBest_X=x;
        ccBest_Y=y;
    end
end









