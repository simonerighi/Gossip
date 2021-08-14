function [prop_coop,ctavg,ctstd,DeriddaIX_C,NClu_C,DeriddaIX_R,NClu_R,S_IX,polariz,VarR,Diver,Rsq,Prop_true_gossip]=Gossip_fct_temporal(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner,type_choice_gossiped,...
    type_comunication,type_belief_update,gossip,gamma,memory,noise,timestheinteractions,absolutethreshold,change_partners,info_always_uptodate)
% This is the main function that run the model. Once called it runs the
% model with the parameters passed in input. The only constants set in this
% function are those concerning the payoffs from different situations in
% the prisoner dilemma (see paper).
% This is the temporal version of the Gossip_fct version the only
% difference is taht it passes a value for each time of the model instead
% of just the values corresponding to the last step.
% Please see Gossip_fct for details.

warning off

costcomm=0;

prop_coop_temp=zeros(tmax,1);


% CONSTANTS
Temptation=5; % PD values
Reward=3; % check these
Punishment=1;
Sucker=0;

% PRELIMINARY INITIALIZATIONS
R=round(rand(N,N)*100); % uniform random initialization of reputation matrix; ALTERNATIVES: R=X.
if absolutethreshold==1
    c=round(rand(N,1)*100); %threshold for cooperation  % SET TO 50 SO C ALWAYS INITIALLY SMALLER THAN R
else
    c=ceil(rand(N,1)*N); % rank threshold for cooperation: individuals cooperate if the partner is at least in xrank in their Ri: matrix ALTERNATIVES: R=X(LOW MEDIUM HIGH).
    for i=1:round(gamma*N)
        c(i)=-1;% set a proportion gamma of UDs (as OrderOfR\in[1,N], R
    end
    c=c(randperm(N));
end

hasplayed=zeros(N,N); % set to zero the matrix containing agents that have played with each other
knowsof=zeros(N,N);
Cstore=zeros(N,N); % position ij of the matrix contains the information that i has about the threshold of j
Cstore(:,:)=NaN;
Rstore=zeros(N,N); % position ij of the matrix contains the information that i has about the Reputation that  j has of himself
Rstore(:,:)=NaN; % i set these to NaN to distinguish from zero

%CHECKS
[type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner]=turn_names_into_numbers(type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner);
if nu>mu; disp('nu cannot exceed mu, nu setted == mu. Click to continue'); nu=mu; pause; end % control that nu<=mu and if not correct the error.
%minc=min(c);
for i=1:N; R(i,i)=0; end; % no self reputation (for the moment).
Push=round(MAXC*DeltaR); % set the push to reputation (up or down, derived from interactions)

RegLatVct = makeringlatticeCIJ(N,mu*N);
AltersOfIatT=RegLattRecall(N,mu,RegLatVct);
% allofagents=1:1:N; % i create a matrix with only the agents that are not directly linked to i
% NonPartnersOfI=zeros(N,N-mu);
% for i=1:N
%     NonPartnersOfI(i,:)=setdiff(allofagents,AltersOfIatT(i,:));
% end

timeknown=zeros(N,N);

tic
for t=1:tmax
    %clc
    %t
    R_old=R; % every agent only knows the previous R of everybody else
    PayoffsAtT=zeros(N,mu)-1;
    Payoff_evolutionary=zeros(N,1);
    PlayOfAltersOfI=zeros(N,mu);
    if change_partners==1
        AltersOfIatT=RegLattRecall(N,mu,RegLatVct);
    end

    %isinternal=rand(N,mu)>Pout; %check wether for each of the mu interaction she will be made on the network or with a rando guy.


   

    
    for ego=1:N
        
        % ego is randomly coupled with mu agents
        alter=AltersOfIatT(ego,:);

        
        for j=1:mu % or each alter of ego           
            play_ego=compute_move(ego,c,R(ego,alter(j)),noise,knowsof(ego,alter(j)),R(alter(j),ego),alter(j),type_comunication,Cstore,Rstore,info_always_uptodate); %compute move from ego
            play_alter=compute_move(alter(j),c,R(alter(j),ego),noise,knowsof(alter(j),ego),R(ego,alter(j)),ego,type_comunication,Cstore,Rstore,info_always_uptodate); %compute move from alter
            hasplayed(ego,alter(j))=1; % i signal that ego has played with alter(j) 
            hasplayed(alter(j),ego)=1; % i signal that v has played with ego
            PlayOfAltersOfI(ego,j)=play_alter; % mi segno il play del partner
            R(ego,alter(j))=reputation_evolution(play_ego,play_alter,R_old,ego,alter(j),Push); % evolve the reputation of ego toward alter
            [payoff_ego, ~] = Compute_Payoffs (play_ego,play_alter,Punishment,Sucker,Temptation,Reward); % compute payoffs
            PayoffsAtT(ego,j)=payoff_ego;
        end
        Payoff_evolutionary(ego)=compute_final_payoffs(mu,nu,PayoffsAtT(ego,:),type_payoff); % payoff setting (choose nu out of mu inteeractions)
    end
    prop_coop=sum(sum(PlayOfAltersOfI==1))/(mu*N); % count the number of times PlayOfAltersOfI is 1 (Cooperation) and divide for the total number of interactions
    prop_coop_temp(t)=prop_coop;
    
    true_gossip=0;
    % gossip phase
    
    if gossip==1
        Rj=mean(R,1); % i precompute the average reputation received by each j in the matrix (columnwise).
        for j=1:N*mu*timestheinteractions
            ego=ceil(rand*N); % select randomly one agent (even if he has already played).
            alter=chose_gossip_partner(ego,R(ego,:),type_choice_gossip_partner,AltersOfIatT(ego,:),mu);
            other=chose_gossiped_agent(ego,alter,AltersOfIatT(ego,:),R(ego,:),PlayOfAltersOfI(ego,:),type_choice_gossiped,Rj,R);
            %[token_info,Payoff_evolutionary,truthvalue]=passage_of_info(PlayOfAltersOfI(ego,AltersOfIatT(ego,:)==other),R(ego,AltersOfIatT(ego,AltersOfIatT(ego,:)==other)),costcomm,type_comunication,Perr,Payoff_evolutionary);
            %
            if hasplayed(alter,other)==1 
                knowsof(ego,other)=1; 
                timeknown(ego,other)=t; 
                Cstore(ego,other)=c(other);
                Rstore(ego,other)=R(other,ego);
            end % if other has played with ego, then he passes the info to alter, which then knows th threshold and the reputation of ego.
            if type_comunication==0; R=gossip_effect(ego,alter,other,alpha,betaa,R,type_belief_update,R(alter,other),Push); end; % if only weak info is passed then gossip effect according to choice.
            
        end
    end
    
    % after memory periods memory is lost of the past interactions
    %[exeeded_memoryx,exeeded_memoryy]=find(timeknown+memory==t);
    %size(timeknown+memory==t);
    
    knowsof(timeknown+memory==t)=0;
    Cstore(timeknown+memory==t)=NaN; % if memory is exceeded then i set to NaN;
    Rstore(timeknown+memory==t)=NaN; % if memory is exceeded then j set to NaN;
    timeknown(timeknown+memory==t)=0; %this should always be late.
    %sum(sum(knowsof))
    %sum(timeknown+memory==t)
    %N*(N-1)
    %pause
    
    
    
true_gossip=0;
% close all
% scatter(c,Payoff_evolutionary)
% xlabel('c')
% ylabel('Payoff')
% Payoff_evolutionary
% pause(2) 



c=ThresholdEvolution(c,Payoff_evolutionary,AltersOfIatT); % Threshold evolution

% keep track of the relavant variables (
% NOTE: in probes relative to R we should eliminate the
% own value that is set to zero for everybody (but it creates only a
% small bias


end
toc
 

 %Ct=c;
 ctavg=mean(c);
 ctstd=std(c);
 %Rtavg=mean(R,1);
 %Rtstd=std(R,0,1);
 [DeriddaIX_C,NClu_C]=deridda_index(c); 
 [DeriddaIX_R,NClu_R]=deridda_index(mean(R,2)'); % average of the reputation of i according to all ~i
 [~,~,~,S_IX]=similarity(R);
 polariz=polarization(N,R); % polarization index as in Mas & Flache 2008a
 VarR=varianceR(R); % Average std of R(i,:)
 Diver=diversity(N,R); % diversity as in Mas & Flache 2008a
 [~,~,~,~,stats] = regress(c+1,[mean(R,1)' ones(N,1)]);
 Rsq=stats(1);
 Prop_true_gossip=true_gossip/N;
 
 
 
clear prop_coop
prop_coop=prop_coop_temp;
 % TimeGraphs
%  if time_graphs==1
%      TimeGraphs
%  end
 
%plot(prop_coop_temp)

 % probes: 
 % Ct(t,i); % time evolution of individual thresholds
 % Rtavg(t,i) % average individual reputation of i at t
 % Rtstd(t,i) % std individual reputation of i at t
 % ctavg(t) % mean of the thresholds at t
 % ctstd(t) % std of the thresholds at t
 % prop_coop(t) % proportion of cooperative acts in t
 % DeriddaIX_C(t) % Deridda index at time t for the threshold
 % NClu_C(t) % number of cluster at time t for the threshold
 % DeriddaIX_R(t) % Deridda index at time t for the average R for each i
 % NClu_R(t) % number of cluster at time t for the average R for each i
 % Sim= similarity matrix at time t (not sure of its usefulness)
 % S1(t,i)= for each individual, at time t, tells the number of others similar
 % to him.
 % S2(t,i)= for each individual and time, the average similarity
 % polariz(t)=polarization(N,R); % polarization index as in Mas & Flache 2008a
 % VarR(t)= Average std of R(i,:), one value per time step
 % Diver(t) % diversity as in Mas & Flache 2008a
 % Rsq(t) R^2 of the regression c=beta*R + beta*1
 % S_IX= average similarity in the sim matrix
 % +++ Heatmap of the present R matrixes: TO DO MANUALLY, IT IS HEAVY TO DO
 % IT AUTHOMATICALLY AND PROBABLY USELESS +++
 
 