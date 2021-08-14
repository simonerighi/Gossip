function ContentOfGossip_alternative(initial,final)
% Content of gossip: here I compare the  mechanisms that i have for partner and target selection (as well as no gossip), 
% under up-to-date information, no noise, infinite memory.
%This function runs simulations on parameter set at the time, when called by the
%runner01 function.

SimName=['ContentOfGOssip_alternative_' num2str(initial) '_' num2str(final)];

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

% i want to run a simulation for each combination of type_comunication,
% type_choice_gossip_partner, type_choice_gossiped

commstypes=['riz';'rep';'all';'onc'];
gossippartnertypes=['ra';'pr';'ri';'pi'];
gossiptarget=['ri';'rp';'su';'hr';'si';'rj'];

% introduce fist simulation without gossip
type_comunication=['riz']; 
gossip=[0];
type_choice_gossip_partner=['ra'];
type_choice_gossiped=['ri'];

for i=1:4
    for j=1:4
        for z=1:6
            type_comunication=[type_comunication;commstypes(i,:)];
            type_choice_gossip_partner=[type_choice_gossip_partner;gossippartnertypes(j,:)];
            type_choice_gossiped=[type_choice_gossiped;gossiptarget(z,:)];
            gossip=[gossip 1];
        end
    end
end



prop_coop=zeros(97,Niter,tmax);
ctavg=zeros(97,Niter);
ctstd=zeros(97,Niter);
DeriddaIX_C=zeros(97,Niter);
NClu_C=zeros(97,Niter);
DeriddaIX_R=zeros(97,Niter);
NClu_R=zeros(97,Niter);
S_IX=zeros(97,Niter);
polariz=zeros(97,Niter);
VarR=zeros(97,Niter);
Diver=zeros(97,Niter);
Rsq=zeros(97,Niter);
touched=zeros(97,Niter);

if isfile([SimName '.mat'])
    load(SimName);
end

%matlabpool open
for i=initial:final
    type_comunication_this=type_comunication(i,:);
    type_choice_gossip_partner_this=type_choice_gossip_partner(i,:);
    type_choice_gossiped_this=type_choice_gossiped(i,:);
    gossip_this=gossip(i);
    
    parfor iter=1:Niter
        
        if touched(i,iter)==0
            %display([SimName ' - NumSim ' num2str(iter) ' out of ' num2str(Niter) ' - Commu type: ' num2str(i) ' of 5 (' type_comunication(i,:) ') - Gossip' num2str(gossip(i))]);
            
            [prop_coop_out,ctavg(i,iter),ctstd(i,iter),DeriddaIX_C(i,iter),NClu_C(i,iter),DeriddaIX_R(i,iter),NClu_R(i,iter),S_IX(i,iter),polariz(i,iter),VarR(i,iter),Diver(i,iter),Rsq(i,iter)]=...
                Gossip_fct_temporal(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner_this,type_choice_gossiped_this,...
                type_comunication_this,type_belief_update,gossip_this,gamma,memory,noise,timestheinteractions,absolutethreshold,shuffle_partners_at_each_step,info_always_uptodate);
            prop_coop(i,iter,:)=prop_coop_out';
            
            touched(i,iter)=1; %for validation of done simulation
        end
    end
    
    save([SimName '.mat']);
end


%matlabpool close



% h=figure(12);
% variable=prop_coop;
% toplot=mean(variable,3);
% toplot_std=std(variable,0,3);
% errorbar(timestheinteractions,toplot(1,:),toplot_std(1,:),'r')
% hold on
% errorbar(timestheinteractions,toplot(2,:),toplot_std(2,:),'b')
% hold on
% % errorbar(gamma,toplot(3,:),toplot_std(3,:),'k')
% % hold on
% % errorbar(gamma,toplot(4,:),toplot_std(4,:),'g')
% % hold on
% % errorbar(gamma,toplot(5,:),toplot_std(5,:),'r-.')
% % hold on
% % errorbar(gamma,toplot(6,:),toplot_std(6,:),'b-.')
% % hold on
% % errorbar(gamma,toplot(7,:),toplot_std(7,:),'k-.')
% % hold on
% % errorbar(gamma,toplot(8,:),toplot_std(8,:),'g-.')
% %hold on
% %errorbar(gamma,toplot(9,:),toplot_std(9,:),':bo','LineWidth',3)
% xlabel('Times the Interactions','Fontsize',18)
% ylabel('Prop Cooperation','Fontsize',18)
% title('Proportion of Cooperative Actions','Fontsize',18)
% legend('R_{iz}','Only Rjz','All info','Location','best');
% saveas(h,['compare_information_mechanisms.eps'],'epsc');
% clear variable
% 
% 
