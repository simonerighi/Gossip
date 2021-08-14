function [Sim,S1,S2,S_IX]=similarity(R)

threshold_similar=1;
N=length(R);
Sim=zeros(N,N);
S1=zeros(N,1);
S2=zeros(N,1);

for i=1:N
    for j=1:N
        Sim(i,j)=(1/(N*100))*sum(abs(R(i,:)-R(j,:))); % Sim_ij= (1/100*N)*sum_z (abs(R_iz - R_jz))
    end
    S1(i)=sum(Sim(i,:)<threshold_similar) - 1; % number of other individuals similar to this one
    S2(i)=mean(Sim(i,:));
end
S_IX=sum(sum(Sim))/(N*(N-1));

S1=S1';
S2=S2';