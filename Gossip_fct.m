function [prop_coop,ctavg,ctstd,DeriddaIX_C,NClu_C,DeriddaIX_R,NClu_R,S_IX,polariz,VarR,Diver,Rsq,Prop_true_gossip]=Gossip_fct(N,mu,tmax,type_payoff,alpha,betaa,Perr,nu,MAXC,DeltaR,type_choice_gossip_partner,type_choice_gossiped,...
    type_comunication,type_belief_update,gossip,gamma,memory,noise,timestheinteractions,absolutethreshold,change_partners,info_always_uptodate)
% This is the main function that run the model. Once called it runs the
% model with the parameters passed in input. The only constants set in this
% function are those concerning the payoffs from different situations in
% the prisoner dilemma (see paper).


warning off
costcomm=0;

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
% the next line transforms the textual choices concerning the strategy for
% partner and target selection into number (merely for speed)
[type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner]=turn_names_into_numbers(type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner);
if nu>mu; disp('nu cannot exceed mu, nu setted == mu. Click to continue'); nu=mu; pause; end % control that nu<=mu and if not correct the error.
for i=1:N; R(i,i)=0; end % no self reputation (for the moment).
Push=round(MAXC*DeltaR); % set the push to reputation (up or down, derived from interactions)

RegLatVct = makeringlatticeCIJ(N,mu*N); % i create a latice with mu connections per node, the connections will be used to calculate the peers.
AltersOfIatT=RegLattRecall(N,mu,RegLatVct);


timeknown=zeros(N,N); % this is the matrix that collect info on who, at any given time, received gossip that remember about whom.

tic
for t=1:tmax % for each time step
    R_old=R; % every agent only knows the previous R of everybody else (symmetric updating).
    
    
    PayoffsAtT=zeros(N,mu)-1; % initialize payoffs matrix for each interaction (wull be filled with real results)
    Payoff_evolutionary=zeros(N,1); % intialize the vector containing the payoffs that will be used for evolution
    
    PlayOfAltersOfI=zeros(N,mu); %initialize the matrix containing for each agent the set of partners for interaction for this time (changed at every time step)
    if change_partners==1
        AltersOfIatT=RegLattRecall(N,mu,RegLatVct); % %this assign to each agent mu peers for interactions in this step.
    end
    
    % INTERACTION PHASE (COUPLES OF AGENTS MEET AND PLAY THE PD)
    for ego=1:N % for each agent
        
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
    
    % GOSSIP PHASE: THREE AGENTS ARE SELECTED FOR GOSSIP
    % N*mu*timestheinteractions TIMES
    if gossip==1
        Rj=mean(R,1); % i precompute the average reputation received by each j in the matrix (columnwise).
        for j=1:N*mu*timestheinteractions
            ego=ceil(rand*N); % select randomly one agent (even if he has already played).
            alter=chose_gossip_partner(ego,R(ego,:),type_choice_gossip_partner,AltersOfIatT(ego,:),mu);
            other=chose_gossiped_agent(ego,alter,AltersOfIatT(ego,:),R(ego,:),PlayOfAltersOfI(ego,:),type_choice_gossiped,Rj,R);
            
            % Keeps track of who knows what about whom:
            % if other has played with ego, then he passes the info to alter, which then knows th threshold and the reputation of ego.
            if hasplayed(alter,other)==1
                knowsof(ego,other)=1;
                timeknown(ego,other)=t;
                Cstore(ego,other)=c(other);
                Rstore(ego,other)=R(other,ego);
            end
            % Gossip modifies target's reputation.
            if type_comunication==0; R=gossip_effect(ego,alter,other,alpha,betaa,R,type_belief_update,R(alter,other),Push); end
        end
    end
    
    % after "memory" periods, the memory  of the past interactions is lost
    knowsof(timeknown+memory==t)=0;
    Cstore(timeknown+memory==t)=NaN; % if memory is exceeded then i set to NaN;
    Rstore(timeknown+memory==t)=NaN; % if memory is exceeded then j set to NaN;
    timeknown(timeknown+memory==t)=0; %this should always be late.
    
    
    
    
    true_gossip=0; % not using this anymore. Keeping it for legacy reasons.
    
    
    c=ThresholdEvolution(c,Payoff_evolutionary,AltersOfIatT); % Threshold evolution (evolutionary process)
    
    
end


 % Compute final values for a lot of indicators (unused in the final text
 % of the paper, kept for legacy reasons).
 ctavg=mean(c);
 ctstd=std(c);
 [DeriddaIX_C,NClu_C]=deridda_index(c); 
 [DeriddaIX_R,NClu_R]=deridda_index(mean(R,2)'); % average of the reputation of i according to all ~i
 [~,~,~,S_IX]=similarity(R);
 polariz=polarization(N,R); % polarization index as in Mas & Flache 2008a
 VarR=varianceR(R); % Average std of R(i,:)
 Diver=diversity(N,R); % diversity as in Mas & Flache 2008a
 [~,~,~,~,stats] = regress(c+1,[mean(R,1)' ones(N,1)]);
 Rsq=stats(1);
 Prop_true_gossip=true_gossip/N;
 
