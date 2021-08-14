function OutDatedInfoVsAmountGossip_populationsize(initial,final,iter)
% This simulations focus on two method where only c_z and both c_z and R_zi
% are passed. They compare, for different amounts of gossip, the cases when
% information is up-to-date and those in which is not kept up-to-date.
%This function runs 1 simulation set  on a single parameter set at the time, when called by the
%runner09 function.

SimName=['OutDatedInfoVsAmountGossip_populationsize' num2str(initial) '_' num2str(final) '_' num2str(iter)];

% UNEXPLORED PARAMETERS
Niter=100; 
warning off
% PARAMETERS
N=200; % number of agents 
mu=6; %number of partners
tmax=1000; %maximum number of time steps %1000
type_payoff='s'; % s=sum, a=average;
time_graphs=1; % set to zero if you don't want the time graphs but just the end results
alpha=0.5;% theshold of Rji reputation for j to believe the gossip of i
betaa=0.5; % max difference in reputation about z to accept gossip from i
Perr=0; % error in the production of information
nu=mu; % number of intractions used to compute payoffs
MAXC=100; % maximum c
DeltaR=0.1; % movement of R as consequence of a change
delta=N; % number of gossip acts
epsilon=0.001; % tie-breaker for ranking of reputations
absolutethreshold=1; % are threshold absolute or relative (deactivated variable)
shuffle_partners_at_each_step=1; % shall each player get new partners selected at each step?

gamma=NaN;

 type_choice_gossip_partner='ra'; % ra=uniformly at random among all agents; 
                                 % pr=proportionally to R(i,j); 
                                 % ri= uniformly at random among last round interacting partners; 
                                 % pi=proportionally to R(i,j), but among onnly the last round interaction partners
 type_choice_gossiped='rp'; % ri=uniformly at random from individual among the last interaction partners of ego
                            % rp= uniformly at random in the whole population
                            % su= proportional to the surpriseness of the behaviour relative to the expected one
                            % hr=  the guy gossips people with social reputation higher than what "i" would
                            %      attribute to him: proportional to to | R_ij-Rj_mean | if Rij<Rj_mean
                            % si= gossip about individuals that are similar in social reputation to "i": proportional to 100 - |  R_i_medio - Rj_medio |
                            % rj= choice is inversely proportional to social reputation Rj 
type_belief_update='ab';   % ab= always believe what the gossiper says
                           % tr= j belives i iff Rji>alpha
                           % bc= j belives iff the information passed is close enough to the prior of j toward z

                           
% EXPLORED PARAMETERS                           
type_comunication='all';   % riz= j passes the R_jz to i, so that i can update R_iz
                           % rep= j passes to i the reputation that z has
                           % of i: Rzi, i can then condition on its
                           % behaviour on what the other believes,
                           % projecting his threshold on him
                           % all= j passes to i the reputation that z has
                           % of i and c_z as well. Perfect information
                           % onc= only c is passed, the receiving
                           % individual compares it with his own Riz                          
noise=[0 0];
%        0.01 0.01;
%        0.05 0.05;
%        0.1 0.1;
%        0.2 0.2]; % noise on  R and on c from gossip                           
 
memory=Inf; % set below inf if you want limited memory
gossip=1; %is there gossip at all?

%MANIPULATED VARS
type_comunication_vct=['all';'onc'];
info_always_uptodate=0; % is the information retreived at each time step or only upon communciation?   
timestheinteractions_vct=[1 2 5 10 30 50]; % how many times the social interactiosn there is gossip?
NN_vct=[50 100 200 400 600];

NN=[];
type_comunication=[];
timestheinteractions=[];

for h=1:5 %NN_vct
    for i=1:6 %timestheinteractions_vct
        for j=1:2 % type_comunication_vct
            NN=[NN;NN_vct(h)];
            type_comunication=[type_comunication;type_comunication_vct(j,:)];
            timestheinteractions=[timestheinteractions;timestheinteractions_vct(i)];
        end
    end
end
            

prop_coop=zeros(2*6*5,Niter);
ctavg=zeros(2*6*5,Niter);
ctstd=zeros(2*6*5,Niter);
DeriddaIX_C=zeros(2*6*5,Niter);
NClu_C=zeros(2*6*5,Niter);
DeriddaIX_R=zeros(2*6*5,Niter);
NClu_R=zeros(2*6*5,Niter);
S_IX=zeros(2*6*5,Niter);
polariz=zeros(2*6*5,Niter);
VarR=zeros(2*6*5,Niter);
Diver=zeros(2*6*5,Niter);
Rsq=zeros(2*6*5,Niter);


touched=zeros(2*6*5,Niter);


z=initial;
N=NN(z);
type_comunication_this=type_comunication(z,:);
info_always_uptodate_this=info_always_uptodate;
timestheinteractions_this=timestheinteractions(z);

[prop_coop(z,iter),ctavg(z,iter),ctstd(z,iter),DeriddaIX_C(z,iter),NClu_C(z,iter),DeriddaIX_R(z,iter),NClu_R(z,iter),S_IX(z,iter),polariz(z,iter),VarR(z,iter),Diver(z,iter),Rsq(z,iter)]=...
    Gossip_fct(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner,type_choice_gossiped,...
    type_comunication_this,type_belief_update,gossip,gamma,memory,noise,timestheinteractions_this,absolutethreshold,shuffle_partners_at_each_step,info_always_uptodate_this);
touched(z,iter)=1;

save([SimName '.mat']);



