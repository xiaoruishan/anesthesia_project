function [pval]=convertPval2Int(pval)
    pval(pval<0.001)=6;
    pval(pval<0.01)=4;
    pval(pval<0.05)=2;
    pval(pval<0.1)=1.000001;
    pval(pval>=0.1 & pval<=1)=0;
end