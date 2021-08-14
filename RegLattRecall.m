function AltersOfIatT=RegLattRecall(N,mu,RegLatVct)
% This function takes the original lattice (used to create a setup with an
% equal number of interaction partners per agents and randomize the
% connections, so to have for each agent mu new interaction partners at each time
% step.

[CIJ] = randomizer_bin_und2(RegLatVct,1); %randomizes a binary undirected network, while preserving the degree distribution.
AltersOfIatT=zeros(N,mu);

% for each agent i write into a matrix his interaction partners for this
% time step.
for i=1:N
    AltersOfIatT(i,:)=find(CIJ(i,:)>0);
end
    
