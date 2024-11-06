% this function return accuracy, sensitivity and specificity, etc
% + Fscore,Precision,true_pos,true_neg
% function [accuracy,sensitivity,specificity,Fscore,Precision,true_pos,true_neg] = AccSenSpe(yRec,ylabel,varargin)
% Input: yRec: predicted y vector, 
%        ylabel: Ground truth, 
%        varargin: b- bias (for logistic output y), default is zero vector
% Output: accuracy,sensitivity,specificity,Fscore,Precision,true_pos,true_neg


function [accuracy,sensitivity,specificity,Fscore,Precision,true_pos,true_neg] = my_AccSenSpe(yRec,ylabel,varargin)

if isempty(varargin)
    b = zeros(length(yRec));
else 
    b = varargin{1};
end

Not_nan_ind = ~isnan(yRec);
yRec = yRec(Not_nan_ind);
ylabel = ylabel(Not_nan_ind);
b = b(Not_nan_ind);

yp = sign(yRec+b); 
accuracy = sum(yp  == ylabel)./size(ylabel,1); 

true_pos = sum((yp == 1) .* (ylabel==1)); 
sensitivity = true_pos/sum(ylabel==1); 
sensitivity(find(isinf(sensitivity))) = eps; 
sensitivity(find(isnan(sensitivity))) = eps; 

true_neg = sum((yp == -1) .* (ylabel==-1)); 
specificity = true_neg/sum(ylabel==-1);
specificity(find(isinf(specificity))) = eps;  
specificity(find(isnan(specificity))) = eps;

% calculate the F-score
% reference: http://en.wikipedia.org/wiki/F1_score
Precision = true_pos/sum(yp == 1); 
Precision(find(isinf(Precision))) = eps; 
Precision(find(isnan(Precision))) = eps;
Recall = sensitivity; 
n = 1^2; % weight between precision and recall for the F-score
Fscore = (1+n)*Precision*Recall/(n*Precision+Recall); % f-measure=2PR/(P+R)
Fscore(find(isinf(Fscore))) = eps;  
Fscore(find(isnan(Fscore))) = eps;
