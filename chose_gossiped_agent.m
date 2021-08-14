function other=chose_gossiped_agent(ego,alter,Partners_ego,R_ego,PlayOfAltersOfI,type_choice_gossiped,Rj,R)
% choice of the individual "other" that i gossip about with j. 
% Three different choices are possible:
% ri=uniformly at random from individual among the last interaction partners of ego
% rp= uniformly at random in the whole population
% su= proportional to the surpriseness of the behaviour relative to the expected one
% hr=  the guy gossips people with social reputation higher than what "i" would  attribute to him: proportional to to | R_ij-Rj_mean | if Rij<Rj_mean
% si= gossip about individuals that are similar in social reputation to "i": proportional to 100 - |  R_i_medio - Rj_medio |    

switch type_choice_gossiped
    case 0 %'ri' uniformly at random from individual among the last interaction partners of ego
        Partners_ego(Partners_ego==alter)=[]; % I remove alter from the possible choices (in case it is present).
        other=Partners_ego(ceil(rand*length(Partners_ego))); % random choice of one of the remaining individuals
    case 1 % 'rp' uniformly at random in the whole population
        other=ceil(rand*length(R_ego));
        while (other==alter || other==ego); other=ceil(rand*length(R_ego)); end;
    case 2 % 'su' proportional to the surpriseness of the behaviour relative to the expected one
        posalter=find(Partners_ego==alter); % trovo location alter in vettore contatti di ego
        Partners_ego(posalter)=[]; %elimino quel nodo dai partners
        PlayOfAltersOfI(posalter)=[]; % e ovviamente dal vettore delle azioni
        RofEgo=R_ego(Partners_ego);  %estraggo da R le reputazioni rilevanti (nell'ordine adeguato).
        DistFromExpexted=zeros(length(RofEgo),1);
        for i=1:length(PlayOfAltersOfI)
            if PlayOfAltersOfI==-1 % if defeted i measure the distance from 0
                DistFromExpexted(i)=RofEgo(i);
            else % if cooperated i measure the distance from 100
                DistFromExpexted(i)=100- RofEgo(i);
            end
        end
        otherpos=choose_proportionally(DistFromExpexted);
        other=Partners_ego(otherpos);
    case 3 % 'hr' proportional to |  R_ij-Rj_medio | if Rij<Rj_medio % 'hr' the guy gossips people with social reputation 
        %higher than what i would attribute to him
        Rj(Rj<R(ego,:))=0; % those below me have weight 0
        Rj(Rj>=R(ego,:))=Rj(Rj>=R(ego,:))-R(ego,Rj>=R(ego,:)); % those above me have weight Rj_medio-R_ij
        Rj(ego)=0; % can't gossip about myself 
        Rj(alter)=0; % can't gossip about alter
        other=choose_proportionally(Rj); 
        
    case 4 % 'si' proportional to 100 - |  R_i_medio - Rj_medio | 'si' gossip about individuals that are similar in social reputation to me.
        Rj=100-abs(Rj(ego)-Rj);
        Rj(ego)=0; % can't gossip about myself 
        Rj(alter)=0;% can't gossip about alter
        other=choose_proportionally(Rj);
        
    case 5 % 'rj' proportional to Rj 'rj'
        Rj=100-Rj;
        Rj(ego)=0; % can't gossip about myself 
        Rj(alter)=0;% can't gossip about alter
        other=choose_proportionally(Rj); 
end

      
