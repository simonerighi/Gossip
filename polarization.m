function polariz=polarization(N,R)
% Polarization index as in Flache and Mas (2008a)
%The polarization is the variance of pairwise agreement across all pairs of agents in the population,
%where agreement is ranging between ?1 (total disagreement) and +1 (full agreement),
%measured as one minus the average distance of reputations (averaged across
%all N agents).

%Formula: for each i and each j, with i neq j:  aaa=1-mean_j(abs( R(i,z)-R(j,z))) --> rvar(aaa)
polmatrix=zeros(N*N-N,1);
z=0;
for i=1:N
    for j=1:N
        if i~=j
            z=z+1;
            polmatrix(z)=1-((mean(abs(R(i,:)-R(j,:))))/N);
        end
    end
end
polariz=var(polmatrix);
