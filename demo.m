% This script runs a demo of the model where the baseline results
% (reported in Figure 1 and the associated distribution of results) are reproduced and printed as a graphs.
%
% The function generates one .mat containing 10 individual simulations for
% each parameter set explored.
%
% Time for running the demo on a MacBookPro 2019 with 8 cores: 1000 seconds
% (16 minutes).
%
% It is possible to exactly replicate the simulations for the baseline
% setting Nite=100 (running time is 10 times longer).

clear all

SimName=['Demo'];

% PARAMETERS
Niter=10;
N=200; % number of agents
mu=6; %number of partners
tmax=1000; %maximum number of time steps
type_payoff='s'; % s=sum, a=average;
nu=mu; % number of intractions used to compute payoffs
MAXC=100; % maximum c
DeltaR=0.1; % movement of R as consequence of a change
delta=N; % number of gossip acts
shuffle_partners_at_each_step=1; % shall each player get new partners selected at each step?
memory=Inf; % set below inf if you want limited memory
info_always_uptodate=1; % is the information retreived at each time step or only upon communciation?   
timestheinteractions=1; % how many times the social interactiosn there is gossip?

% EXPLORATIONS
% Here is say that i want to run 100 simulations for each of these
% parameter conditons (meaning is explained below):
type_comunication=['riz';'riz';'rep';'all';'onc'];  % whic information is passed with cossip?
gossip=[0; 1; 1; 1; 1]; % is gossip active?
type_choice_gossip_partner=['ra';'ra';'ra';'ra';'ra']; % how the is gossip partner selected?
type_choice_gossiped=['rp';'rp';'rp';'rp';'rp']; % how is the gossip target selected?


% type_choice_gossip_partner % ra=uniformly at random among all agents; 
                                 % pr=proportionally to R(i,j); 
                                % ri= uniformly at random among last round interacting partners; 
                                 % pi=proportionally to R(i,j), but among onnly the last round interaction partners
%type_choice_gossiped='rp'; % ri=uniformly at random from individual among the last interaction partners of ego
                            % rp= uniformly at random in the whole population
                            % su= proportional to the surpriseness of the behaviour relative to the expected one
                            % hr=  the guy gossips people with social reputation higher than what "i" would
                            %      attribute to him: proportional to to | R_ij-Rj_mean | if Rij<Rj_mean
                            % si= gossip about individuals that are similar in social reputation to "i": proportional to 100 - |  R_i_medio - Rj_medio |
                            % rj= choice is inversely proportional to social reputation Rj 
type_belief_update='ab';   % ab= always believe what the gossiper says (THIS IS THE ONLY VERSION OF THE CODE ACTIVE)
                           % tr= j belives i iff Rji>alpha
                           % bc= j belives iff the information passed is close enough to the prior of j toward z
%type_comunication:        % riz= j passes the R_jz to i, so that i can update R_iz
                           % rep= j passes to i the reputation that z has
                           % of i: Rzi, i can then condition on its
                           % behaviour on what the other believes,
                           % projecting his threshold on him
                           % all= j passes to i the reputation that z has
                           % of i and c_z as well. Perfect information
                           % onc= only c is passed, the receiving
                           % individual compares it with his own Riz                          



% UNUSED VARIABLES (THEY ARE NOT USED IN THE CURRENT VERSION OF THE MODEL, KEPT FOR SIMPLICITY OF CODING)
absolutethreshold=1; % are threshold absolute or relative (deactivated variable)


prop_coop=zeros(length(gossip),Niter,tmax);
touched=zeros(length(gossip),Niter);

tic
for i=1:length(gossip)
    type_comunication_this=type_comunication(i,:);
    type_choice_gossip_partner_this=type_choice_gossip_partner(i,:);
    type_choice_gossiped_this=type_choice_gossiped(i,:);
    gossip_this=gossip(i);
    display(['Simulation number ' num2str(i) ' out of ' num2str(length(gossip))]);
    
    parfor iter=1:Niter
        
        if touched(i,iter)==0
            %display([SimName ' - NumSim ' num2str(iter) ' out of ' num2str(Niter) ' - Commu type: ' num2str(i) ' of 5 (' type_comunication(i,:) ') - Gossip' num2str(gossip(i))]);
            
            [prop_coop_out,~,~,~,~,~,~,~,~,~,~,~]=...
                Gossip_fct_temporal(N,mu,tmax,type_payoff,NaN,NaN,NaN,nu,MAXC,DeltaR,type_choice_gossip_partner_this,type_choice_gossiped_this,...
                type_comunication_this,type_belief_update,gossip_this,NaN,memory,NaN,timestheinteractions,absolutethreshold,shuffle_partners_at_each_step,info_always_uptodate);
            prop_coop(i,iter,:)=prop_coop_out';
            
            touched(i,iter)=1; %for validation of done simulation
        end
    end
    
    save([SimName '.mat']);
end
toc


commstypes=['riz';'rep';'all';'onc'];
gossiptarget=['ri';'rp';'su';'hr';'si';'rj'];
gossippartnertypes=['ra';'pr';'ri';'pi'];

commstypes_num=[0 1 2 3];
gossiptarget_num=[0 1 2 3 4 5];
gossippartnertypes_num=[0 1 2 3];

% transform the textual names into numbers
for i=1:length(gossip)
    [type_comunication_num(i),type_choice_gossiped_num(i),type_choice_gossip_partner_num(i)]=turn_names_into_numbers_fig(type_comunication(i,:),type_choice_gossiped(i,:),type_choice_gossip_partner(i,:));
end


cooperation_levels_mean=squeeze(mean(prop_coop,2)); % I average on simulations
cooperation_levels_std=squeeze(std(prop_coop,0,2)); % note here i compute the std across simulation
time=[1:tmax];

numfig=1; % counter for the figures numbers

figure(numfig)
semilogx(time,cooperation_levels_mean(1,:),'b','Linewidth',3); %,cooperation_levels_std(1,:)
hold on
semilogx(time,cooperation_levels_mean(2,:),'k','Linewidth',3); % ,cooperation_levels_std(2,:)
hold on
semilogx(time,cooperation_levels_mean(3,:),'r','Linewidth',3); %,cooperation_levels_std(3,:)
hold on
semilogx(time,cooperation_levels_mean(4,:),'m','Linewidth',3); %,cooperation_levels_std(4,:)
hold on
semilogx(time,cooperation_levels_mean(5,:),'g','Linewidth',3); % ,cooperation_levels_std(5,:)
ax = gca; % current axes
ax.FontSize = 14;
title({'Average cooperation level for'; 'different contents of gossip'; ['Partner Sel: ' 'RA' ' - Target Sel: '  'RP']},'FontSize',20);
ylabel('Proportion of Cooperation','FontSize',20);
xlabel('Time','FontSize',20);
legend('no gossip','Gossip updates R_{iz}','Pass only R_{zi}','Pass R_{zi} and c_z','Pass only C_z','location','northwest');
name_file=['Demo_Temporal'];
saveas(numfig,name_file,'png')

numfig=numfig+1;
figure(numfig)
subplot(2,3,1)
histogram(prop_coop(1,:,1000))
ax = gca;
ax.FontSize = 14;
ylabel('Cooperation','FontSize',16)
xlabel('No Gossip','FontSize',16);
hold on
subplot(2,3,2)
histogram(prop_coop(2,:,1000))
ax = gca;
ax.FontSize = 14;
xlabel('Gossip updates R_{iz}','FontSize',16);
hold on
subplot(2,3,3)
histogram(prop_coop(3,:,1000))
ax = gca;
ax.FontSize = 14;
xlabel('Pass only R_{zi}','FontSize',16)
subplot(2,3,4)
ylabel('Cooperation','FontSize',16)
histogram(prop_coop(4,:,1000))
ax = gca;
ax.FontSize = 14;
xlabel('Pass R_{zi} and c_{z}','FontSize',16)
subplot(2,3,5)
histogram(prop_coop(5,:,1000))
ax = gca;
ax.FontSize = 14;
xlabel('Pass only C_{z}','FontSize',16)
sgtitle({'Distribution of cooperation levels at t_{max}'; ['Partner Sel: ' 'RA' ' - Target Sel: '  'RP']}, 'FontSize',20)
name_file=['Demo_distribution'];
saveas(numfig,name_file,'png')


