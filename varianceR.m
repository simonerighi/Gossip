function VarR=varianceR(R)
% variance: average standard deviation of R(i,:)

VarR=mean(std(R,0,2));

