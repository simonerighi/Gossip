function alter=chose_gossip_partner(ego,R,type_choice_gossip_partner,AltersOfIatT,mu)
% Procedure for the  selection for the partner which which to gossip.
% Four possibilities are available:
% type_choice_gossip_partner=='ra'== 0 % ra=uniformly at random among all agents; 
% type_choice_gossip_partner=='pr'== 1 % pr=proportionally to R(i,j); 
% type_choice_gossip_partner=='ri'== 2 % ri= uniformly at random among last round interacting partners;
% type_choice_gossip_partner=='pi'== 3 

N=length(R);

switch type_choice_gossip_partner
case 0 % ra=uniformly at random among all agents;
    alter=ceil(rand*N);
    while alter==ego; alter=ceil(rand*N); end % to avoid ego==alter (should be faster than selecting from vector without ego).       
case 1 % pr=proportionally to R(i,j); 
    alter=ego;
    while alter==ego 
        wR=R./sum(R);   % wR sums to 1
        alter = find(rand <= cumsum(wR), 1); %choose proportionally
    end
case 2 % ri= uniformly at random among last round interacting partners;
    alter=AltersOfIatT(1,ceil(rand*mu));
case 3 % pi=proportionally to R(i,j), but among onnly the last round interaction partners
    RR=R(AltersOfIatT); % i select only the individual ego has played with
    wR=RR./sum(RR);   % wR sums to 1
    alterpos = find(rand <= cumsum(wR), 1); %choose proportionally
    alter=AltersOfIatT(alterpos);
end

                               
                                 
