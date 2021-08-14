function ContentOfGossip_temporal_theta(initial, final)
% Content of gossip: here I compare the  mechanisms that i have for partner and target selection (as well as no gossip), 
% under up-to-date information, no noise, infinite memory.
%This function runs simulations on parameter set at the time, when called by the
%runner06 function.

SimName=['ContentOfGOssip_theta_' num2str(initial) '_' num2str(final)];

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
%type_comunication='all';   % riz= j passes the R_jz to i, so that i can update R_iz
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
info_always_uptodate=1; % is the information retreived at each time step or only upon communciation?   
timestheinteractions=1; % how many times the social interactiosn there is gossip?

gamma=NaN;

% VARIABLES FOR EXPLORATION
type_comunication=['riz';'all';'onc']; %note: the first 'riz' is useless as it is associated to no gossip
gossip=[0 1 1]; %is there gossip at all?
DDeltaR=[0.01 0.05 0.1 0.15 0.2];

prop_coop=zeros(2,5,Niter,tmax);
ctavg=zeros(2,5,Niter);
ctstd=zeros(2,5,Niter);
DeriddaIX_C=zeros(2,5,Niter);
NClu_C=zeros(2,5,Niter);
DeriddaIX_R=zeros(2,5,Niter);
NClu_R=zeros(2,5,Niter);
S_IX=zeros(2,5,Niter);
polariz=zeros(2,5,Niter);
VarR=zeros(2,5,Niter);
Diver=zeros(2,5,Niter);
Rsq=zeros(2,5,Niter);

touched=zeros(2,5,Niter);

if isfile([SimName '.mat'])
    load(SimName);
end

for j=initial:final
    DeltaR=DDeltaR(j);
    for i=1:3
        type_comunication_this=type_comunication(i,:); %note: the first 'riz' is useless as it is associated to no gossip
        gossip_this= gossip(i); %is there gossip?
        
        parfor iter=1:Niter
            
            if touched(i,j,iter)==0
                display([SimName ' - NumSim ' num2str(iter) ' out of ' num2str(Niter) ' - Commu type: ' num2str(i) ' of 5 (' type_comunication(i,:) ') - Gossip' num2str(gossip(i))]);
                
                [prop_coop_out,ctavg(i,j,iter),ctstd(i,j,iter),DeriddaIX_C(i,j,iter),NClu_C(i,j,iter),DeriddaIX_R(i,j,iter),NClu_R(i,j,iter),S_IX(i,j,iter),polariz(i,j,iter),VarR(i,j,iter),Diver(i,j,iter),Rsq(i,j,iter)]=...
                    Gossip_fct_temporal(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner,type_choice_gossiped,...
                    type_comunication_this,type_belief_update,gossip_this,gamma,memory,noise,timestheinteractions,absolutethreshold,shuffle_partners_at_each_step,info_always_uptodate);
                prop_coop(i,j,iter,:)=prop_coop_out';
                
                touched(i,j,iter)=1;
            end
        end
        
        save([SimName '.mat']);
    end
end


