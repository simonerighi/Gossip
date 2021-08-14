function [DeriddaIX,NClu]=deridda_index(Variable)
% Computes the deridda index and the number of clusters. The deridda index
% is computed as the sum of the square of the number of values in each
% cluster present

% note: the original version of the size of the Number of bins is computed relative to N, so this
% measure as it is is not comparable across Ns. Numbins=0:1/N:100;
% to avoid this i set the number of bins t 100 


Numbins=0:1/length(Variable):100;
[Nhisto,~]=hist(Variable,Numbins);
NClu=length(find(Nhisto>0));
DeriddaIX=sum(Nhisto.*Nhisto)/((length(Variable))^2);