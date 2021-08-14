function OutDatedInfoVsAmountGossip_alternative(initial,final,iter)
% This simulations focus on two method where only c_z and both c_z and R_zi
% are passed. They compare, for different amounts of gossip, the cases when
% information is up-to-date and those in which is not kept up-to-date.
%This function runs 1 simulation on a single parameter set at the time, when called by the
%runner03 function.


SimName=['OutDatedInfoVsAmountGossip_alternative_' num2str(initial) '_' num2str(final) '_' num2str(iter)];


% UNEXPLORED PARAMETERS
Niter=100;
warning off
% PARAMETERS
N=200; % number of agents
mu=6; %number of partners
tmax=1000; %maximum number of time steps
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
%timestheinteractions=1; 
gossip=1; %is there gossip at all?

%MANIPULATED VARS
type_comunication_template=['all';'all';'onc';'onc'];
info_always_uptodate_template=[0;1;0;1]; % is the information retreived at each time step or only upon communciation?   
timestheinteractions_vct=[1 2 5 10 30 50]; % how many times the social interactiosn there is gossip?

commstypes=['riz';'rep';'all';'onc'];
gossippartnertypes=['ra';'pr';'ri';'pi'];
gossiptarget=['ri';'rp';'su';'hr';'si';'rj'];

% introduce fist simulation without gossip
type_comunication=[]; 
info_always_uptodate=[];
type_choice_gossip_partner=[];
type_choice_gossiped=[];
timestheinteractions=[];

for h=1:length(timestheinteractions_vct) % for all timestheinteraction
    for j=1:4 % for all partners selections
        for z=1:6 % for all target selections
            type_comunication=[type_comunication;type_comunication_template];
            info_always_uptodate=[info_always_uptodate;info_always_uptodate_template];
            for aa=1:4 % for each of the members of the template
                timestheinteractions=[timestheinteractions;timestheinteractions_vct(h)];
                type_choice_gossip_partner=[type_choice_gossip_partner;gossippartnertypes(j,:)];
                type_choice_gossiped=[type_choice_gossiped;gossiptarget(z,:)];
            end
        end
    end
end




prop_coop=zeros(4*6*4*length(timestheinteractions_vct),Niter);
ctavg=zeros(4*6*4*length(timestheinteractions_vct),Niter);
ctstd=zeros(4*6*4*length(timestheinteractions_vct),Niter);
DeriddaIX_C=zeros(4*6*4*length(timestheinteractions_vct),Niter);
NClu_C=zeros(4*6*4*length(timestheinteractions_vct),Niter);
DeriddaIX_R=zeros(4*6*4*length(timestheinteractions_vct),Niter);
NClu_R=zeros(4*6*4*length(timestheinteractions_vct),Niter);
S_IX=zeros(4*6*4*length(timestheinteractions_vct),Niter);
polariz=zeros(4*6*4*length(timestheinteractions_vct),Niter);
VarR=zeros(4*6*4*length(timestheinteractions_vct),Niter);
Diver=zeros(4*6*4*length(timestheinteractions_vct),Niter);
Rsq=zeros(4*6*4*length(timestheinteractions_vct),Niter);

touched=zeros(4*6*4*length(timestheinteractions_vct),Niter);


i=initial;

type_comunication_this=type_comunication(i,:);
info_always_uptodate_this=info_always_uptodate(i,:);
type_choice_gossip_partner_this=type_choice_gossip_partner(i,:);
type_choice_gossiped_this=type_choice_gossiped(i,:);
timestheinteractions_this=timestheinteractions(i);

display(num2str(iter))
[prop_coop(i,iter),ctavg(i,iter),ctstd(i,iter),DeriddaIX_C(i,iter),NClu_C(i,iter),DeriddaIX_R(i,iter),NClu_R(i,iter),S_IX(i,iter),polariz(i,iter),VarR(i,iter),Diver(i,iter),Rsq(i,iter)]=...
    Gossip_fct(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner_this,type_choice_gossiped_this,...
    type_comunication_this,type_belief_update,gossip,gamma,memory,noise,timestheinteractions_this,absolutethreshold,shuffle_partners_at_each_step,info_always_uptodate_this);

touched(i,iter)=1;

save([SimName '.mat']);



